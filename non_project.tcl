# Copyright (C) Christopher R. Bowman
# All rights reserved
#
# Vivado version: 2023.1
#
# Simple TCL script to build a simple project
# I don't know it's Viviado 2023.1 specific but that's what I run it on
#

# check that were running a support Vivado version
set vivado_version [version]
if  {[lrange $vivado_version 1 1] != "v2023.1" } {
	puts "ERROR: got Vivado version: \n$vivado_version \nexpecting Vivado version 2023.1"
	exit
}

# set the part package and speed grade of the FPGA we're targeting
set part xc7z020
set package clg400
set speed 1
set part_num "$part$package-$speed"
set proj_name ssd
set output implementation

# delete the implementation directory
file delete -force $output
file mkdir $output

# read the design sources both verilog and SDC/XDC
read_verilog [ glob source/verilog/*.v ]
read_xdc source/constraints/Arty-Z7-20-Master.xdc

# synthesize the design and write out some reports
synth_design -top top -part $part_num
write_checkpoint -force $output/post_synth.dcp
report_timing_summary -file $output/post_synth_timing_summary.rpt
report_utilization -file $output/post_synth_util.rpt

# optimize the design and place it, also write out a utilization report
opt_design
place_design
report_clock_utilization -file $output/clock_util.rpt

# no check necessary as there are no timing paths
# check timing, if there is a violation do physical optimzation
# negative slack means we are over timing budget
#if {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]] < 0} {
#  puts "WARNING: timing violated performing physical optimization"
#  phys_opt_design
#}
write_checkpoint -force $output/post_place.dcp
report_utilization -file $output/post_place_util.rpt
report_timing_summary -file $output/post_place_timing_summary.rpt

#Route design and generate bitstream
route_design -directive Explore
write_checkpoint -force $output/post_route.dcp
report_route_status -file $output/post_route_status.rpt
report_timing_summary -file $output/post_route_timing_summary.rpt
report_power -file $output/post_route_power.rpt
report_drc -file $output/post_imp_drc.rpt
write_verilog -force $output/${proj_name}_impl_netlist.v -mode timesim -sdf_anno true
write_bitstream -force $output/static.bit

exit
