###############################################################################
#   riscv_base.sdc
#   Based on /OpenLANE/scripts/base.sdc
###############################################################################

set ::env(CLOCK_PERIOD) 20.000
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_NET) $::env(CLOCK_PORT)

set ::env(SYNTH_DRIVING_CELL) sky130_fd_sc_hd__inv_8
set ::env(SYNTH_DRIVING_CELL_PIN) Y
set ::env(IO_PCT) 0.2
set ::env(SYNTH_CAP_LOAD) 17.65
set ::env(SYNTH_MAX_FANOUT) 6
set ::env(SYNTH_MAX_TRAN) [ expr 0.1 * $::env(CLOCK_PERIOD) ]
# -----------------------------------
# Default values:
#   SYNTH_CLOCK_UNCERTAINTY = 0.25
#   SYNTH_CLOCK_TRANSITION  = 0.15
#   SYNTH_TIMING_DERATE     = +/- 5%
# -----------------------------------
set ::env(SYNTH_CLOCK_UNCERTAINTY) 0.25
set ::env(SYNTH_CLOCK_TRANSITION) 0.15
set ::env(SYNTH_TIMING_DERATE) 0.05


set ::env(OUTPUT_CAP_LOAD) 17.65
set ::env(MAX_FANOUT_CONSTRAINT) 6
set ::env(MAX_TRANSITION_CONSTRAINT) [ expr 0.1 * $::env(CLOCK_PERIOD) ]


create_clock [get_ports $::env(CLOCK_PORT)]  -name $::env(CLOCK_PORT)  -period $::env(CLOCK_PERIOD)
set input_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
set output_delay_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
puts "\[INFO\]: Setting output delay to: $output_delay_value"
puts "\[INFO\]: Setting input delay to: $input_delay_value"

set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [current_design]
set_max_transition $::env(MAX_TRANSITION_CONSTRAINT) [current_design]

set clk_input [get_port $::env(CLOCK_PORT)]
set clk_indx [lsearch [all_inputs] $clk_input]
set all_inputs_wo_clk [lreplace [all_inputs] $clk_indx $clk_indx ""]

#set rst_input [get_port resetn]
#set rst_indx [lsearch [all_inputs] $rst_input]
#set all_inputs_wo_clk_rst [lreplace $all_inputs_wo_clk $rst_indx $rst_indx ""]
set all_inputs_wo_clk_rst $all_inputs_wo_clk

# correct resetn
set_input_delay $input_delay_value  -clock [get_clocks $::env(CLOCK_PORT)] $all_inputs_wo_clk_rst
#set_input_delay 0.0 -clock [get_clocks $::env(CLOCK_PORT)] {resetn}
set_output_delay $output_delay_value  -clock [get_clocks $::env(CLOCK_PORT)] [all_outputs]

set ::env(SYNTH_CLK_DRIVING_CELL) $::env(SYNTH_DRIVING_CELL)


set ::env(SYNTH_CLK_DRIVING_CELL_PIN) $::env(SYNTH_DRIVING_CELL_PIN)
#set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]
set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) $all_inputs_wo_clk_rst
set_driving_cell -lib_cell $::env(SYNTH_CLK_DRIVING_CELL) -pin $::env(SYNTH_CLK_DRIVING_CELL_PIN) $clk_input

# fF -> pF
set cap_load [expr $::env(OUTPUT_CAP_LOAD) / 1000.0] 
puts "\[INFO\]: Setting load to: $cap_load"
set_load  $cap_load [all_outputs]

puts "\[INFO\]: Setting clock uncertainty to: $::env(SYNTH_CLOCK_UNCERTAINTY)"
set_clock_uncertainty $::env(SYNTH_CLOCK_UNCERTAINTY) [get_clocks $::env(CLOCK_PORT)]

puts "\[INFO\]: Setting clock transition to: $::env(SYNTH_CLOCK_TRANSITION)"
set_clock_transition $::env(SYNTH_CLOCK_TRANSITION) [get_clocks $::env(CLOCK_PORT)]

puts "\[INFO\]: Setting timing derate to: [expr {$::env(SYNTH_TIMING_DERATE) * 100}] %"
set_timing_derate -early [expr {1-$::env(SYNTH_TIMING_DERATE)}]
set_timing_derate -late [expr {1+$::env(SYNTH_TIMING_DERATE)}]

###############################################################################
