load cdac_r4
select top cell
expand
drc euclidean on
drc style drc(full)
drc check
drc catchup
set n [drc listall count total]
puts "DRC_TOTAL $n"
set why [drc listall why]
foreach {msg boxes} $why { puts "DRCWHY [llength $boxes] :: $msg" ; foreach b [lrange $boxes 0 2] { puts "   at $b" } }
quit -noprompt
