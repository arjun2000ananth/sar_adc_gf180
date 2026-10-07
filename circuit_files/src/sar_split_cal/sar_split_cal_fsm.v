`timescale 1ns/1ps
//-----------------------------------------------------------------------------
// SAR controller for the compact redundant split CDAC
// (xschem/cdac_caps_10b_diff_split_cal.sch).  Derived from src/sar_fsm/sar_fsm.v:
// same reset style (async active-low), same comparator polarity convention,
// same monotonic up-going switching (raise the LOWER side's cap).
//
// Search: comparison 0 with every bottom plate at VCM, then after comparison
// i (i = 0..NSTEP-1) raise step i on the lower side; comparison NSTEP is a
// final residual-sign decision (no switching).  NSTEP = 11 -> 12 comparisons.
//
//   step index : 0   1   2   3   4   5   6   7   8   9   10
//   CDAC port  : b9  b8  b7  b6  b5  br  b4  b3  b2  b1  b0   (p and n halves)
//
// Fixed frame of FRAME = SAMPLE_CYCLES + (NSTEP+1)*(SETTLE_CYCLES+EVAL_CYCLES)
// clock cycles (50 at the defaults = 1.000 us at 50 MHz):
//   cycles 0 .. SAMPLE_CYCLES-1            : sample = 1 (input tracks on vcp/vcn)
//   cycles 0 .. SAMPLE_CYCLES-1-RST_LEAD   : rstf   = 1 (fine nodes vfp/vfn -> VCM)
//   then per comparison slot j = 0..NSTEP:
//      SETTLE_CYCLES : comp_clk = 0 (comparator reset, DAC settling)
//      EVAL_CYCLES   : comp_clk = 1 (comparator evaluates)
//   The decision of slot j is captured on the clock edge that ends its last
//   EVAL cycle; the same edge drives the step-j bottom-plate switch.
// The capture edge of the final slot is cycle 0 of the next frame: if start
// is high at that edge the next frame begins immediately (sustained mode,
// exactly one conversion per FRAME cycles), otherwise the FSM idles.
// start is sampled only while idle and at that frame-end edge; a start
// pulse that is low at both of those instants is ignored (no abort, no queue).
//
// Every output going to the analog section is a flop output (no glitches).
// comp is captured synchronously; the StrongARM output stage holds its
// decision during reset, and EVAL_CYCLES*Tclk (20 ns) bounds the decision time.
//-----------------------------------------------------------------------------
module sar_split_cal_logic #(
    parameter integer NSTEP         = 11,
    parameter integer SAMPLE_CYCLES = 26,
    parameter integer RST_LEAD      = 1,   // rstf falls RST_LEAD cycles before sample
    parameter integer SETTLE_CYCLES = 1,
    parameter integer EVAL_CYCLES   = 1,
    parameter         INVERT_COMP   = 1'b0  // 1'b1 if comp is wired from Voutn
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire             start,
    input  wire             comp,

    output reg              sample,
    output reg              rstf,
    output reg              comp_clk,
    output reg              busy,
    output reg              raw_stb,    // 1-cycle pulse: raw[] holds a new word

    output reg  [NSTEP-1:0] bp,         // bp[i] = 1 -> P-half step i at VREFP
    output reg  [NSTEP-1:0] bn,
    output reg  [NSTEP:0]   raw         // raw[NSTEP-i] = decision of comparison i
);

    localparam integer SLOT  = SETTLE_CYCLES + EVAL_CYCLES;
    localparam integer FRAME = SAMPLE_CYCLES + (NSTEP + 1) * SLOT;
    localparam integer CW    = 7;       // cycle counter width (FRAME <= 127)
    localparam integer SW    = 4;       // slot counter width (NSTEP+1 <= 15)

    wire cmp_p_gt_n = INVERT_COMP ? ~comp : comp;

    reg            run;
    reg [CW-1:0]   cyc;                 // index of the current frame cycle
    reg [SW-1:0]   slot;                // comparison slot of the current cycle
    reg [2:0]      sub;                 // position inside the slot
    reg [NSTEP:0]  dec;                 // decisions of the running frame

    wire in_cmp     = (cyc >= SAMPLE_CYCLES);
    wire capture    = run && in_cmp && (sub == SLOT - 1);
    wire last_cycle = (cyc == FRAME - 1);

    // next-cycle schedule
    wire [CW-1:0] cyc_n  = last_cycle ? {CW{1'b0}} : cyc + 1'b1;
    wire          cmp_n  = (cyc_n >= SAMPLE_CYCLES);
    wire [2:0]    sub_n  = (!cmp_n || cyc_n == SAMPLE_CYCLES || sub == SLOT - 1) ? 3'd0 : sub + 1'b1;
    wire [SW-1:0] slot_n = (!cmp_n || cyc_n == SAMPLE_CYCLES) ? {SW{1'b0}} :
                           (sub == SLOT - 1) ? slot + 1'b1 : slot;

    integer i;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            run      <= 1'b0;
            cyc      <= {CW{1'b0}};
            slot     <= {SW{1'b0}};
            sub      <= 3'd0;
            sample   <= 1'b0;
            rstf     <= 1'b0;
            comp_clk <= 1'b0;
            busy     <= 1'b0;
            raw_stb  <= 1'b0;
            bp       <= {NSTEP{1'b0}};
            bn       <= {NSTEP{1'b0}};
            dec      <= {(NSTEP+1){1'b0}};
            raw      <= {(NSTEP+1){1'b0}};
        end else begin
            raw_stb <= 1'b0;

            if (!run) begin
                // ---------------- idle: all switches open, DAC at VCM ----------
                sample   <= 1'b0;
                rstf     <= 1'b0;
                comp_clk <= 1'b0;
                bp       <= {NSTEP{1'b0}};
                bn       <= {NSTEP{1'b0}};
                if (start) begin            // outputs of frame cycle 0
                    run    <= 1'b1;
                    busy   <= 1'b1;
                    cyc    <= {CW{1'b0}};
                    slot   <= {SW{1'b0}};
                    sub    <= 3'd0;
                    sample <= 1'b1;
                    rstf   <= (SAMPLE_CYCLES - RST_LEAD > 0);
                end else begin
                    busy   <= 1'b0;
                end
            end else begin
                // ---------------- decision capture + DAC step ------------------
                if (capture) begin
                    for (i = 0; i <= NSTEP; i = i + 1)
                        if (slot == i) dec[NSTEP - i] <= cmp_p_gt_n;
                    for (i = 0; i < NSTEP; i = i + 1)
                        if (slot == i) begin
                            if (cmp_p_gt_n) bn[i] <= 1'b1;   // vcp > vcn: raise vcn
                            else            bp[i] <= 1'b1;   // vcp < vcn: raise vcp
                        end
                end

                cyc  <= cyc_n;
                slot <= slot_n;
                sub  <= sub_n;

                // ---------------- registered phase outputs for cycle cyc_n ----
                sample   <= (cyc_n < SAMPLE_CYCLES);
                rstf     <= (cyc_n + RST_LEAD < SAMPLE_CYCLES);
                comp_clk <= cmp_n && (sub_n >= SETTLE_CYCLES);

                if (last_cycle) begin
                    // final residual-sign decision is captured on this edge
                    raw     <= {dec[NSTEP:1], cmp_p_gt_n};
                    raw_stb <= 1'b1;
                    bp      <= {NSTEP{1'b0}};
                    bn      <= {NSTEP{1'b0}};
                    if (!start) begin
                        run      <= 1'b0;
                        busy     <= 1'b0;
                        sample   <= 1'b0;
                        rstf     <= 1'b0;
                        comp_clk <= 1'b0;
                    end
                end
            end
        end
    end

endmodule
