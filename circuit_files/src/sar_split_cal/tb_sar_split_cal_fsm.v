`timescale 1ns/1ps
//-----------------------------------------------------------------------------
// RTL unit testbench: sar_split_cal_logic + sar_split_cal_recon (via wrapper).
// The comparator is a scripted decision source (no analog model), so every
// check below is exact.  Deterministic PASS/FAIL exit ($finish with summary,
// non-zero error count printed as "RESULT FAIL").
//
// Checks
//  * reset / startup state
//  * exact per-cycle schedule of sample, rstf, comp_clk in every frame
//  * bottom-plate switching: only on capture edges, correct side, cumulative,
//    never bp[i] & bn[i], all cleared at frame start
//  * raw capture == scripted decisions
//  * nominal reconstruction == reference interval-midpoint decoding (INTERVAL=1,
//    written independently below); programmable coefficients (random) ==
//    reference fixed-point model; saturation
//  * start/busy/valid protocol, single conversions and sustained mode
//    (exactly one valid per 50 cycles), start pulses at awkward times
//-----------------------------------------------------------------------------
module tb_sar_split_cal_fsm;

    localparam integer S     = 26;
    localparam integer NST   = 11;
    localparam integer FRAME = S + (NST + 1) * 2;
    localparam integer F     = 6;

    reg clk = 1'b0, rst_n = 1'b0, start = 1'b0, comp = 1'b0;
    reg cal_en = 1'b0, cal_we = 1'b0;
    reg [3:0]  cal_addr = 4'd0;
    reg [17:0] cal_wdata = 18'd0;

    wire sample, rstf, comp_clk, busy, valid, raw_stb, sat;
    wire [10:0] bp, bn;
    wire [9:0]  code;
    wire [11:0] raw;

    sar_split_cal_wrapper dut (
        .clk(clk), .rst_n(rst_n), .start(start), .comp(comp),
        .cal_en(cal_en), .cal_we(cal_we),
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

    always #10 clk = ~clk;          // 50 MHz

    integer errors = 0;
    task err(input [8*96-1:0] msg);
    begin
        errors = errors + 1;
        if (errors < 40) $display("ERROR t=%0t : %0s", $time, msg);
    end
    endtask

    // ------------------------------------------------------------------
    // scripted comparator: decision for slot j of the running frame
    // ------------------------------------------------------------------
    reg [11:0] script;              // script[11-j] = decision of comparison j
    integer    slot_seen;
    always @(posedge comp_clk) begin
        comp = script[11 - slot_seen];
        slot_seen = slot_seen + 1;
    end

    // ------------------------------------------------------------------
    // cycle-accurate monitor of the frame schedule
    // ------------------------------------------------------------------
    integer fcyc;                   // frame cycle of the outputs now applied
    reg     in_frame;
    reg [10:0] bp_prev, bn_prev, bp_exp, bn_exp;
    reg [11:0] dec_exp;
    integer j, k;
    integer valid_count = 0, last_valid_t = -1, valid_gap_err = 0;
    integer frames_started = 0;

    initial begin in_frame = 0; fcyc = 0; slot_seen = 0; end

    // outputs change just after posedge; check them at negedge
    always @(negedge clk) if (rst_n) begin
        // global invariants
        if ((bp & bn) != 0)            err("bp & bn both set");
        if (rstf && !sample)           err("rstf while sample low");
        if (comp_clk && sample)        err("comp_clk during sample");
        if (!busy && (sample || rstf || comp_clk || bp || bn)) err("activity while idle");
        if (busy) begin
            if (sample && fcyc == 0 && !(bp == 0 && bn == 0)) err("DAC not cleared at frame start");
            // schedule
            if (sample   != (fcyc < S))                         err("sample schedule");
            if (rstf     != (fcyc < S - 1))                     err("rstf schedule");
            if (comp_clk != (fcyc >= S && ((fcyc - S) % 2) == 1)) err("comp_clk schedule");
            // DAC state = cumulative decisions of completed slots
            bp_exp = 0; bn_exp = 0;
            for (j = 0; j < NST; j = j + 1)
                if (fcyc >= S + 2 * (j + 1)) begin
                    if (script[11 - j]) bn_exp[j] = 1'b1; else bp_exp[j] = 1'b1;
                end
            if (bp !== bp_exp || bn !== bn_exp) begin
                err("DAC state mismatch");
                $display("   fcyc=%0d bp=%b exp=%b bn=%b exp=%b", fcyc, bp, bp_exp, bn, bn_exp);
            end
        end
    end

    // frame cycle tracking (posedge: outputs for next cycle become active)
    always @(posedge clk) begin
        #1;
        if (busy && sample && !in_frame) begin
            in_frame = 1; fcyc = 0; slot_seen = 0; frames_started = frames_started + 1;
        end else if (busy) begin
            fcyc = fcyc + 1;
            if (fcyc == FRAME) begin fcyc = 0; slot_seen = 0; frames_started = frames_started + 1; end
        end else begin
            in_frame = 0;
        end
    end

    // valid cadence
    always @(posedge clk) if (valid) begin
        valid_count = valid_count + 1;
        if (cadence_check && last_valid_t >= 0 && ($time - last_valid_t) != FRAME * 20) begin
            valid_gap_err = valid_gap_err + 1;
            err("valid interval != 1 us in sustained mode");
        end
        last_valid_t = $time;
    end
    reg cadence_check = 0;

    // ------------------------------------------------------------------
    // reference reconstruction (same fixed-point arithmetic, independent code)
    // ------------------------------------------------------------------
    integer cref [0:11];
    integer offref;
    task set_nominal_ref;
    begin
        cref[0]=528*64; cref[1]=264*64; cref[2]=132*64; cref[3]=66*64; cref[4]=33*64;
        cref[5]=32*64;  cref[6]=16*64;  cref[7]=8*64;   cref[8]=4*64;  cref[9]=2*64;
        cref[10]=64;    cref[11]=32;    offref = -2000;    // -31.25*64
    end
    endtask
    // interval-midpoint decoding (sar_split_cal_recon INTERVAL=1), written independently:
    // 2*T_i = 2*C_off + S_all + 2*A_i - S_i ; L = max over d_i=1, U = min over d_i=0;
    // code = sat(floor((L+U)/2)) ; all in Q.F (F = 6)
    function integer ref_msum(input [11:0] w);
        integer a, sm, lo, hi, hl, hh, t, ii, kc, lof, hif;
        begin
            a = 0; sm = 0; hl = 0; hh = 0; lo = 0; hi = 0;
            for (ii = 0; ii < 12; ii = ii + 1) begin
                t = 2 * a - sm;
                if (w[11 - ii]) begin if (!hl || t > lo) lo = t; hl = 1; a = a + cref[ii]; end
                else            begin if (!hh || t < hi) hi = t; hh = 1; end
                sm = sm + cref[ii];
            end
            kc  = 2 * offref + sm;
            lof = hl ? lo + kc : hi + kc - 128;
            hif = hh ? hi + kc : lo + kc + 128;
            ref_msum = lof + hif;                             // 4 * midpoint, Q.6
        end
    endfunction
    function integer ref_code(input [11:0] w);
        integer ms, q;
        begin
            ms = ref_msum(w);
            q = (ms >= 0) ? ms / 256 : -((-ms + 255) / 256); // floor
            if (q < 0) q = 0;
            if (q > 1023) q = 1023;
            ref_code = q;
        end
    endfunction
    function ref_sat(input [11:0] w);
        integer ms;
        begin
            ms = ref_msum(w);
            ref_sat = (ms < 0) || (ms >= 1024 * 256);
        end
    endfunction

    // ------------------------------------------------------------------
    // helpers
    // ------------------------------------------------------------------
    task wait_valid_and_check(input [11:0] w);
        integer guard;
        begin
            guard = 0;
            while (!valid && guard < 200) begin @(posedge clk); #1; guard = guard + 1; end
            if (!valid) err("valid never asserted");
            else begin
                if (raw !== w)                  begin err("raw mismatch");  $display("   raw=%b exp=%b", raw, w); end
                if (code !== ref_code(w))       begin err("code mismatch"); $display("   w=%b code=%0d exp=%0d", w, code, ref_code(w)); end
                if (sat !== ref_sat(w))           err("sat mismatch");
            end
            @(posedge clk); #1;
        end
    endtask

    task one_conversion(input [11:0] w);
        begin
            script = w;
            @(negedge clk); start = 1'b1;
            @(negedge clk); start = 1'b0;
            wait_valid_and_check(w);
            while (busy) @(posedge clk);
            #1;
        end
    endtask

    task write_coef(input [3:0] a, input [17:0] d);
        begin
            @(negedge clk); cal_we = 1'b1; cal_addr = a; cal_wdata = d;
            @(negedge clk); cal_we = 1'b0;
        end
    endtask

    // ------------------------------------------------------------------
    integer n, t0, lat, nconv, fstart;
    reg [11:0] w;
    reg [11:0] words [0:63];

    initial begin
        $dumpfile("tb_sar_split_cal_fsm.vcd");
        $dumpvars(0, tb_sar_split_cal_fsm);
        script = 12'h000;
        set_nominal_ref;

        // ---- reset / startup ------------------------------------------
        // rst_n is low from time 0; the async-reset flops are defined at the
        // first clock edge (or any rst_n falling edge) -> check after it.
        @(posedge clk); #1;
        if (sample !== 1'b0 || rstf !== 1'b0 || comp_clk !== 1'b0 || busy !== 1'b0 || valid !== 1'b0 ||
            bp !== 0 || bn !== 0) err("outputs not reset");
        start = 1'b1;                          // start held during reset: must not run
        repeat (5) @(negedge clk);
        if (busy) err("busy during reset");
        start = 1'b0;
        rst_n = 1'b1;
        repeat (3) @(negedge clk);
        if (busy || sample) err("activity after reset without start");

        // ---- single conversions: corner and random decision words ------
        one_conversion(12'b000000000000);
        one_conversion(12'b111111111111);
        one_conversion(12'b100000000000);
        one_conversion(12'b011111111111);
        one_conversion(12'b101010101010);
        one_conversion(12'b010101010101);
        for (n = 0; n < 40; n = n + 1) one_conversion($random);

        // ---- latency of a single conversion ---------------------------
        script = 12'h5A3;
        @(negedge clk); start = 1'b1; t0 = $time; @(negedge clk); start = 1'b0;
        while (!valid) @(posedge clk);
        lat = ($time - t0) / 20;
        $display("INFO latency start->valid = %0d cycles", lat);
        while (busy) @(posedge clk);

        // ---- start pulses at awkward times -----------------------------
        // (a) pulse in the middle of a frame: ignored, exactly one conversion
        script = 12'h3C3;
        @(negedge clk); start = 1'b1; @(negedge clk); start = 1'b0;
        repeat (20) @(negedge clk);
        start = 1'b1; @(negedge clk); start = 1'b0;
        fstart = frames_started;
        wait_valid_and_check(12'h3C3);
        repeat (2 * FRAME) @(negedge clk);
        if (frames_started != fstart) err("mid-frame start pulse started an extra frame");
        // (b) start high on the frame-end edge only: second frame follows directly
        script = 12'hA5A;
        @(negedge clk); start = 1'b1; @(negedge clk); start = 1'b0;
        repeat (FRAME - 1) @(negedge clk);     // now in the last cycle (49) of the frame
        start = 1'b1; @(negedge clk); start = 1'b0;
        fstart = frames_started;
        wait_valid_and_check(12'hA5A);
        repeat (3) @(negedge clk);
        if (!busy) err("frame-end start did not continue");
        wait_valid_and_check(12'hA5A);
        while (busy) @(posedge clk);
        // (c) start one cycle after the frame end: new frame from idle
        @(negedge clk); start = 1'b1; @(negedge clk); start = 1'b0;
        wait_valid_and_check(12'hA5A);
        while (busy) @(posedge clk);

        // ---- sustained mode: start held high, 64 frames ----------------
        for (n = 0; n < 64; n = n + 1) words[n] = $random;
        valid_count = 0; last_valid_t = -1; cadence_check = 1;
        nconv = 0;
        script = words[0];
        @(negedge clk); start = 1'b1;
        // change the script at the start of every frame
        fork
            begin : drive
                integer f;
                for (f = 1; f < 64; f = f + 1) begin
                    @(posedge raw_stb);
                    script = words[f];
                end
            end
            begin : chk
                integer f2;
                for (f2 = 0; f2 < 62; f2 = f2 + 1) begin
                    while (!valid) @(posedge clk);
                    #1;
                    if (raw !== words[f2]) begin err("sustained raw mismatch"); $display("   f=%0d raw=%b exp=%b", f2, raw, words[f2]); end
                    if (code !== ref_code(words[f2])) err("sustained code mismatch");
                    nconv = nconv + 1;
                    @(posedge clk);
                end
            end
        join
        start = 1'b0;
        cadence_check = 0;
        while (busy) @(posedge clk);
        $display("INFO sustained: %0d conversions checked, valid count %0d, cadence errors %0d",
                 nconv, valid_count, valid_gap_err);

        // ---- programmable coefficients ----------------------------------
        // random coefficients (+-12%), random offset; compare to reference
        for (k = 0; k < 12; k = k + 1) begin
            cref[k] = (k == 11) ? 32 + ($random % 16) : cref[k] + (cref[k] * ($random % 120)) / 1000;
            write_coef(k, cref[k]);
        end
        offref = -2000 + ($random % 500);
        write_coef(12, offref);
        cal_en = 1'b1;
        for (n = 0; n < 60; n = n + 1) one_conversion($random);
        one_conversion(12'h000);
        one_conversion(12'hFFF);
        // cal_en=0 must return to the hard-wired nominal set
        cal_en = 1'b0; set_nominal_ref;
        for (n = 0; n < 10; n = n + 1) one_conversion($random);
        // full reset restores nominal register values
        cal_en = 1'b1;
        rst_n = 1'b0; repeat (2) @(negedge clk); rst_n = 1'b1; repeat (2) @(negedge clk);
        for (n = 0; n < 10; n = n + 1) one_conversion($random);
        cal_en = 1'b0;

        $display("==================================================");
        $display(" errors = %0d", errors);
        $display(" RESULT %0s", errors == 0 ? "PASS" : "FAIL");
        $display("==================================================");
        $finish;
    end

    initial begin #20_000_000; $display("RESULT FAIL (timeout)"); $finish; end

endmodule
