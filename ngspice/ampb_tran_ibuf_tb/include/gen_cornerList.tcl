#!/usr/bin/tclsh

proc combine {paramList} {
  proc combine0 {a b} {
    set c {}
    foreach a_ $a {
      foreach b_ $b {lappend c "${a_},${b_}"}
    }
    return $c
  }

  set l [llength $paramList]
  set c [lindex $paramList [expr $l-1]]
  for {set i 0} {$i < [expr $l-1]} {incr i} {
    set a [lindex $paramList [expr $l-$i-2]]
    set b $c
    set c [combine0 $a $b]   
  }
  
  return $c
}

set paramNames {{temp} {mos}}
set paramList  {{27 0 70} {typical ss ff sf fs}}

set c [combine $paramList]

set d {}
for {set i 0} {$i < [llength $c]} {incr i} {
  lappend d $i,[lindex $c $i]
}

set header [string map {" " ,} [join $paramNames]]
set header num,$header
set fp [open "cornersList" w]
puts $fp $header
foreach d_ $d {puts $fp $d_}
close $fp

