`timescale 1ns/1ps
//-----------------------------------------------------------------------------
// Calibration-interface testbench (r3).  Checks the supported programming
// protocol of sar_split_cal_recon against an independent reference:
//  A  writes with cal_en = 0 during SUSTAINED conversion are accepted and the
//     conversions in progress keep using the ROM (nominal) set
//  B  cal_en = 1 takes effect per conversion (sampled at raw_stb): every code
//     equals the reference with exactly one coefficient set (old or new)
//  C  a write issued while a CALIBRATED word is in flight (raw_stb..valid) is
//     ignored: that word uses the old set and the register keeps its old value
//  D  asynchronous reset restores the nominal register values
// The comparator is scripted; the reference is the interval decoder written
// independently below (Q.6, 2T_i = 2*C_off + S_all + 2*A_i - S_i).
//-----------------------------------------------------------------------------
module tb_sar_split_cal_calif;
    reg clk = 1'b0, rst_n = 1'b0, start = 1'b0, comp = 1'b0;
    reg cal_en = 1'b0, cal_we = 1'b0;
    reg [3:0]  cal_addr = 4'd0;
    reg [17:0] cal_wdata = 18'd0;
    wire sample, rstf, comp_clk, busy, valid, raw_stb, sat;
    wire [10:0] bp, bn;
    wire [9:0]  code;
    wire [11:0] raw;
    sar_split_cal_wrapper dut (
        .clk(clk), .rst_n(rst_n), .start(start), .comp(comp), .cal_en(cal_en), .cal_we(cal_we),
        .cal_addr3(cal_addr[3]), .cal_addr2(cal_addr[2]), .cal_addr1(cal_addr[1]), .cal_addr0(cal_addr[0]),
        .cal_wdata17(cal_wdata[17]), .cal_wdata16(cal_wdata[16]), .cal_wdata15(cal_wdata[15]),
        .cal_wdata14(cal_wdata[14]), .cal_wdata13(cal_wdata[13]), .cal_wdata12(cal_wdata[12]),
        .cal_wdata11(cal_wdata[11]), .cal_wdata10(cal_wdata[10]), .cal_wdata9(cal_wdata[9]),
        .cal_wdata8(cal_wdata[8]), .cal_wdata7(cal_wdata[7]), .cal_wdata6(cal_wdata[6]),
        .cal_wdata5(cal_wdata[5]), .cal_wdata4(cal_wdata[4]), .cal_wdata3(cal_wdata[3]),
        .cal_wdata2(cal_wdata[2]), .cal_wdata1(cal_wdata[1]), .cal_wdata0(cal_wdata[0]),
        .sample(sample), .rstf(rstf), .comp_clk(comp_clk), .busy(busy), .valid(valid),
        .raw_stb(raw_stb), .sat(sat),
        .bp9(bp[0]), .bp8(bp[1]), .bp7(bp[2]), .bp6(bp[3]), .bp5(bp[4]), .bpr(bp[5]),
        .bp4(bp[6]), .bp3(bp[7]), .bp2(bp[8]), .bp1(bp[9]), .bp0(bp[10]),
        .bn9(bn[0]), .bn8(bn[1]), .bn7(bn[2]), .bn6(bn[3]), .bn5(bn[4]), .bnr(bn[5]),
        .bn4(bn[6]), .bn3(bn[7]), .bn2(bn[8]), .bn1(bn[9]), .bn0(bn[10]),
        .code9(code[9]), .code8(code[8]), .code7(code[7]), .code6(code[6]), .code5(code[5]),
        .code4(code[4]), .code3(code[3]), .code2(code[2]), .code1(code[1]), .code0(code[0]),
        .raw11(raw[11]), .raw10(raw[10]), .raw9(raw[9]), .raw8(raw[8]), .raw7(raw[7]), .raw6(raw[6]),
        .raw5(raw[5]), .raw4(raw[4]), .raw3(raw[3]), .raw2(raw[2]), .raw1(raw[1]), .raw0(raw[0])
    );
    always #10 clk = ~clk;

    integer errors = 0;
    task err(input [8*80-1:0] m); begin errors = errors + 1; $display("ERROR t=%0t : %0s", $time, m); end endtask

    // scripted comparator: decision word per frame from a fixed list
    reg [11:0] words [0:63];
    integer fidx = 0, slot = 0;
    always @(posedge sample) slot = 0;
    always @(posedge comp_clk) begin comp = words[fidx % 64][11 - slot]; slot = slot + 1; end
    always @(posedge raw_stb) fidx = fidx + 1;

    // reference coefficient sets
    integer cnom [0:11]; integer onom;
    integer cnew [0:11]; integer onew;
    function integer refc(input [11:0] w, input integer which);   // which: 0 nominal, 1 new
        integer a, sm, lo, hi, hl, hh, t, i, kc, lof, hif, ms, y, c, off;
        begin
            a = 0; sm = 0; hl = 0; hh = 0; lo = 0; hi = 0;
            for (i = 0; i < 12; i = i + 1) begin
                c = which ? cnew[i] : cnom[i];
                t = 2 * a - sm;
                if (w[11 - i]) begin if (!hl || t > lo) lo = t; hl = 1; a = a + c; end
                else           begin if (!hh || t < hi) hi = t; hh = 1; end
                sm = sm + c;
            end
            off = which ? onew : onom;
            kc = 2 * off + sm;
            lof = hl ? lo + kc : hi + kc - 128;
            hif = hh ? hi + kc : lo + kc + 128;
            ms = lof + hif;
            y = (ms >= 0) ? ms / 256 : -((-ms + 255) / 256);
            refc = (y < 0) ? 0 : ((y > 1023) ? 1023 : y);
        end
    endfunction

    // record every valid: (raw, code)
    reg [11:0] vraw [0:255]; reg [9:0] vcode [0:255]; integer nv = 0;
    always @(negedge clk) if (valid) begin vraw[nv] = raw; vcode[nv] = code; nv = nv + 1; end

    task write_word(input [3:0] a, input integer d);
    begin @(negedge clk); cal_we = 1; cal_addr = a; cal_wdata = d[17:0]; @(negedge clk); cal_we = 0; end
    endtask

    integer i, n0, n1, okc, okn, both, kk;
    initial begin
        $dumpfile("tb_sar_split_cal_calif.vcd"); $dumpvars(0, tb_sar_split_cal_calif);
        cnom[0]=528*64; cnom[1]=264*64; cnom[2]=132*64; cnom[3]=66*64; cnom[4]=33*64; cnom[5]=32*64;
        cnom[6]=16*64; cnom[7]=8*64; cnom[8]=4*64; cnom[9]=2*64; cnom[10]=64; cnom[11]=32; onom = -2000;
        for (i = 0; i < 12; i = i + 1) cnew[i] = cnom[i] + ((i * 37) % 23) - 11;   // distinct programmed set
        cnew[11] = 29; onew = -2100;
        for (i = 0; i < 64; i = i + 1) words[i] = $random;
        repeat (3) @(negedge clk); rst_n = 1;
        // ---- A: sustained conversion, cal_en = 0, program all 13 words at arbitrary times ----
        @(negedge clk); start = 1;
        repeat (75) @(negedge clk);                    // mid-reconstruction of frame 0 / start of frame 1
        for (i = 0; i < 12; i = i + 1) begin write_word(i, cnew[i]); repeat (3) @(negedge clk); end
        write_word(12, onew & 18'h3FFFF);
        repeat (2 * 50) @(negedge clk);
        n0 = nv;
        for (i = 0; i < n0; i = i + 1) if (vcode[i] !== refc(vraw[i], 0)) err("A: ROM-mode code mismatch during programming");
        // (acceptance of the writes is checked behaviourally in B: codes must equal the NEW set)
        // ---- B: switch to the programmed set while converting ----
        @(negedge clk); cal_en = 1;
        repeat (4 * 50) @(negedge clk);
        n1 = nv; okc = 0; okn = 0; both = 0;
        for (i = n0; i < n1; i = i + 1) begin
            if (vcode[i] === refc(vraw[i], 1)) okc = okc + 1;
            if (vcode[i] === refc(vraw[i], 0)) okn = okn + 1;
            if (vcode[i] !== refc(vraw[i], 1) && vcode[i] !== refc(vraw[i], 0)) err("B: code matches neither set");
        end
        if (vcode[n1 - 1] !== refc(vraw[n1 - 1], 1)) err("B: programmed set not in use after cal_en = 1 (writes lost?)");
        if (okc < 2) err("B: too few conversions with the programmed set");
        // ---- C: write while a CALIBRATED word is in flight: must be ignored ----
        @(posedge raw_stb); @(negedge clk);              // reconstruction of a calibrated word in progress
        kk = nv;
        write_word(4'd0, 1000 * 64);                     // would change C_0 drastically if accepted
        while (nv == kk) @(negedge clk);
        if (vcode[kk] !== refc(vraw[kk], 1)) err("C: in-flight word did not use the old (consistent) set");
        // the ignored write must not have changed C_0: the following calibrated words still match the set
        kk = nv;
        while (nv < kk + 2) @(negedge clk);
        for (i = kk; i < nv; i = i + 1) if (vcode[i] !== refc(vraw[i], 1)) err("C: ignored write changed the coefficient set");
        // a write in the bit-cycling phase (no reconstruction pending) is accepted: C_0 += 5*64, check next words
        @(posedge raw_stb); repeat (30) @(negedge clk);   // frame cycle ~30: reconstruction finished, bit cycling
        cnew[0] = cnew[0] + 320;
        write_word(4'd0, cnew[0]);
        kk = nv;
        while (nv < kk + 3) @(negedge clk);
        for (i = kk + 1; i < nv; i = i + 1) if (vcode[i] !== refc(vraw[i], 1)) err("C: write outside reconstruction not accepted");
        // ---- D: reset restores nominal registers ----
        start = 0; repeat (120) @(negedge clk);
        rst_n = 0; repeat (2) @(negedge clk); rst_n = 1; repeat (2) @(negedge clk);
        // with cal_en = 1 the programmable registers are used: after reset they must hold the nominal set
        kk = nv; start = 1;
        while (nv < kk + 4) @(negedge clk);
        start = 0;
        for (i = kk + 1; i < nv; i = i + 1) if (vcode[i] !== refc(vraw[i], 0)) err("D: reset did not restore the nominal registers");
        $display("==================================================");
        $display(" cal-interface TB: %0d valids (B: %0d programmed-set, %0d ROM-set codes), errors = %0d", nv, okc, okn, errors);
        $display(" RESULT %0s", errors == 0 ? "PASS" : "FAIL");
        $display("==================================================");
        $finish;
    end
    initial begin #2_000_000; $display("RESULT FAIL (timeout)"); $finish; end
endmodule
