`timescale 1ns/1ps
//-----------------------------------------------------------------------------
// Reconstruction for the split-CDAC SAR (sar_split_cal_logic).
//
//   X    = C_off + sum_{i=0..11} d_i * C_i          (d_i = decision of comparison i)
//   code = sat_[0,1023]( floor(X) )
//
// X estimates the continuous output position y = Vin/LSB + 512, so code k
// means y in [k, k+1).  Coefficients are fixed point with F fractional bits:
//   C_i   : unsigned, CW bits  (Q(CW-F).F)
//   C_off : signed,   AW bits  (Q(AW-F).F, two's complement)
// Nominal set (derived from the topology, see results/cdac_split_cal_report.md):
//   C_0..C_10 = 528 264 132 66 33 32 16 8 4 2 1,  C_11 = 0.5,  C_off = -31.25
// The nominal set is a hard-wired ROM; a programmable register set (reset to
// the same nominal values) is used when cal_en = 1.  cal_en is sampled once
// per conversion (at raw_stb) so a conversion never mixes the two sets.
//
// Area-conscious shared accumulator: one adder, NCMP+1 cycles per word
// (13 cycles), started by raw_stb; fits in the 26-cycle sampling phase of the
// following frame.  valid is a 1-cycle pulse; code/raw_q/sat hold until the
// next valid.
//
// Coefficient write port (synchronous):  cal_we=1, cal_addr = 0..11 -> C_i,
// cal_addr = 12 -> C_off (all AW bits).  Other addresses are ignored.
// Writes are applied immediately; the loader should write while the ADC is
// idle or accept that the word in flight may use partly updated values.
//
// Unreachable raw words (the redundant search never produces them) are
// decoded by the same formula and saturated; they carry no meaning.
//
// INTERVAL = 1 (default since 2026-10-07): interval-midpoint decoding.
//   With redundancy the raw word identifies an input INTERVAL bounded by the
//   thresholds of its own decisions: decision i compares the input with
//     T_i = C_off + S_all/2 + A_i - S_i/2,   A_i = sum_{j<i} d_j C_j,
//                                             S_i = sum_{j<i} C_j,
//   d_i = 1 means input > T_i.  L = max T_i over d_i = 1, U = min T_i over
//   d_i = 0, and  code = sat(floor((L + U)/2))  (L := U - 1 or U := L + 1 when
//   one side has no constraint).  Near a main-step boundary the linear sum can
//   sit up to ~1 u away from its truncated interval and floor() then steps
//   back one code; the interval midpoint is strictly increasing in the
//   interval order whenever the coefficients order the thresholds correctly,
//   so the transfer is monotonic for exact (calibrated) coefficients and,
//   with the nominal ROM, on the typical array.  Same coefficients, same
//   13-cycle schedule and latency; uses two extra comparators/registers.
// INTERVAL = 0: the reviewed linear decoder above (candidate_r1).
//
// r3 (2026-10-07), behaviour-preserving controller optimisation:
//  * clock gating (CLOCK_GATING = 1): every coefficient word has its own
//    glitch-free integrated clock gate (gf180 icgtp_1 in the std-cell build,
//    latch + AND model otherwise) enabled only by its own accepted write; the
//    reconstruction registers share one gate enabled by raw_stb | run | valid.
//  * calibration-write protocol: a write is IGNORED while a reconstruction that
//    uses the programmable set is pending or in progress (raw_stb with cal_en,
//    or run with use_cal), so a calibrated word never mixes coefficient sets.
//    Supported procedure: program all 13 words with cal_en = 0 (ROM in use;
//    writes always accepted, also during sustained conversion), then set
//    cal_en = 1.  cal_en is sampled per conversion at raw_stb.
//  * arithmetic widened (IW = AW + 5): no overflow for ANY programmable
//    coefficient values (C_i < 2^CW, |C_off| < 2^(AW-1)); r2 wrapped when the
//    accumulated sum exceeded 2^(AW-1) (> 2048 LSB), unreachable with the
//    nominal set (1087.5 LSB).
//-----------------------------------------------------------------------------
module sar_split_cal_recon #(
    parameter integer NCMP = 12,
    parameter integer F    = 6,    // fractional bits
    parameter integer CW   = 16,   // coefficient width (unsigned)
    parameter integer AW   = 18,   // offset width (signed) = cal_wdata width
    parameter integer INTERVAL = 1, // 1: interval-midpoint decoding, 0: linear (candidate_r1)
    parameter integer CLOCK_GATING = 1
)(
    input  wire              clk,
    input  wire              rst_n,
    input  wire              raw_stb,
    input  wire [NCMP-1:0]   raw,       // raw[NCMP-1-i] = decision of comparison i
    input  wire              cal_en,
    input  wire              cal_we,
    input  wire [3:0]        cal_addr,
    input  wire [AW-1:0]     cal_wdata,

    output reg  [9:0]        code,
    output reg  [NCMP-1:0]   raw_q,
    output reg               sat,
    output reg               valid
);

    // nominal coefficients in Q.F
    function [CW-1:0] c_nom(input [3:0] k);
        case (k)
            4'd0:  c_nom = 528 << F;
            4'd1:  c_nom = 264 << F;
            4'd2:  c_nom = 132 << F;
            4'd3:  c_nom =  66 << F;
            4'd4:  c_nom =  33 << F;
            4'd5:  c_nom =  32 << F;
            4'd6:  c_nom =  16 << F;
            4'd7:  c_nom =   8 << F;
            4'd8:  c_nom =   4 << F;
            4'd9:  c_nom =   2 << F;
            4'd10: c_nom =   1 << F;
            4'd11: c_nom =   1 << (F - 1);          // 0.5
            default: c_nom = {CW{1'b0}};
        endcase
    endfunction
    localparam signed [AW-1:0] OFF_NOM = -(125 << (F - 2));   // -31.25

    // ---- widths: A <= NCMP*(2^CW-1) < 2^(CW+4); 2A, S, 2*C_off, thresholds and their sums fit IW bits ----
    localparam integer IW = AW + 5;

    reg  [CW-1:0]        coef [0:NCMP-1];
    reg  signed [AW-1:0] coff;
    reg  [NCMP-1:0]      rb;
    reg                  use_cal, run;
    reg  [3:0]           k;
    reg  signed [IW-1:0] acc;           // A_k = sum_{j<k} d_j C_j   (offset NOT included)
    reg  signed [IW-1:0] sacc;          // S_k = sum_{j<k} C_j
    reg  signed [IW-1:0] lo, hi;        // running max / min of 2*A_k - S_k
    reg                  has_lo, has_hi;
    integer j;

    wire [CW-1:0]        c_sel    = use_cal ? coef[k] : c_nom(k);
    wire signed [AW-1:0] coff_sel = use_cal ? coff : OFF_NOM;
    wire                 d_k      = rb[NCMP-1-k];
    wire signed [IW-1:0] c_ext    = $signed({{(IW-CW){1'b0}}, c_sel});
    wire signed [IW-1:0] coff_x   = $signed({{(IW-AW){coff_sel[AW-1]}}, coff_sel});
    wire signed [IW-1:0] acc_n    = acc + (d_k ? c_ext : {IW{1'b0}});

    // ---- linear path (INTERVAL = 0): X = C_off + A_12 ----
    wire signed [IW-1:0]   x_lin  = coff_x + acc_n;
    wire signed [IW-F-1:0] y_int  = x_lin >>> F;                       // floor

    // ---- interval-midpoint path (values in units of 2^-(F+1) output LSB) ----
    wire signed [IW-1:0] t_k    = (acc <<< 1) - sacc;                  // 2*A_k - S_k
    wire signed [IW-1:0] lo_n   = (d_k && (!has_lo || t_k > lo)) ? t_k : lo;
    wire signed [IW-1:0] hi_n   = (!d_k && (!has_hi || t_k < hi)) ? t_k : hi;
    wire                 hlo_n  = has_lo | d_k;
    wire                 hhi_n  = has_hi | !d_k;
    wire signed [IW-1:0] s_all  = sacc + c_ext;                        // S_12 on the last cycle
    wire signed [IW-1:0] kconst = (coff_x <<< 1) + s_all;              // 2*C_off + S_all
    wire signed [IW-1:0] lo_f   = hlo_n ? lo_n + kconst : hi_n + kconst - (1 <<< (F + 1));
    wire signed [IW-1:0] hi_f   = hhi_n ? hi_n + kconst : lo_n + kconst + (1 <<< (F + 1));
    wire signed [IW:0]   msum   = lo_f + hi_f;                         // 2*(L+U) in Q.F
    wire signed [IW-F-1:0] m_int = msum >>> (F + 2);                   // floor((L+U)/2)

    // ---- clock domains ----
    // a write is IGNORED only while a reconstruction that uses the programmable set is pending or
    // in progress; with cal_en = 0 (ROM in use) programming is always accepted
    wire cal_busy = (raw_stb & cal_en) | (run & use_cal);
    wire we_ok    = cal_we & ~cal_busy;
    wire en_r    = raw_stb | run | valid;            // recon registers need clock only then
    wire clk_r;
    wire [NCMP:0] clk_c;
    generate
        if (CLOCK_GATING != 0) begin : g_cg
            sar_split_cal_cg u_cg_r (.clk(clk), .en(en_r), .gclk(clk_r));
            genvar g;
            for (g = 0; g <= NCMP; g = g + 1) begin : g_cw
                sar_split_cal_cg u_cg_c (.clk(clk), .en(we_ok & (cal_addr == g)), .gclk(clk_c[g]));
            end
        end else begin : g_nocg
            assign clk_r = clk;
            assign clk_c = {(NCMP+1){clk}};
        end
    endgenerate

    // coefficient registers: one (gated) clock per word; reset to the nominal set
    genvar gc;
    generate
        for (gc = 0; gc < NCMP; gc = gc + 1) begin : g_coef
            always @(posedge clk_c[gc] or negedge rst_n) begin
                if (!rst_n)
                    coef[gc] <= c_nom(gc);
                else if (CLOCK_GATING != 0 || (we_ok && cal_addr == gc))
                    coef[gc] <= cal_wdata[CW-1:0];
            end
        end
    endgenerate
    always @(posedge clk_c[NCMP] or negedge rst_n) begin
        if (!rst_n)
            coff <= OFF_NOM;
        else if (CLOCK_GATING != 0 || (we_ok && cal_addr == NCMP))
            coff <= cal_wdata;
    end

    // shared accumulator (13 cycles after raw_stb)
    always @(posedge clk_r or negedge rst_n) begin
        if (!rst_n) begin
            run <= 1'b0; k <= 4'd0; acc <= {IW{1'b0}}; rb <= {NCMP{1'b0}};
            sacc <= {IW{1'b0}}; lo <= {IW{1'b0}}; hi <= {IW{1'b0}}; has_lo <= 1'b0; has_hi <= 1'b0;
            use_cal <= 1'b0;
            code <= 10'd0; raw_q <= {NCMP{1'b0}}; sat <= 1'b0; valid <= 1'b0;
        end else begin
            valid <= 1'b0;
            if (raw_stb) begin
                rb      <= raw;
                use_cal <= cal_en;
                acc     <= {IW{1'b0}};
                k       <= 4'd0;
                run     <= 1'b1;
                sacc    <= {IW{1'b0}};
                has_lo  <= 1'b0;
                has_hi  <= 1'b0;
            end else if (run) begin
                acc <= acc_n;
                k   <= k + 1'b1;
                sacc   <= s_all;
                lo     <= lo_n;   hi     <= hi_n;
                has_lo <= hlo_n;  has_hi <= hhi_n;
                if (k == NCMP - 1) begin
                    run   <= 1'b0;
                    raw_q <= rb;
                    valid <= 1'b1;
                    if (INTERVAL != 0) begin
                        if (msum < 0) begin
                            code <= 10'd0;    sat <= 1'b1;
                        end else if (m_int > 1023) begin
                            code <= 10'd1023; sat <= 1'b1;
                        end else begin
                            code <= m_int[9:0]; sat <= 1'b0;
                        end
                    end else if (x_lin < 0) begin
                        code <= 10'd0;    sat <= 1'b1;
                    end else if (y_int > 1023) begin
                        code <= 10'd1023; sat <= 1'b1;
                    end else begin
                        code <= y_int[9:0]; sat <= 1'b0;
                    end
                end
            end
        end
    end

endmodule


//-----------------------------------------------------------------------------
// Glitch-free clock gate.  Std-cell build (+define+SAR_CG_STDCELL): the gf180
// integrated clock-gating cell icgtp_1 (enable latch transparent while CLK is
// low + AND).  Otherwise an equivalent behavioural latch + AND (RTL simulation
// and the generic-gate XSPICE view, where it maps to an XSPICE d_dlatch).
//-----------------------------------------------------------------------------
module sar_split_cal_cg (
    input  wire clk,
    input  wire en,
    output wire gclk
);
`ifdef SAR_CG_STDCELL
    gf180mcu_fd_sc_mcu7t5v0__icgtp_1 u_icg (.TE(1'b0), .E(en), .CLK(clk), .Q(gclk));
`else
    reg en_l;
    always @(*) if (!clk) en_l = en;     // transparent while clk is low
    assign gclk = clk & en_l;
`endif
endmodule
