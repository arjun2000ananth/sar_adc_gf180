`timescale 1ns/1ps
//-----------------------------------------------------------------------------
// Behavioural closed-loop TB: real RTL (sar_split_cal_wrapper) + charge-
// conservation CDAC model, in sustained mode (start held high, 1 conversion
// per 50 clocks).
//
//   vcp - vcn = Vin + sum_i ( bp_i * sP_i - bn_i * sN_i )
//
// sP_i / sN_i are the per-plate differential step sizes (V) produced by
// cdac_split_model.py (charge conservation, optional mismatch/parasitics),
// read from +params=<file>:  line 1..11: sP_i sN_i ; line 12: offset noise_rms
// Inputs: +inputs=<file> (one Vin per line, applied for one frame each, held
// while sample is high and sampled at the falling edge of sample).
// Output: +out=<file>: "vin raw(hex) code sat" per conversion, in order.
//-----------------------------------------------------------------------------
module tb_sar_split_cal_closedloop;

    reg clk = 1'b0, rst_n = 1'b0, start = 1'b0;
    reg comp;
    always #10 clk = ~clk;

    wire sample, rstf, comp_clk, busy, valid, raw_stb, sat;
    wire [10:0] bp, bn;
    wire [9:0]  code;
    wire [11:0] raw;

    sar_split_cal_wrapper dut (
        .clk(clk), .rst_n(rst_n), .start(start), .comp(comp),
        .cal_en(1'b0), .cal_we(1'b0),
        .cal_addr3(1'b0), .cal_addr2(1'b0), .cal_addr1(1'b0), .cal_addr0(1'b0),
        .cal_wdata17(1'b0), .cal_wdata16(1'b0), .cal_wdata15(1'b0), .cal_wdata14(1'b0),
        .cal_wdata13(1'b0), .cal_wdata12(1'b0), .cal_wdata11(1'b0), .cal_wdata10(1'b0),
        .cal_wdata9(1'b0), .cal_wdata8(1'b0), .cal_wdata7(1'b0), .cal_wdata6(1'b0),
        .cal_wdata5(1'b0), .cal_wdata4(1'b0), .cal_wdata3(1'b0), .cal_wdata2(1'b0),
        .cal_wdata1(1'b0), .cal_wdata0(1'b0),
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

    real sP [0:10];
    real sN [0:10];
    real offs, nrms;
    real vin_track, vin_held, vd;
    integer fp, fi, fo, rc, i, n_in, n_out, seed;
    reg [1023:0] pfile, ifile, ofile;
    real vlist [0:299999];

    // CDAC + comparator
    always @(*) begin
        vd = vin_held;
        for (i = 0; i < 11; i = i + 1)
            vd = vd + (bp[i] ? sP[i] : 0.0) - (bn[i] ? sN[i] : 0.0);
    end
    // comparator decides on the rising edge of comp_clk; output held otherwise
    always @(posedge comp_clk) begin
        if (nrms > 0.0) comp = (vd + nrms * $dist_normal(seed, 0, 1000) / 1000.0 > offs);
        else            comp = (vd > offs);
    end
    // sampling: track while sample is high, hold at its falling edge
    always @(negedge sample) vin_held = vin_track;

    integer k_in;
    // next input at the start of every frame
    always @(posedge sample) begin
        if (k_in < n_in) vin_track = vlist[k_in];
        k_in = k_in + 1;
    end

    // collect outputs (valid of frame k arrives during frame k+1)
    integer k_out;
    always @(posedge clk) if (valid) begin
        $fwrite(fo, "%0.9f %03h %0d %0d\n", vlist[k_out], raw, code, sat);
        k_out = k_out + 1;
        if (k_out == n_in) begin
            $fclose(fo);
            $display("closed-loop: %0d conversions written", k_out);
            $finish;
        end
    end

    initial begin
        if (!$value$plusargs("params=%s", pfile)) pfile = "cl_params.txt";
        if (!$value$plusargs("inputs=%s", ifile)) ifile = "cl_inputs.txt";
        if (!$value$plusargs("out=%s", ofile))    ofile = "cl_out.txt";
        seed = 7;
        fp = $fopen(pfile, "r");
        for (i = 0; i < 11; i = i + 1) rc = $fscanf(fp, "%f %f\n", sP[i], sN[i]);
        rc = $fscanf(fp, "%f %f\n", offs, nrms);
        $fclose(fp);
        fi = $fopen(ifile, "r");
        n_in = 0;
        while (!$feof(fi)) begin
            rc = $fscanf(fi, "%f\n", vlist[n_in]);
            if (rc == 1) n_in = n_in + 1;
        end
        $fclose(fi);
        fo = $fopen(ofile, "w");
        k_in = 0; k_out = 0; comp = 1'b0; vin_track = 0.0; vin_held = 0.0;
        $display("closed-loop: %0d inputs", n_in);
        repeat (3) @(negedge clk);
        rst_n = 1'b1;
        @(negedge clk);
        start = 1'b1;                     // sustained mode
    end

endmodule
