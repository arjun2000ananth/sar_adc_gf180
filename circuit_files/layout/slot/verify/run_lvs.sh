#!/bin/bash
# slot top netgen LVS: extracted sar_adc_r4_slot vs ref/sar_adc_r4_slot_ref.spice (env REF / TAG for negative tests)
cd "$(dirname "$0")/.."
NG=/nix/store/kw3frc6fbv3zi2m9n0wv93y1nfiyjiy6-netgen-1.5.316/bin/netgen
SETUP=$HOME/eda/pdks/gf180mcuD/libs.tech/netgen/gf180mcuD_setup.tcl
REF=${REF:-ref/sar_adc_r4_slot_ref.spice}; T=${TAG:-}
$NG -batch lvs "ext/sar_adc_r4_slot_lvs.spice sar_adc_r4_slot" "$REF sar_adc_r4_slot" $SETUP verify/lvs$T.out -json > verify/lvs$T.log 2>&1
grep -E "Netlists match|Netlists do not match|Final result|Property errors|property errors" verify/lvs$T.out | tail -6
if grep -q "Final result: Circuits match uniquely" verify/lvs$T.out && ! grep -qi "property errors" verify/lvs$T.out; then echo "LVS_RESULT PASS"; else echo "LVS_RESULT FAIL"; exit 1; fi
