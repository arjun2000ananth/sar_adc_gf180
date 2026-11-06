load bpsw_bank
select top cell
expand
drc euclidean on
drc style drc(full)
drc check
drc catchup
set n [drc list count total]
puts "DRC_TOTAL $n"
foreach {why boxes} [drc listall why] {
  puts "DRC_WHY [llength $boxes] :: $why :: [lrange $boxes 0 1]"
}
quit -noprompt
