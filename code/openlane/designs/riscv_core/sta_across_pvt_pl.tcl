set list_of_lib_files(1)  "sky130_fd_sc_hd__tt_025C_1v80.lib"
set list_of_lib_files(2)  "sky130_fd_sc_hd__tt_100C_1v80.lib"
set list_of_lib_files(3)  "sky130_fd_sc_hd__ff_100C_1v65.lib"
set list_of_lib_files(4)  "sky130_fd_sc_hd__ff_100C_1v95.lib"
set list_of_lib_files(5)  "sky130_fd_sc_hd__ff_n40C_1v56.lib"
set list_of_lib_files(6)  "sky130_fd_sc_hd__ff_n40C_1v65.lib"
set list_of_lib_files(7)  "sky130_fd_sc_hd__ff_n40C_1v76.lib"
set list_of_lib_files(8)  "sky130_fd_sc_hd__ff_n40C_1v95.lib"
set list_of_lib_files(9)  "sky130_fd_sc_hd__ss_100C_1v40.lib"
set list_of_lib_files(10) "sky130_fd_sc_hd__ss_100C_1v60.lib"
set list_of_lib_files(11) "sky130_fd_sc_hd__ss_n40C_1v28.lib"
set list_of_lib_files(12) "sky130_fd_sc_hd__ss_n40C_1v35.lib"
set list_of_lib_files(13) "sky130_fd_sc_hd__ss_n40C_1v40.lib"
set list_of_lib_files(14) "sky130_fd_sc_hd__ss_n40C_1v44.lib"
set list_of_lib_files(15) "sky130_fd_sc_hd__ss_n40C_1v60.lib"
set list_of_lib_files(16) "sky130_fd_sc_hd__ss_n40C_1v76.lib"


set run_tag $::env(RUN_TAG)

set_cmd_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm -distance um
set_units -time ns -capacitance pF -current mA -voltage V -resistance kOhm -distance um

read_db /openlane/designs/riscv_core/runs/$run_tag/results/placement/riscv_core.odb
current_design

puts "###################################"
puts "### START of Post-Placement STA ###"
puts "###################################"
for {set i 1} {$i <= [array size list_of_lib_files]} {incr i} {
puts "Running Corner $i: $list_of_lib_files($i)"
read_liberty $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/$list_of_lib_files($i)

read_sdc /openlane/designs/riscv_core/src/riscv_base_pre_cts.sdc

check_setup -verbose

if { $i == 1 } {
    exec echo -n > /openlane/designs/riscv_core/sta_output_$run_tag/placement/corners_list.txt
    exec echo -n > /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_worst_max_slack.txt
    exec echo -n > /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_worst_min_slack.txt
    exec echo -n > /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_tns.txt
    exec echo -n > /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_wns.txt
    
} else {
    # Do nothing
}

exec echo "$list_of_lib_files($i)" >> /openlane/designs/riscv_core/sta_output_$run_tag/placement/corners_list.txt

report_checks -path_delay min_max -fields {nets cap slew input_pins fanout} -digits {4} > /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_min_max_$list_of_lib_files($i).txt

exec echo -ne "$list_of_lib_files($i)    " >> /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_worst_max_slack.txt
report_worst_slack -max -digits {4} >> /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_worst_max_slack.txt

exec echo -ne "$list_of_lib_files($i)    " >> /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_worst_min_slack.txt
report_worst_slack -min -digits {4} >> /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_worst_min_slack.txt

exec echo -ne "$list_of_lib_files($i)    " >> /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_tns.txt
report_tns -digits {4} >> /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_tns.txt

exec echo -ne "$list_of_lib_files($i)    " >> /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_wns.txt
report_wns -digits {4} >> /openlane/designs/riscv_core/sta_output_$run_tag/placement/sta_wns.txt
}
puts "#################################"
puts "### END of Post-Placement STA ###"
puts "#################################"

exit
