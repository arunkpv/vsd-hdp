###############################################################################
# Created by write_sdc
# Sat Mar  2 09:12:17 2024
###############################################################################
current_design riscv_core
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 10.0000 [get_ports {clk}]
set_clock_uncertainty -setup 0.5000 clk
set_clock_uncertainty -hold 0.2000 clk
set_clock_latency -source -min 1.0000 [get_clocks {clk}]
set_clock_latency -source -max 4.0000 [get_clocks {clk}]
set_input_delay 1.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {reset}]
set_input_delay 3.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {reset}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -min -add_delay [get_ports {out[0]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -min -add_delay [get_ports {out[0]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -min -add_delay [get_ports {out[1]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -min -add_delay [get_ports {out[1]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -min -add_delay [get_ports {out[2]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -min -add_delay [get_ports {out[2]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -min -add_delay [get_ports {out[3]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -min -add_delay [get_ports {out[3]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -min -add_delay [get_ports {out[4]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -min -add_delay [get_ports {out[4]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -min -add_delay [get_ports {out[5]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -min -add_delay [get_ports {out[5]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -min -add_delay [get_ports {out[6]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -min -add_delay [get_ports {out[6]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -min -add_delay [get_ports {out[7]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -min -add_delay [get_ports {out[7]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -min -add_delay [get_ports {out[8]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -min -add_delay [get_ports {out[8]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -rise -min -add_delay [get_ports {out[9]}]
set_output_delay 5.0000 -clock [get_clocks {clk}] -fall -min -add_delay [get_ports {out[9]}]
###############################################################################
# Environment
###############################################################################
set_input_transition -min 0.5000 [get_ports {reset}]
set_input_transition -max 0.1000 [get_ports {reset}]
###############################################################################
# Design Rules
###############################################################################
