`timescale 1ns/1ps
//-----------------------------------------------------------------------------
// Reconstruction replay TB: sar_split_cal_recon driven directly.
//   +coef=<file> : 13 lines "addr value" (value = unsigned decimal of the
//                  18-bit word) written through the cal port; empty -> none
//   +cal_en=<0|1>
//   +raw=<file>  : one raw word (hex) per line
//   +out=<file>  : "raw code sat" per word
// Used for: exhaustive 4096-word check against the Python fixed-point model,
// and for replaying raw words captured from the transistor-level runs.
//-----------------------------------------------------------------------------
module tb_sar_split_cal_recon_replay;
    reg clk = 1'b0, rst_n = 1'b0, raw_stb = 1'b0, cal_en = 1'b0, cal_we = 1'b0;
    reg [3:0]  cal_addr = 4'd0;
    reg [17:0] cal_wdata = 18'd0;
    reg [11:0] raw = 12'd0;
    wire [9:0] code;
    wire [11:0] raw_q;
    wire sat, valid;
    always #10 clk = ~clk;

    sar_split_cal_recon #(.NCMP(12), .F(6), .CW(16), .AW(18)) dut (
        .clk(clk), .rst_n(rst_n), .raw_stb(raw_stb), .raw(raw),
        .cal_en(cal_en), .cal_we(cal_we), .cal_addr(cal_addr), .cal_wdata(cal_wdata),
        .code(code), .raw_q(raw_q), .sat(sat), .valid(valid));

    reg [1023:0] fcoef, fraw, fout;
    integer fc, fr, fo, rc, a, v, w, n, en;
    initial begin
        if (!$value$plusargs("raw=%s", fraw)) fraw = "replay_raw.txt";
        if (!$value$plusargs("out=%s", fout)) fout = "replay_out.txt";
        if (!$value$plusargs("cal_en=%d", en)) en = 0;
        repeat (3) @(negedge clk);
        rst_n = 1'b1;
        @(negedge clk);
        if ($value$plusargs("coef=%s", fcoef)) begin
            fc = $fopen(fcoef, "r");
            while (!$feof(fc)) begin
                rc = $fscanf(fc, "%d %d\n", a, v);
                if (rc == 2) begin
                    @(negedge clk); cal_we = 1'b1; cal_addr = a; cal_wdata = v;
                    @(negedge clk); cal_we = 1'b0;
                end
            end
            $fclose(fc);
        end
        cal_en = (en != 0);
        fr = $fopen(fraw, "r");
        fo = $fopen(fout, "w");
        n = 0;
        while (!$feof(fr)) begin
            rc = $fscanf(fr, "%h\n", w);
            if (rc == 1) begin
                @(negedge clk); raw = w; raw_stb = 1'b1;
                @(negedge clk); raw_stb = 1'b0;
                while (!valid) @(posedge clk);
                #1;
                $fwrite(fo, "%03h %0d %0d\n", raw_q, code, sat);
                n = n + 1;
            end
        end
        $fclose(fr); $fclose(fo);
        $display("replay: %0d words", n);
        $finish;
    end
endmodule
