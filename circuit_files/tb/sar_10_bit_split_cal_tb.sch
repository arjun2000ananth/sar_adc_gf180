v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1170 -960 1210 -960 {
lab=vdda}
N 1170 -940 1210 -940 {
lab=vddd}
N 1170 -920 1210 -920 {
lab=vss}
N 1170 -880 1210 -880 {
lab=ainp}
N 1170 -860 1210 -860 {
lab=ainn}
N 1170 -840 1210 -840 {
lab=vcm}
N 1170 -820 1210 -820 {
lab=vrefp}
N 1170 -800 1210 -800 {
lab=clk}
N 1170 -780 1210 -780 {
lab=rst_n}
N 1170 -760 1210 -760 {
lab=start}
N 1170 -740 1210 -740 {
lab=GND}
N 1170 -720 1210 -720 {
lab=GND}
N 1170 -700 1210 -700 {
lab=GND}
N 1170 -680 1210 -680 {
lab=GND}
N 1170 -660 1210 -660 {
lab=GND}
N 1170 -640 1210 -640 {
lab=GND}
N 1170 -620 1210 -620 {
lab=GND}
N 1170 -600 1210 -600 {
lab=GND}
N 1170 -580 1210 -580 {
lab=GND}
N 1170 -560 1210 -560 {
lab=GND}
N 1170 -540 1210 -540 {
lab=GND}
N 1170 -520 1210 -520 {
lab=GND}
N 1170 -500 1210 -500 {
lab=GND}
N 1170 -480 1210 -480 {
lab=GND}
N 1170 -460 1210 -460 {
lab=GND}
N 1170 -440 1210 -440 {
lab=GND}
N 1170 -420 1210 -420 {
lab=GND}
N 1170 -400 1210 -400 {
lab=GND}
N 1170 -380 1210 -380 {
lab=GND}
N 1170 -360 1210 -360 {
lab=GND}
N 1170 -340 1210 -340 {
lab=GND}
N 1170 -320 1210 -320 {
lab=GND}
N 1170 -300 1210 -300 {
lab=GND}
N 1170 -280 1210 -280 {
lab=GND}
N 1590 -960 1630 -960 {
lab=busy}
N 1590 -940 1630 -940 {
lab=valid}
N 1590 -920 1630 -920 {
lab=sat}
N 1590 -900 1630 -900 {
lab=raw_stb}
N 1590 -880 1630 -880 {
lab=code9}
N 1590 -860 1630 -860 {
lab=code8}
N 1590 -840 1630 -840 {
lab=code7}
N 1590 -820 1630 -820 {
lab=code6}
N 1590 -800 1630 -800 {
lab=code5}
N 1590 -780 1630 -780 {
lab=code4}
N 1590 -760 1630 -760 {
lab=code3}
N 1590 -740 1630 -740 {
lab=code2}
N 1590 -720 1630 -720 {
lab=code1}
N 1590 -700 1630 -700 {
lab=code0}
N 1590 -680 1630 -680 {
lab=raw11}
N 1590 -660 1630 -660 {
lab=raw10}
N 1590 -640 1630 -640 {
lab=raw9}
N 1590 -620 1630 -620 {
lab=raw8}
N 1590 -600 1630 -600 {
lab=raw7}
N 1590 -580 1630 -580 {
lab=raw6}
N 1590 -560 1630 -560 {
lab=raw5}
N 1590 -540 1630 -540 {
lab=raw4}
N 1590 -520 1630 -520 {
lab=raw3}
N 1590 -500 1630 -500 {
lab=raw2}
N 1590 -480 1630 -480 {
lab=raw1}
N 1590 -460 1630 -460 {
lab=raw0}
N 100 -1210 100 -1180 {
lab=vdda}
N 100 -1120 100 -1090 {
lab=GND}
N 230 -1210 230 -1180 {
lab=vddd}
N 230 -1120 230 -1090 {
lab=GND}
N 360 -1210 360 -1180 {
lab=vss}
N 360 -1120 360 -1090 {
lab=GND}
N 490 -1210 490 -1180 {
lab=vrefp}
N 490 -1120 490 -1090 {
lab=GND}
N 620 -1210 620 -1180 {
lab=vcm}
N 620 -1120 620 -1090 {
lab=GND}
N 750 -1210 750 -1180 {
lab=ainp_s}
N 750 -1120 750 -1090 {
lab=GND}
N 880 -1210 880 -1180 {
lab=ainn_s}
N 880 -1120 880 -1090 {
lab=GND}
N 1180 -1210 1180 -1180 {
lab=cki}
N 1180 -1120 1180 -1090 {
lab=GND}
N 1480 -1210 1480 -1180 {
lab=rst_n}
N 1480 -1120 1480 -1090 {
lab=GND}
N 1780 -1210 1780 -1180 {
lab=start}
N 1780 -1120 1780 -1090 {
lab=GND}
N 300 -960 300 -930 {
lab=ainp_s}
N 300 -870 300 -840 {
lab=ainp}
N 420 -960 420 -930 {
lab=ainn_s}
N 420 -870 420 -840 {
lab=ainn}
C {sar_10_bit_split_cal.sym} 1400 -620 0 0 {name=x1}
C {lab_pin.sym} 1170 -960 0 0 {name=p1 sig_type=std_logic lab=vdda}
C {lab_pin.sym} 1170 -940 0 0 {name=p2 sig_type=std_logic lab=vddd}
C {lab_pin.sym} 1170 -920 0 0 {name=p3 sig_type=std_logic lab=vss}
C {lab_pin.sym} 1170 -880 0 0 {name=p4 sig_type=std_logic lab=ainp}
C {lab_pin.sym} 1170 -860 0 0 {name=p5 sig_type=std_logic lab=ainn}
C {lab_pin.sym} 1170 -840 0 0 {name=p6 sig_type=std_logic lab=vcm}
C {lab_pin.sym} 1170 -820 0 0 {name=p7 sig_type=std_logic lab=vrefp}
C {lab_pin.sym} 1170 -800 0 0 {name=p8 sig_type=std_logic lab=clk}
C {lab_pin.sym} 1170 -780 0 0 {name=p9 sig_type=std_logic lab=rst_n}
C {lab_pin.sym} 1170 -760 0 0 {name=p10 sig_type=std_logic lab=start}
C {lab_pin.sym} 1170 -740 0 0 {name=p11 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -720 0 0 {name=p12 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -700 0 0 {name=p13 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -680 0 0 {name=p14 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -660 0 0 {name=p15 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -640 0 0 {name=p16 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -620 0 0 {name=p17 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -600 0 0 {name=p18 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -580 0 0 {name=p19 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -560 0 0 {name=p20 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -540 0 0 {name=p21 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -520 0 0 {name=p22 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -500 0 0 {name=p23 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -480 0 0 {name=p24 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -460 0 0 {name=p25 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -440 0 0 {name=p26 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -420 0 0 {name=p27 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -400 0 0 {name=p28 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -380 0 0 {name=p29 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -360 0 0 {name=p30 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -340 0 0 {name=p31 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -320 0 0 {name=p32 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -300 0 0 {name=p33 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1170 -280 0 0 {name=p34 sig_type=std_logic lab=GND}
C {lab_pin.sym} 1630 -960 2 0 {name=p35 sig_type=std_logic lab=busy}
C {lab_pin.sym} 1630 -940 2 0 {name=p36 sig_type=std_logic lab=valid}
C {lab_pin.sym} 1630 -920 2 0 {name=p37 sig_type=std_logic lab=sat}
C {lab_pin.sym} 1630 -900 2 0 {name=p38 sig_type=std_logic lab=raw_stb}
C {lab_pin.sym} 1630 -880 2 0 {name=p39 sig_type=std_logic lab=code9}
C {lab_pin.sym} 1630 -860 2 0 {name=p40 sig_type=std_logic lab=code8}
C {lab_pin.sym} 1630 -840 2 0 {name=p41 sig_type=std_logic lab=code7}
C {lab_pin.sym} 1630 -820 2 0 {name=p42 sig_type=std_logic lab=code6}
C {lab_pin.sym} 1630 -800 2 0 {name=p43 sig_type=std_logic lab=code5}
C {lab_pin.sym} 1630 -780 2 0 {name=p44 sig_type=std_logic lab=code4}
C {lab_pin.sym} 1630 -760 2 0 {name=p45 sig_type=std_logic lab=code3}
C {lab_pin.sym} 1630 -740 2 0 {name=p46 sig_type=std_logic lab=code2}
C {lab_pin.sym} 1630 -720 2 0 {name=p47 sig_type=std_logic lab=code1}
C {lab_pin.sym} 1630 -700 2 0 {name=p48 sig_type=std_logic lab=code0}
C {lab_pin.sym} 1630 -680 2 0 {name=p49 sig_type=std_logic lab=raw11}
C {lab_pin.sym} 1630 -660 2 0 {name=p50 sig_type=std_logic lab=raw10}
C {lab_pin.sym} 1630 -640 2 0 {name=p51 sig_type=std_logic lab=raw9}
C {lab_pin.sym} 1630 -620 2 0 {name=p52 sig_type=std_logic lab=raw8}
C {lab_pin.sym} 1630 -600 2 0 {name=p53 sig_type=std_logic lab=raw7}
C {lab_pin.sym} 1630 -580 2 0 {name=p54 sig_type=std_logic lab=raw6}
C {lab_pin.sym} 1630 -560 2 0 {name=p55 sig_type=std_logic lab=raw5}
C {lab_pin.sym} 1630 -540 2 0 {name=p56 sig_type=std_logic lab=raw4}
C {lab_pin.sym} 1630 -520 2 0 {name=p57 sig_type=std_logic lab=raw3}
C {lab_pin.sym} 1630 -500 2 0 {name=p58 sig_type=std_logic lab=raw2}
C {lab_pin.sym} 1630 -480 2 0 {name=p59 sig_type=std_logic lab=raw1}
C {lab_pin.sym} 1630 -460 2 0 {name=p60 sig_type=std_logic lab=raw0}
C {vsource.sym} 100 -1150 0 0 {name=VDDA value="dc 3.3" savecurrent=false}
C {lab_pin.sym} 100 -1210 1 0 {name=p61 sig_type=std_logic lab=vdda}
C {gnd.sym} 100 -1090 0 0 {name=gVDDA lab=GND}
C {vsource.sym} 230 -1150 0 0 {name=VDDD value="dc 3.3" savecurrent=false}
C {lab_pin.sym} 230 -1210 1 0 {name=p62 sig_type=std_logic lab=vddd}
C {gnd.sym} 230 -1090 0 0 {name=gVDDD lab=GND}
C {vsource.sym} 360 -1150 0 0 {name=VSSS value="dc 0" savecurrent=false}
C {lab_pin.sym} 360 -1210 1 0 {name=p63 sig_type=std_logic lab=vss}
C {gnd.sym} 360 -1090 0 0 {name=gVSSS lab=GND}
C {vsource.sym} 490 -1150 0 0 {name=VREF value="dc 3.3" savecurrent=false}
C {lab_pin.sym} 490 -1210 1 0 {name=p64 sig_type=std_logic lab=vrefp}
C {gnd.sym} 490 -1090 0 0 {name=gVREF lab=GND}
C {vsource.sym} 620 -1150 0 0 {name=VCMS value="dc 1.65" savecurrent=false}
C {lab_pin.sym} 620 -1210 1 0 {name=p65 sig_type=std_logic lab=vcm}
C {gnd.sym} 620 -1090 0 0 {name=gVCMS lab=GND}
C {vsource.sym} 750 -1150 0 0 {name=VINP value="dc \{1.65+VDIFF/2\}" savecurrent=false}
C {lab_pin.sym} 750 -1210 1 0 {name=p66 sig_type=std_logic lab=ainp_s}
C {gnd.sym} 750 -1090 0 0 {name=gVINP lab=GND}
C {vsource.sym} 880 -1150 0 0 {name=VINN value="dc \{1.65-VDIFF/2\}" savecurrent=false}
C {lab_pin.sym} 880 -1210 1 0 {name=p67 sig_type=std_logic lab=ainn_s}
C {gnd.sym} 880 -1090 0 0 {name=gVINN lab=GND}
C {vsource.sym} 1180 -1150 0 0 {name=VCKI value="PULSE(0 3.3 10n 0.2n 0.2n 9.8n 20n)" savecurrent=false}
C {lab_pin.sym} 1180 -1210 1 0 {name=p68 sig_type=std_logic lab=cki}
C {gnd.sym} 1180 -1090 0 0 {name=gVCKI lab=GND}
C {vsource.sym} 1480 -1150 0 0 {name=VRST value="PWL(0 0 100n 0 100.2n 3.3)" savecurrent=false}
C {lab_pin.sym} 1480 -1210 1 0 {name=p69 sig_type=std_logic lab=rst_n}
C {gnd.sym} 1480 -1090 0 0 {name=gVRST lab=GND}
C {vsource.sym} 1780 -1150 0 0 {name=VSTA value="PWL(0 0 160n 0 160.2n 3.3)" savecurrent=false}
C {lab_pin.sym} 1780 -1210 1 0 {name=p70 sig_type=std_logic lab=start}
C {gnd.sym} 1780 -1090 0 0 {name=gVSTA lab=GND}
C {res.sym} 300 -900 0 0 {name=RSP value=50 m=1}
C {lab_pin.sym} 300 -960 1 0 {name=p71 sig_type=std_logic lab=ainp_s}
C {lab_pin.sym} 300 -840 3 0 {name=p72 sig_type=std_logic lab=ainp}
C {res.sym} 420 -900 0 0 {name=RSN value=50 m=1}
C {lab_pin.sym} 420 -960 1 0 {name=p73 sig_type=std_logic lab=ainn_s}
C {lab_pin.sym} 420 -840 3 0 {name=p74 sig_type=std_logic lab=ainn}
C {code_shown.sym} 60 -230 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::env(PDK_ROOT)/$::env(PDK)/libs.tech/ngspice/design.ngspice
.lib $::env(PDK_ROOT)/$::env(PDK)/libs.tech/ngspice/sm141064.ngspice typical
.lib $::env(PDK_ROOT)/$::env(PDK)/libs.tech/ngspice/sm141064.ngspice cap_mim
.lib $::env(PDK_ROOT)/$::env(PDK)/libs.tech/ngspice/sm141064.ngspice mimcap_typical
.include $::env(PDK_ROOT)/$::env(PDK)/libs.ref/gf180mcu_fd_sc_mcu7t5v0/spice/gf180mcu_fd_sc_mcu7t5v0.spice
.include [file dirname [xschem get schname]]/../src/sar_split_cal/xspice/sar_split_cal_ctrl_as_xspice.spice
"}
C {code.sym} 1400 -150 0 0 {name=CTRL only_toplevel=true
value="
.param VDIFF=0.5
XCKB cki clk vddd vddd vss vss gf180mcu_fd_sc_mcu7t5v0__clkbuf_4
.options method=gear reltol=1e-4 abstol=1e-12 vntol=1e-6 klu
.control
set noaskquit
save v(clk) v(valid) v(sat) v(x1.sample) v(x1.rstf) v(x1.comp_clk) v(x1.comp) v(x1.vcp) v(x1.vcn) v(x1.vfp) v(x1.vfn) v(code0) v(code1) v(code2) v(code3) v(code4) v(code5) v(code6) v(code7) v(code8) v(code9) v(raw0) v(raw1) v(raw2) v(raw3) v(raw4) v(raw5) v(raw6) v(raw7) v(raw8) v(raw9) v(raw10) v(raw11)
tran 1n 6.5u
write sar_10_bit_split_cal_tb.raw
set wr_singlescale
linearize v(valid) v(sat) v(code0) v(code1) v(code2) v(code3) v(code4) v(code5) v(code6) v(code7) v(code8) v(code9) v(raw0) v(raw1) v(raw2) v(raw3) v(raw4) v(raw5) v(raw6) v(raw7) v(raw8) v(raw9) v(raw10) v(raw11)
wrdata dlog.txt v(valid) v(sat) v(code0) v(code1) v(code2) v(code3) v(code4) v(code5) v(code6) v(code7) v(code8) v(code9) v(raw0) v(raw1) v(raw2) v(raw3) v(raw4) v(raw5) v(raw6) v(raw7) v(raw8) v(raw9) v(raw10) v(raw11)
echo done
.endc
"}
C {title.sym} 160 0 0 0 {name=l1 author="Arjun Ananth"}
