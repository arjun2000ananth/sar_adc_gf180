`timescale 1ns/1ps
//-----------------------------------------------------------------------------
// Reset-interruption testbench (review addition; complements
// tb_sar_split_cal_fsm.v, which only resets while idle).
//
// Scenarios, each with a scripted comparator:
//  A  rst_n asserted in the middle of the bit-cycling phase of a sustained
//     frame (frame cycle 33): all analog controls and busy must drop
//     asynchronously (checked 1 ns after the rst_n fall), no valid may follow
//  B  rst_n asserted after raw_stb but before valid (reconstruction of the
//     previous frame pending, frame cycle 55 of the sustained sequence): the
//     pending result must be discarded (no valid)
//  C  after each reset: a fresh single conversion converts correctly
//     (raw == script, code == nominal reference) and sustained mode restarts
//     with the exact 1 us cadence
// Prints "RESULT PASS"/"RESULT FAIL"; dumps tb_sar_split_cal_reset_abort.vcd.
//-----------------------------------------------------------------------------
module tb_sar_split_cal_reset_abort;
    localparam integer FRAME = 50;
    reg clk = 1'b0, rst_n = 1'b0, start = 1'b0, comp = 1'b0;
    wire sample, rstf, comp_clk, busy, valid, raw_stb, sat;
    wire [10:0] bp, bn;
    wire [9:0]  code;
    wire [11:0] raw;

    sar_split_cal_wrapper dut (
        .clk(clk), .rst_n(rst_n), .start(start), .comp(comp), .cal_en(1'b0), .cal_we(1'b0),
        .cal_addr3(1'b0), .cal_addr2(1'b0), .cal_addr1(1'b0), .cal_addr0(1'b0),
        .cal_wdata17(1'b0), .cal_wdata16(1'b0), .cal_wdata15(1'b0), .cal_wdata14(1'b0), .cal_wdata13(1'b0),
        .cal_wdata12(1'b0), .cal_wdata11(1'b0), .cal_wdata10(1'b0), .cal_wdata9(1'b0), .cal_wdata8(1'b0),
        .cal_wdata7(1'b0), .cal_wdata6(1'b0), .cal_wdata5(1'b0), .cal_wdata4(1'b0), .cal_wdata3(1'b0),
        .cal_wdata2(1'b0), .cal_wdata1(1'b0), .cal_wdata0(1'b0),
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
    task err(input [8*80-1:0] msg);
    begin errors = errors + 1; $display("ERROR t=%0t : %0s", $time, msg); end
    endtask

    // scripted comparator (decision j = script[11-j]); slot counter restarts at sample
    reg [11:0] script = 12'h000;
    integer slot = 0;
    always @(posedge sample) slot = 0;
    always @(posedge comp_clk) begin comp = script[11 - slot]; slot = slot + 1; end

    // nominal reference reconstruction, interval-midpoint decoding (INTERVAL=1), Q.6
    function [9:0] ref_code(input [11:0] w);
        integer a, sm, lo, hi, hl, hh, t, i, kc, lof, hif, ms, y;
        reg [15:0] c [0:11];
        begin
            c[0] = 33792; c[1] = 16896; c[2] = 8448; c[3] = 4224; c[4] = 2112; c[5] = 2048;
            c[6] = 1024; c[7] = 512; c[8] = 256; c[9] = 128; c[10] = 64; c[11] = 32;
            a = 0; sm = 0; hl = 0; hh = 0; lo = 0; hi = 0;
            for (i = 0; i < 12; i = i + 1) begin
                t = 2 * a - sm;
                if (w[11 - i]) begin if (!hl || t > lo) lo = t; hl = 1; a = a + c[i]; end
                else           begin if (!hh || t < hi) hi = t; hh = 1; end
                sm = sm + c[i];
            end
            kc  = 2 * (-2000) + sm;
            lof = hl ? lo + kc : hi + kc - 128;
            hif = hh ? hi + kc : lo + kc + 128;
            ms  = lof + hif;
            y   = (ms < 0) ? 0 : ms / 256;
            ref_code = (y > 1023) ? 10'd1023 : y[9:0];
        end
    endfunction

    integer nvalid = 0;
    always @(posedge clk) if (valid) nvalid = nvalid + 1;

    task check_quiet(input [8*40-1:0] tag);
    begin
        if (sample !== 1'b0 || rstf !== 1'b0 || comp_clk !== 1'b0 || busy !== 1'b0 || valid !== 1'b0 ||
            bp !== 11'd0 || bn !== 11'd0) begin
            err(tag);
            $display("   sample=%b rstf=%b comp_clk=%b busy=%b valid=%b bp=%b bn=%b", sample, rstf, comp_clk,
                     busy, valid, bp, bn);
        end
    end
    endtask

    task single_conversion(input [11:0] w);
        integer guard;
    begin
        script = w;
        @(negedge clk); start = 1'b1; @(negedge clk); start = 1'b0;
        guard = 0;
        // valid is a one-cycle pulse: sample it mid-cycle (negedge)
        while (!valid && guard < 200) begin @(negedge clk); guard = guard + 1; end
        if (!valid) err("no valid after single conversion");
        else begin
            if (raw !== w) begin err("raw mismatch after reset"); $display("   raw=%h exp=%h", raw, w); end
            if (code !== ref_code(w)) begin err("code mismatch after reset"); $display("   code=%0d exp=%0d", code, ref_code(w)); end
        end
        while (busy) @(posedge clk);
    end
    endtask

    integer n0, k, t_last, gap_err;
    initial begin
        $dumpfile("tb_sar_split_cal_reset_abort.vcd");
        $dumpvars(0, tb_sar_split_cal_reset_abort);
        repeat (3) @(negedge clk); rst_n = 1'b1; repeat (3) @(negedge clk);

        // ---- A: reset during bit cycling ---------------------------------
        script = 12'hA5C;
        @(negedge clk); start = 1'b1;              // sustained
        @(posedge sample);                          // frame 0 starts
        repeat (FRAME + 33) @(posedge clk);         // frame 1, cycle 33 (bit cycling)
        #3; n0 = nvalid;
        if (!busy || (bp == 0 && bn == 0)) err("A: not in bit cycling when reset applied");
        rst_n = 1'b0; #1;
        check_quiet("A: outputs not cleared by async reset");
        start = 1'b0;
        repeat (4) @(negedge clk); rst_n = 1'b1;
        repeat (3 * FRAME) @(negedge clk);
        // frame 0's valid (cycle 13 of frame 1) occurred before the reset; nothing after it
        if (nvalid != n0) err("A: valid after reset");
        single_conversion(12'h3E1);

        // ---- B: reset after raw_stb, before valid ------------------------
        script = 12'h7F0;
        @(negedge clk); start = 1'b1;
        @(posedge sample);
        repeat (FRAME + 5) @(posedge clk);          // frame 1 cycle 5: frame 0 raw captured, valid due at cycle 13
        #3; n0 = nvalid;
        rst_n = 1'b0; #1;
        check_quiet("B: outputs not cleared by async reset");
        start = 1'b0;
        repeat (4) @(negedge clk); rst_n = 1'b1;
        repeat (3 * FRAME) @(negedge clk);
        if (nvalid != n0) err("B: discarded result produced a valid");
        single_conversion(12'h000);
        single_conversion(12'hFFF);

        // ---- C: sustained restart after reset: cadence -------------------
        script = 12'h5A5;
        @(negedge clk); start = 1'b1;
        gap_err = 0; t_last = -1;
        for (k = 0; k < 6; k = k + 1) begin
            @(posedge valid); #1;
            if (raw !== 12'h5A5 || code !== ref_code(12'h5A5)) err("C: wrong result after restart");
            if (t_last >= 0 && ($time - t_last) != FRAME * 20) gap_err = gap_err + 1;
            t_last = $time;
        end
        if (gap_err) err("C: cadence != 1 us after restart");
        start = 1'b0;
        while (busy) @(posedge clk);

        $display("==================================================");
        $display(" reset-abort TB: errors = %0d", errors);
        $display(" RESULT %0s", errors == 0 ? "PASS" : "FAIL");
        $display("==================================================");
        $finish;
    end
    initial begin #200_000; $display("RESULT FAIL (timeout)"); $finish; end
endmodule
