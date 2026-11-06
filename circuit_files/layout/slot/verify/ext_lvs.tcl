# magic: read the slot top GDS (v2 macro + adapter), extract the full hierarchy, write the LVS netlist
gds readonly true
gds read ../gds/sar_adc_r4_slot.gds
load sar_adc_r4_slot
select top cell
extract path .
extract all
ext2spice lvs
ext2spice -o sar_adc_r4_slot_lvs.spice
puts EXT_DONE
quit -noprompt
