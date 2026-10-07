v {xschem version=3.4.5 file_version=1.2
}
G {}
K {}
V {}
S {}
E {}
N 80 -1500 750 -1500 {
lab=acp}
N 750 -1280 1590 -1280 {
lab=afp}
N 340 -1560 340 -1500 {
lab=acp}
C {lab_pin.sym} 340 -1560 3 0 {name=p_acp lab=acp}
N 1590 -1340 1590 -1280 {
lab=afp}
C {lab_pin.sym} 1590 -1340 3 0 {name=p_afp lab=afp}
N 80 -1500 80 -1440 {
lab=acp}
N 80 -1380 80 -1320 {
lab=bp9}
C {lab_pin.sym} 80 -1320 1 0 {name=p_bp9a lab=bp9}
C {symbols/cap_mim_2f0fF.sym} 80 -1410 0 0 {name=CAP9
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=16}
T {16Cu
W=528u} 40 -1260 0 0 0.25 0.25 {}
N 210 -1500 210 -1440 {
lab=acp}
N 210 -1380 210 -1320 {
lab=bp8}
C {lab_pin.sym} 210 -1320 1 0 {name=p_bp8a lab=bp8}
C {symbols/cap_mim_2f0fF.sym} 210 -1410 0 0 {name=CAP8
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=8}
T {8Cu
W=264u} 170 -1260 0 0 0.25 0.25 {}
N 340 -1500 340 -1440 {
lab=acp}
N 340 -1380 340 -1320 {
lab=bp7}
C {lab_pin.sym} 340 -1320 1 0 {name=p_bp7a lab=bp7}
C {symbols/cap_mim_2f0fF.sym} 340 -1410 0 0 {name=CAP7
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=4}
T {4Cu
W=132u} 300 -1260 0 0 0.25 0.25 {}
N 470 -1500 470 -1440 {
lab=acp}
N 470 -1380 470 -1320 {
lab=bp6}
C {lab_pin.sym} 470 -1320 1 0 {name=p_bp6a lab=bp6}
C {symbols/cap_mim_2f0fF.sym} 470 -1410 0 0 {name=CAP6
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=2}
T {2Cu
W=66u} 430 -1260 0 0 0.25 0.25 {}
N 600 -1500 600 -1440 {
lab=acp}
N 600 -1380 600 -1320 {
lab=bp5}
C {lab_pin.sym} 600 -1320 1 0 {name=p_bp5a lab=bp5}
C {symbols/cap_mim_2f0fF.sym} 600 -1410 0 0 {name=CAP5
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=1}
T {1Cu
W=33u} 560 -1260 0 0 0.25 0.25 {}
N 880 -1280 880 -1220 {
lab=afp}
N 880 -1160 880 -1100 {
lab=bp4}
C {lab_pin.sym} 880 -1100 1 0 {name=p_bp4a lab=bp4}
C {symbols/cap_mim_2f0fF.sym} 880 -1190 0 0 {name=CAP4
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=16}
T {16Cu
W=16u} 840 -1040 0 0 0.25 0.25 {}
N 1010 -1280 1010 -1220 {
lab=afp}
N 1010 -1160 1010 -1100 {
lab=bp3}
C {lab_pin.sym} 1010 -1100 1 0 {name=p_bp3a lab=bp3}
C {symbols/cap_mim_2f0fF.sym} 1010 -1190 0 0 {name=CAP3
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=8}
T {8Cu
W=8u} 970 -1040 0 0 0.25 0.25 {}
N 1140 -1280 1140 -1220 {
lab=afp}
N 1140 -1160 1140 -1100 {
lab=bp2}
C {lab_pin.sym} 1140 -1100 1 0 {name=p_bp2a lab=bp2}
C {symbols/cap_mim_2f0fF.sym} 1140 -1190 0 0 {name=CAP2
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=4}
T {4Cu
W=4u} 1100 -1040 0 0 0.25 0.25 {}
N 1270 -1280 1270 -1220 {
lab=afp}
N 1270 -1160 1270 -1100 {
lab=bp1}
C {lab_pin.sym} 1270 -1100 1 0 {name=p_bp1a lab=bp1}
C {symbols/cap_mim_2f0fF.sym} 1270 -1190 0 0 {name=CAP1
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=2}
T {2Cu
W=2u} 1230 -1040 0 0 0.25 0.25 {}
N 1400 -1280 1400 -1220 {
lab=afp}
N 1400 -1160 1400 -1100 {
lab=bp0}
C {lab_pin.sym} 1400 -1100 1 0 {name=p_bp0a lab=bp0}
C {symbols/cap_mim_2f0fF.sym} 1400 -1190 0 0 {name=CAP0
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=1}
T {1Cu
W=1u} 1360 -1040 0 0 0.25 0.25 {}
N 1530 -1280 1530 -1220 {
lab=afp}
N 1530 -1160 1530 -1100 {
lab=bpd}
C {lab_pin.sym} 1530 -1100 1 0 {name=p_bpda lab=bpd}
C {symbols/cap_mim_2f0fF.sym} 1530 -1190 0 0 {name=CAPD
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=1}
T {DUMMY 1Cu
bottom -> VCM} 1490 -1040 0 0 0.25 0.25 {layer=4}
N 750 -1500 750 -1420 {
lab=acp}
N 750 -1360 750 -1280 {
lab=afp}
C {capa.sym} 750 -1390 0 0 {name=CABP m=1 value="\{32/31*CU\}"}
T {IDEAL BRIDGE 32/31 Cu
BEHAVIOURAL ONLY} 775 -1460 0 0 0.25 0.25 {layer=6}
T {(A) BEHAVIOURAL REFERENCE: binary 5+5 split, IDEAL Cb = 32/31 Cu} 40 -1630 0 0 0.4 0.4 {}
T {MAIN BANK: top plates on acp (comparator)} 40 -1595 0 0 0.25 0.25 {}
T {FINE BANK: top plates on afp (internal bridge node)} 900 -1390 0 0 0.25 0.25 {}
N 80 -800 750 -800 {
lab=bcp}
N 750 -580 1590 -580 {
lab=bfp}
N 340 -860 340 -800 {
lab=bcp}
C {lab_pin.sym} 340 -860 3 0 {name=p_bcp lab=bcp}
N 1590 -640 1590 -580 {
lab=bfp}
C {lab_pin.sym} 1590 -640 3 0 {name=p_bfp lab=bfp}
N 80 -800 80 -740 {
lab=bcp}
N 80 -680 80 -620 {
lab=bp9}
C {lab_pin.sym} 80 -620 1 0 {name=p_bp9b lab=bp9}
C {symbols/cap_mim_2f0fF.sym} 80 -710 0 0 {name=CBP9
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=16}
T {16Cu
W=528u} 40 -560 0 0 0.25 0.25 {}
N 210 -800 210 -740 {
lab=bcp}
N 210 -680 210 -620 {
lab=bp8}
C {lab_pin.sym} 210 -620 1 0 {name=p_bp8b lab=bp8}
C {symbols/cap_mim_2f0fF.sym} 210 -710 0 0 {name=CBP8
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=8}
T {8Cu
W=264u} 170 -560 0 0 0.25 0.25 {}
N 340 -800 340 -740 {
lab=bcp}
N 340 -680 340 -620 {
lab=bp7}
C {lab_pin.sym} 340 -620 1 0 {name=p_bp7b lab=bp7}
C {symbols/cap_mim_2f0fF.sym} 340 -710 0 0 {name=CBP7
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=4}
T {4Cu
W=132u} 300 -560 0 0 0.25 0.25 {}
N 470 -800 470 -740 {
lab=bcp}
N 470 -680 470 -620 {
lab=bp6}
C {lab_pin.sym} 470 -620 1 0 {name=p_bp6b lab=bp6}
C {symbols/cap_mim_2f0fF.sym} 470 -710 0 0 {name=CBP6
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=2}
T {2Cu
W=66u} 430 -560 0 0 0.25 0.25 {}
N 600 -800 600 -740 {
lab=bcp}
N 600 -680 600 -620 {
lab=bp5}
C {lab_pin.sym} 600 -620 1 0 {name=p_bp5b lab=bp5}
C {symbols/cap_mim_2f0fF.sym} 600 -710 0 0 {name=CBP5
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=1}
T {1Cu
W=33u} 560 -560 0 0 0.25 0.25 {}
N 880 -580 880 -520 {
lab=bfp}
N 880 -460 880 -400 {
lab=bp4}
C {lab_pin.sym} 880 -400 1 0 {name=p_bp4b lab=bp4}
C {symbols/cap_mim_2f0fF.sym} 880 -490 0 0 {name=CBP4
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=16}
T {16Cu
W=16u} 840 -340 0 0 0.25 0.25 {}
N 1010 -580 1010 -520 {
lab=bfp}
N 1010 -460 1010 -400 {
lab=bp3}
C {lab_pin.sym} 1010 -400 1 0 {name=p_bp3b lab=bp3}
C {symbols/cap_mim_2f0fF.sym} 1010 -490 0 0 {name=CBP3
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=8}
T {8Cu
W=8u} 970 -340 0 0 0.25 0.25 {}
N 1140 -580 1140 -520 {
lab=bfp}
N 1140 -460 1140 -400 {
lab=bp2}
C {lab_pin.sym} 1140 -400 1 0 {name=p_bp2b lab=bp2}
C {symbols/cap_mim_2f0fF.sym} 1140 -490 0 0 {name=CBP2
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=4}
T {4Cu
W=4u} 1100 -340 0 0 0.25 0.25 {}
N 1270 -580 1270 -520 {
lab=bfp}
N 1270 -460 1270 -400 {
lab=bp1}
C {lab_pin.sym} 1270 -400 1 0 {name=p_bp1b lab=bp1}
C {symbols/cap_mim_2f0fF.sym} 1270 -490 0 0 {name=CBP1
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=2}
T {2Cu
W=2u} 1230 -340 0 0 0.25 0.25 {}
N 1400 -580 1400 -520 {
lab=bfp}
N 1400 -460 1400 -400 {
lab=bp0}
C {lab_pin.sym} 1400 -400 1 0 {name=p_bp0b lab=bp0}
C {symbols/cap_mim_2f0fF.sym} 1400 -490 0 0 {name=CBP0
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=1}
T {1Cu
W=1u} 1360 -340 0 0 0.25 0.25 {}
N 1530 -580 1530 -520 {
lab=bfp}
N 1530 -460 1530 -400 {
lab=bpd}
C {lab_pin.sym} 1530 -400 1 0 {name=p_bpdb lab=bpd}
C {symbols/cap_mim_2f0fF.sym} 1530 -490 0 0 {name=CBPD
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=1}
T {DUMMY 1Cu
bottom -> VCM} 1490 -340 0 0 0.25 0.25 {layer=4}
N 750 -800 750 -720 {
lab=bcp}
N 750 -660 750 -580 {
lab=bfp}
C {symbols/cap_mim_2f0fF.sym} 750 -690 2 0 {name=CBBP
W=5u
L=5u
model=cap_mim_2f0fF
spiceprefix=X
m=1}
T {BRIDGE Cb = 1 x unit
(bottom plate -> bcp)} 775 -760 0 0 0.25 0.25 {layer=4}
T {(B) naive realisable bridge: Cb = 1 PDK unit (binary weights retained)} 40 -930 0 0 0.4 0.4 {}
T {MAIN BANK: top plates on bcp (comparator)} 40 -895 0 0 0.25 0.25 {}
T {FINE BANK: top plates on bfp (internal bridge node)} 900 -690 0 0 0.25 0.25 {}
C {vsource.sym} 2000 -1500 0 0 {name=V_BP9 value="PULSE(1.65 3.3 1 100p 100p 1 2)" savecurrent=false}
N 2000 -1560 2000 -1530 {
lab=bp9}
C {lab_pin.sym} 2000 -1560 0 0 {name=lV_BP9 sig_type=std_logic lab=bp9}
N 2000 -1470 2000 -1440 {
lab=GND}
C {gnd.sym} 2000 -1440 0 0 {name=gV_BP9 lab=GND}
C {vsource.sym} 2110 -1500 0 0 {name=V_BP8 value="PULSE(1.65 3.3 1 100p 100p 1 2)" savecurrent=false}
N 2110 -1560 2110 -1530 {
lab=bp8}
C {lab_pin.sym} 2110 -1560 0 0 {name=lV_BP8 sig_type=std_logic lab=bp8}
N 2110 -1470 2110 -1440 {
lab=GND}
C {gnd.sym} 2110 -1440 0 0 {name=gV_BP8 lab=GND}
C {vsource.sym} 2220 -1500 0 0 {name=V_BP7 value="PULSE(1.65 3.3 1 100p 100p 1 2)" savecurrent=false}
N 2220 -1560 2220 -1530 {
lab=bp7}
C {lab_pin.sym} 2220 -1560 0 0 {name=lV_BP7 sig_type=std_logic lab=bp7}
N 2220 -1470 2220 -1440 {
lab=GND}
C {gnd.sym} 2220 -1440 0 0 {name=gV_BP7 lab=GND}
C {vsource.sym} 2330 -1500 0 0 {name=V_BP6 value="PULSE(1.65 3.3 1 100p 100p 1 2)" savecurrent=false}
N 2330 -1560 2330 -1530 {
lab=bp6}
C {lab_pin.sym} 2330 -1560 0 0 {name=lV_BP6 sig_type=std_logic lab=bp6}
N 2330 -1470 2330 -1440 {
lab=GND}
C {gnd.sym} 2330 -1440 0 0 {name=gV_BP6 lab=GND}
C {vsource.sym} 2440 -1500 0 0 {name=V_BP5 value="PULSE(1.65 3.3 1 100p 100p 1 2)" savecurrent=false}
N 2440 -1560 2440 -1530 {
lab=bp5}
C {lab_pin.sym} 2440 -1560 0 0 {name=lV_BP5 sig_type=std_logic lab=bp5}
N 2440 -1470 2440 -1440 {
lab=GND}
C {gnd.sym} 2440 -1440 0 0 {name=gV_BP5 lab=GND}
C {vsource.sym} 2550 -1500 0 0 {name=V_BP4 value="PULSE(1.65 3.3 1 100p 100p 1 2)" savecurrent=false}
N 2550 -1560 2550 -1530 {
lab=bp4}
C {lab_pin.sym} 2550 -1560 0 0 {name=lV_BP4 sig_type=std_logic lab=bp4}
N 2550 -1470 2550 -1440 {
lab=GND}
C {gnd.sym} 2550 -1440 0 0 {name=gV_BP4 lab=GND}
C {vsource.sym} 2660 -1500 0 0 {name=V_BP3 value="PULSE(1.65 3.3 1 100p 100p 1 2)" savecurrent=false}
N 2660 -1560 2660 -1530 {
lab=bp3}
C {lab_pin.sym} 2660 -1560 0 0 {name=lV_BP3 sig_type=std_logic lab=bp3}
N 2660 -1470 2660 -1440 {
lab=GND}
C {gnd.sym} 2660 -1440 0 0 {name=gV_BP3 lab=GND}
C {vsource.sym} 2770 -1500 0 0 {name=V_BP2 value="PULSE(1.65 3.3 1 100p 100p 1 2)" savecurrent=false}
N 2770 -1560 2770 -1530 {
lab=bp2}
C {lab_pin.sym} 2770 -1560 0 0 {name=lV_BP2 sig_type=std_logic lab=bp2}
N 2770 -1470 2770 -1440 {
lab=GND}
C {gnd.sym} 2770 -1440 0 0 {name=gV_BP2 lab=GND}
C {vsource.sym} 2880 -1500 0 0 {name=V_BP1 value="PULSE(1.65 3.3 1 100p 100p 1 2)" savecurrent=false}
N 2880 -1560 2880 -1530 {
lab=bp1}
C {lab_pin.sym} 2880 -1560 0 0 {name=lV_BP1 sig_type=std_logic lab=bp1}
N 2880 -1470 2880 -1440 {
lab=GND}
C {gnd.sym} 2880 -1440 0 0 {name=gV_BP1 lab=GND}
C {vsource.sym} 2990 -1500 0 0 {name=V_BP0 value="PULSE(1.65 3.3 1 100p 100p 1 2)" savecurrent=false}
N 2990 -1560 2990 -1530 {
lab=bp0}
C {lab_pin.sym} 2990 -1560 0 0 {name=lV_BP0 sig_type=std_logic lab=bp0}
N 2990 -1470 2990 -1440 {
lab=GND}
C {gnd.sym} 2990 -1440 0 0 {name=gV_BP0 lab=GND}
C {vsource.sym} 3100 -1500 0 0 {name=V_BPD value="PULSE(1.65 3.3 1 100p 100p 1 2)" savecurrent=false}
N 3100 -1560 3100 -1530 {
lab=bpd}
C {lab_pin.sym} 3100 -1560 0 0 {name=lV_BPD sig_type=std_logic lab=bpd}
N 3100 -1470 3100 -1440 {
lab=GND}
C {gnd.sym} 3100 -1440 0 0 {name=gV_BPD lab=GND}
C {vsource.sym} 2000 -1200 0 0 {name=V_VCM value="dc \{VCM\}" savecurrent=false}
N 2000 -1260 2000 -1230 {
lab=vcm}
C {lab_pin.sym} 2000 -1260 0 0 {name=lV_VCM sig_type=std_logic lab=vcm}
N 2000 -1170 2000 -1140 {
lab=GND}
C {gnd.sym} 2000 -1140 0 0 {name=gV_VCM lab=GND}
C {vsource.sym} 2120 -1200 0 0 {name=V_SAMPLE value="PULSE(3.3 0 20n 100p 100p 1 2)" savecurrent=false}
N 2120 -1260 2120 -1230 {
lab=sample}
C {lab_pin.sym} 2120 -1260 0 0 {name=lV_SAMPLE sig_type=std_logic lab=sample}
N 2120 -1170 2120 -1140 {
lab=GND}
C {gnd.sym} 2120 -1140 0 0 {name=gV_SAMPLE lab=GND}
C {vsource.sym} 2240 -1200 0 0 {name=V_RSTF value="PULSE(3.3 0 19n 100p 100p 1 2)" savecurrent=false}
N 2240 -1260 2240 -1230 {
lab=rstf}
C {lab_pin.sym} 2240 -1260 0 0 {name=lV_RSTF sig_type=std_logic lab=rstf}
N 2240 -1170 2240 -1140 {
lab=GND}
C {gnd.sym} 2240 -1140 0 0 {name=gV_RSTF lab=GND}
C {switch_ngspice.sym} 2100 -950 0 0 {name=S_SA model=SWIDEAL}
N 2100 -1010 2100 -980 {
lab=vcm}
C {lab_pin.sym} 2100 -1010 0 0 {name=lS_SAa sig_type=std_logic lab=vcm}
N 2100 -920 2100 -890 {
lab=acp}
C {lab_pin.sym} 2100 -890 0 0 {name=lS_SAb sig_type=std_logic lab=acp}
N 2020 -950 2060 -950 {
lab=sample}
C {lab_pin.sym} 2020 -950 0 0 {name=lS_SAc sig_type=std_logic lab=sample}
N 2020 -930 2060 -930 {
lab=GND}
C {gnd.sym} 2020 -930 0 0 {name=gS_SA lab=GND}
C {switch_ngspice.sym} 2260 -950 0 0 {name=S_RA model=SWIDEAL}
N 2260 -1010 2260 -980 {
lab=vcm}
C {lab_pin.sym} 2260 -1010 0 0 {name=lS_RAa sig_type=std_logic lab=vcm}
N 2260 -920 2260 -890 {
lab=afp}
C {lab_pin.sym} 2260 -890 0 0 {name=lS_RAb sig_type=std_logic lab=afp}
N 2180 -950 2220 -950 {
lab=rstf}
C {lab_pin.sym} 2180 -950 0 0 {name=lS_RAc sig_type=std_logic lab=rstf}
N 2180 -930 2220 -930 {
lab=GND}
C {gnd.sym} 2180 -930 0 0 {name=gS_RA lab=GND}
C {switch_ngspice.sym} 2420 -950 0 0 {name=S_SB model=SWIDEAL}
N 2420 -1010 2420 -980 {
lab=vcm}
C {lab_pin.sym} 2420 -1010 0 0 {name=lS_SBa sig_type=std_logic lab=vcm}
N 2420 -920 2420 -890 {
lab=bcp}
C {lab_pin.sym} 2420 -890 0 0 {name=lS_SBb sig_type=std_logic lab=bcp}
N 2340 -950 2380 -950 {
lab=sample}
C {lab_pin.sym} 2340 -950 0 0 {name=lS_SBc sig_type=std_logic lab=sample}
N 2340 -930 2380 -930 {
lab=GND}
C {gnd.sym} 2340 -930 0 0 {name=gS_SB lab=GND}
C {switch_ngspice.sym} 2580 -950 0 0 {name=S_RB model=SWIDEAL}
N 2580 -1010 2580 -980 {
lab=vcm}
C {lab_pin.sym} 2580 -1010 0 0 {name=lS_RBa sig_type=std_logic lab=vcm}
N 2580 -920 2580 -890 {
lab=bfp}
C {lab_pin.sym} 2580 -890 0 0 {name=lS_RBb sig_type=std_logic lab=bfp}
N 2500 -950 2540 -950 {
lab=rstf}
C {lab_pin.sym} 2500 -950 0 0 {name=lS_RBc sig_type=std_logic lab=rstf}
N 2500 -930 2540 -930 {
lab=GND}
C {gnd.sym} 2500 -930 0 0 {name=gS_RB lab=GND}
T {BEHAVIOURAL REFERENCE TESTBENCH - ideal bridge capacitor (capa) and ideal
switches/sources.  Not a physical implementation.  Bottom plates of both arrays
are driven by the same ideal sources; tops sampled at VCM.} 2000 -1700 0 0 0.3 0.3 {layer=6}
C {code_shown.sym} 100 -150 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::env(PDK_ROOT)/$::env(PDK)/libs.tech/ngspice/design.ngspice
.lib $::env(PDK_ROOT)/$::env(PDK)/libs.tech/ngspice/sm141064.ngspice typical
.lib $::env(PDK_ROOT)/$::env(PDK)/libs.tech/ngspice/sm141064.ngspice cap_mim
.lib $::env(PDK_ROOT)/$::env(PDK)/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
C {code.sym} 900 -150 0 0 {name=TB_BINREF only_toplevel=true
value="
.param VCM=1.65
.param CU='1.99e-3*25e-12+2.383e-10*20e-6'
.model SWIDEAL SW VT=1.65 VH=0.05 RON=50 ROFF=1e12
* IDEAL behavioural switch: RON 50 ohm; ROFF 1e12 ohm represents the off-state
* leakage of a real 3.3 V switch (order of pA).  It is the only resistive path
* on the floating nodes besides the PDK MIM r_leak; no other resistors are added.
* .temp = MIM model tnom (25 C) so the ideal 32/31 bridge matches the PDK unit exactly
.temp 25
.options reltol=1e-9 abstol=1e-18 vntol=1e-12 method=gear
.save v(acp) v(afp) v(bcp) v(bfp)

.control
set noaskquit
set numdgt=12
shell rm -f split_binref_coef.txt
alter @v_bp9[pulse] = [ 1.65 3.3 30n 100p 100p 5n 2 ]
alter @v_bp8[pulse] = [ 1.65 3.3 40n 100p 100p 5n 2 ]
alter @v_bp7[pulse] = [ 1.65 3.3 50n 100p 100p 5n 2 ]
alter @v_bp6[pulse] = [ 1.65 3.3 60n 100p 100p 5n 2 ]
alter @v_bp5[pulse] = [ 1.65 3.3 70n 100p 100p 5n 2 ]
alter @v_bp4[pulse] = [ 1.65 3.3 80n 100p 100p 5n 2 ]
alter @v_bp3[pulse] = [ 1.65 3.3 90n 100p 100p 5n 2 ]
alter @v_bp2[pulse] = [ 1.65 3.3 100n 100p 100p 5n 2 ]
alter @v_bp1[pulse] = [ 1.65 3.3 110n 100p 100p 5n 2 ]
alter @v_bp0[pulse] = [ 1.65 3.3 120n 100p 100p 5n 2 ]
alter @v_bpd[pulse] = [ 1.65 3.3 130n 100p 100p 5n 2 ]
tran 20p 145n
let _m = time ge 29.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a0 = v(acp)[_i]
let _m = time ge 34n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a1 = v(acp)[_i]
let _m = time ge 29.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b0 = v(bcp)[_i]
let _m = time ge 34n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b1 = v(bcp)[_i]
let ka = (a1-a0)/1.65
let kb = (b1-b0)/1.65
echo BINREF bp9 >> split_binref_coef.txt
print ka >> split_binref_coef.txt
print kb >> split_binref_coef.txt
let _m = time ge 39.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a0 = v(acp)[_i]
let _m = time ge 44n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a1 = v(acp)[_i]
let _m = time ge 39.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b0 = v(bcp)[_i]
let _m = time ge 44n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b1 = v(bcp)[_i]
let ka = (a1-a0)/1.65
let kb = (b1-b0)/1.65
echo BINREF bp8 >> split_binref_coef.txt
print ka >> split_binref_coef.txt
print kb >> split_binref_coef.txt
let _m = time ge 49.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a0 = v(acp)[_i]
let _m = time ge 54n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a1 = v(acp)[_i]
let _m = time ge 49.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b0 = v(bcp)[_i]
let _m = time ge 54n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b1 = v(bcp)[_i]
let ka = (a1-a0)/1.65
let kb = (b1-b0)/1.65
echo BINREF bp7 >> split_binref_coef.txt
print ka >> split_binref_coef.txt
print kb >> split_binref_coef.txt
let _m = time ge 59.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a0 = v(acp)[_i]
let _m = time ge 64n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a1 = v(acp)[_i]
let _m = time ge 59.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b0 = v(bcp)[_i]
let _m = time ge 64n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b1 = v(bcp)[_i]
let ka = (a1-a0)/1.65
let kb = (b1-b0)/1.65
echo BINREF bp6 >> split_binref_coef.txt
print ka >> split_binref_coef.txt
print kb >> split_binref_coef.txt
let _m = time ge 69.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a0 = v(acp)[_i]
let _m = time ge 74n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a1 = v(acp)[_i]
let _m = time ge 69.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b0 = v(bcp)[_i]
let _m = time ge 74n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b1 = v(bcp)[_i]
let ka = (a1-a0)/1.65
let kb = (b1-b0)/1.65
echo BINREF bp5 >> split_binref_coef.txt
print ka >> split_binref_coef.txt
print kb >> split_binref_coef.txt
let _m = time ge 79.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a0 = v(acp)[_i]
let _m = time ge 84n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a1 = v(acp)[_i]
let _m = time ge 79.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b0 = v(bcp)[_i]
let _m = time ge 84n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b1 = v(bcp)[_i]
let ka = (a1-a0)/1.65
let kb = (b1-b0)/1.65
echo BINREF bp4 >> split_binref_coef.txt
print ka >> split_binref_coef.txt
print kb >> split_binref_coef.txt
let _m = time ge 89.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a0 = v(acp)[_i]
let _m = time ge 94n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a1 = v(acp)[_i]
let _m = time ge 89.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b0 = v(bcp)[_i]
let _m = time ge 94n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b1 = v(bcp)[_i]
let ka = (a1-a0)/1.65
let kb = (b1-b0)/1.65
echo BINREF bp3 >> split_binref_coef.txt
print ka >> split_binref_coef.txt
print kb >> split_binref_coef.txt
let _m = time ge 99.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a0 = v(acp)[_i]
let _m = time ge 104n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a1 = v(acp)[_i]
let _m = time ge 99.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b0 = v(bcp)[_i]
let _m = time ge 104n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b1 = v(bcp)[_i]
let ka = (a1-a0)/1.65
let kb = (b1-b0)/1.65
echo BINREF bp2 >> split_binref_coef.txt
print ka >> split_binref_coef.txt
print kb >> split_binref_coef.txt
let _m = time ge 109.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a0 = v(acp)[_i]
let _m = time ge 114n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a1 = v(acp)[_i]
let _m = time ge 109.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b0 = v(bcp)[_i]
let _m = time ge 114n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b1 = v(bcp)[_i]
let ka = (a1-a0)/1.65
let kb = (b1-b0)/1.65
echo BINREF bp1 >> split_binref_coef.txt
print ka >> split_binref_coef.txt
print kb >> split_binref_coef.txt
let _m = time ge 119.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a0 = v(acp)[_i]
let _m = time ge 124n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a1 = v(acp)[_i]
let _m = time ge 119.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b0 = v(bcp)[_i]
let _m = time ge 124n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b1 = v(bcp)[_i]
let ka = (a1-a0)/1.65
let kb = (b1-b0)/1.65
echo BINREF bp0 >> split_binref_coef.txt
print ka >> split_binref_coef.txt
print kb >> split_binref_coef.txt
let _m = time ge 129.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a0 = v(acp)[_i]
let _m = time ge 134n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let a1 = v(acp)[_i]
let _m = time ge 129.5n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b0 = v(bcp)[_i]
let _m = time ge 134n
let _i = floor(length(time) - mean(_m)*length(_m) + 0.5)
let b1 = v(bcp)[_i]
let ka = (a1-a0)/1.65
let kb = (b1-b0)/1.65
echo BINREF bpd >> split_binref_coef.txt
print ka >> split_binref_coef.txt
print kb >> split_binref_coef.txt
echo done
.endc
"}
C {title.sym} 160 0 0 0 {name=l1 author="Arjun Ananth"}
