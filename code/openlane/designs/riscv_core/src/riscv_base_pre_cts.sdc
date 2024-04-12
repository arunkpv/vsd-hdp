# #############################################################################
#   riscv_base_pre_cts.sdc                                                    #
#   Based on /OpenLANE/scripts/base.sdc                                       #
# #############################################################################

set ::env(CLOCK_PERIOD) 10.000
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_NET) $::env(CLOCK_PORT)

# Putting these values here from config.tcl
# to be able to run STA indepedently outside of OpenLane
set ::env(SYNTH_DRIVING_CELL) sky130_fd_sc_hd__inv_8
set ::env(SYNTH_DRIVING_CELL_PIN) Y
set ::env(IO_PCT) 0.20;                     # Default value: 0.20
set ::env(SYNTH_CLOCK_UNCERTAINTY) 0.50;    # Default value: 0.25
set ::env(SYNTH_CLOCK_TRANSITION) 0.20;     # Default value: 0.15
set ::env(SYNTH_TIMING_DERATE) 0.05;        # Default value: +/- 5%

# Following have been deprecated:
#set ::env(SYNTH_CAP_LOAD) 17.65
#set ::env(SYNTH_MAX_FANOUT) 6
#set ::env(SYNTH_MAX_TRAN) [ expr 0.1 * $::env(CLOCK_PERIOD) ]

set ::env(OUTPUT_CAP_LOAD) 17.65
set ::env(MAX_FANOUT_CONSTRAINT) 6
set ::env(MAX_TRANSITION_CONSTRAINT) [ expr 0.1 * $::env(CLOCK_PERIOD) ]

if { ![info exists ::env(SYNTH_CLK_DRIVING_CELL)] } {
    set ::env(SYNTH_CLK_DRIVING_CELL) $::env(SYNTH_DRIVING_CELL)
}

if { ![info exists ::env(SYNTH_CLK_DRIVING_CELL_PIN)] } {
    set ::env(SYNTH_CLK_DRIVING_CELL_PIN) $::env(SYNTH_DRIVING_CELL_PIN)
}
# #############################################################################


# #############################################################################
# Compute all parameter values here:
# #############################################################################

set clk_source_latency_min_value  [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT) * 0.5]; # (IO_PCT / 2)
set clk_source_latency_max_value  [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)];       # IO_PCT
set clk_network_latency_min_value [expr $::env(CLOCK_PERIOD) * 0.10];       # 10%
set clk_network_latency_max_value [expr $::env(CLOCK_PERIOD) * 0.20];       # 20%
set clk_uncertainty_value $::env(SYNTH_CLOCK_UNCERTAINTY)
set clk_transition_min_value 0.15
set clk_transition_max_value $::env(SYNTH_CLOCK_TRANSITION)

set input_delay_min_value  [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT) * 0.5]
set input_delay_max_value  [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
set output_delay_min_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT) * 0.5]
set output_delay_max_value [expr $::env(CLOCK_PERIOD) * $::env(IO_PCT)]
set input_trans_min_value     [expr $::env(CLOCK_PERIOD) * 0.05];   # 5%
set input_trans_max_value     [expr $::env(CLOCK_PERIOD) * 0.10];   # 10%
set clk_input_trans_min_value [expr $::env(CLOCK_PERIOD) * 0.02];   # 2% 
set clk_input_trans_max_value [expr $::env(CLOCK_PERIOD) * 0.05];   # 5% 

set cap_load [expr $::env(OUTPUT_CAP_LOAD) / 1000.0]; # fF -> pF
# --------------------------------------------------
# Separate input ports to clk inputs & other inputs:
# --------------------------------------------------
set clk_input [get_port $::env(CLOCK_PORT)]
set clk_indx [lsearch [all_inputs] $clk_input]
set all_inputs_wo_clk [lreplace [all_inputs] $clk_indx $clk_indx ""]
#set rst_input [get_port resetn]
#set rst_indx [lsearch [all_inputs] $rst_input]
#set all_inputs_wo_clk_rst [lreplace $all_inputs_wo_clk $rst_indx $rst_indx ""]
set all_inputs_wo_clk_rst $all_inputs_wo_clk
# #############################################################################


# #############################################################################
# Set the SDC constraints
# #############################################################################

create_clock -name $::env(CLOCK_PORT) -period $::env(CLOCK_PERIOD) [get_ports $::env(CLOCK_PORT)]
set_clock_latency -source -min $clk_source_latency_min_value [get_port $::env(CLOCK_PORT)]
set_clock_latency -source -max $clk_source_latency_max_value [get_port $::env(CLOCK_PORT)]
set_clock_latency -min $clk_network_latency_min_value [get_ports $::env(CLOCK_NET)]
set_clock_latency -max $clk_network_latency_max_value [get_ports $::env(CLOCK_NET)]

set_clock_uncertainty -setup $clk_uncertainty_value [get_clocks $::env(CLOCK_NET)]; # Over-design
set_clock_uncertainty -hold  $clk_uncertainty_value [get_clocks $::env(CLOCK_NET)]; # Over-design
set_clock_transition -min $clk_transition_min_value [get_clocks $::env(CLOCK_NET)]
set_clock_transition -max $clk_transition_max_value [get_clocks $::env(CLOCK_NET)]

set_max_fanout $::env(MAX_FANOUT_CONSTRAINT) [current_design]
set_max_transition $::env(MAX_TRANSITION_CONSTRAINT) [current_design]


set_input_delay -min $input_delay_min_value  -clock [get_clocks $::env(CLOCK_PORT)] $all_inputs_wo_clk_rst
set_input_delay -max $input_delay_max_value  -clock [get_clocks $::env(CLOCK_PORT)] $all_inputs_wo_clk_rst
#set_input_delay 0.0 -clock [get_clocks $::env(CLOCK_PORT)] {reset}
set_output_delay -min $output_delay_min_value  -clock [get_clocks $::env(CLOCK_PORT)] [all_outputs]
set_output_delay -max $output_delay_max_value  -clock [get_clocks $::env(CLOCK_PORT)] [all_outputs]

set_input_transition -min $input_trans_min_value $all_inputs_wo_clk_rst
set_input_transition -max $input_trans_max_value $all_inputs_wo_clk_rst
set_input_transition -min $clk_input_trans_min_value $clk_input
set_input_transition -max $clk_input_trans_max_value $clk_input
#set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]
set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) -input_transition_rise $input_trans_max_value -input_transition_fall $input_trans_max_value $all_inputs_wo_clk_rst
set_driving_cell -lib_cell $::env(SYNTH_CLK_DRIVING_CELL) -pin $::env(SYNTH_CLK_DRIVING_CELL_PIN) -input_transition_rise $clk_input_trans_max_value -input_transition_fall $clk_input_trans_max_value $clk_input

puts "\[INFO\]: Setting load to: $cap_load pF"
set_load  $cap_load [all_outputs]

puts "\[INFO\]: Setting timing derate to: [expr {$::env(SYNTH_TIMING_DERATE) * 100}] %"
set_timing_derate -early [expr {1 - $::env(SYNTH_TIMING_DERATE)}]
set_timing_derate -late  [expr {1 + $::env(SYNTH_TIMING_DERATE)}]

# #############################################################################
