[Back to TOC](../README.md)  
[Prev: Day 12](Day_12.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 14](Day_14.md)  
_________________________________________________________________________________________________________  
# Day 13
## PVT Corner Analysis
The STA checks are performed across all the corners to confirm the design meets the target timing requirements.
  * The worst max path (Setup-critical) corners in the sub-40nm process nodes are usually: ss_LowTemp_LowVolt, ss_HighTemp_LowVolt
  * The worst min path (Hold-critical) corners being: ff_LowTemp_HighVolt,ff_HighTemp_HighVolt
  * The below tcl script [**sta_across_pvt.tcl**](../code/riscv/scripts/sta_across_pvt.tcl) can be run to performt the STA across the PVT corners for which the sky130 lib files are available:
    ```
    set list_of_lib_files(1) "sky130_fd_sc_hd__tt_025C_1v80.lib"
    set list_of_lib_files(2) "sky130_fd_sc_hd__ff_100C_1v65.lib"
    set list_of_lib_files(3) "sky130_fd_sc_hd__ff_100C_1v95.lib"
    set list_of_lib_files(4) "sky130_fd_sc_hd__ff_n40C_1v56.lib"
    set list_of_lib_files(5) "sky130_fd_sc_hd__ff_n40C_1v65.lib"
    set list_of_lib_files(6) "sky130_fd_sc_hd__ff_n40C_1v76.lib"
    set list_of_lib_files(7) "sky130_fd_sc_hd__ss_100C_1v40.lib"
    set list_of_lib_files(8) "sky130_fd_sc_hd__ss_100C_1v60.lib"
    set list_of_lib_files(9) "sky130_fd_sc_hd__ss_n40C_1v28.lib"
    set list_of_lib_files(10) "sky130_fd_sc_hd__ss_n40C_1v35.lib"
    set list_of_lib_files(11) "sky130_fd_sc_hd__ss_n40C_1v40.lib"
    set list_of_lib_files(12) "sky130_fd_sc_hd__ss_n40C_1v44.lib"
    set list_of_lib_files(13) "sky130_fd_sc_hd__ss_n40C_1v76.lib"
    
    for {set i 1} {$i <= [array size list_of_lib_files]} {incr i} {
    read_liberty ./timing_libs/$list_of_lib_files($i)
    read_verilog ./riscv_pipelined_Final_netlist.v
    link_design riscv_core
    current_design
    read_sdc riscv_core_synthesis.sdc
    check_setup -verbose
    report_checks -path_delay min_max -fields {nets cap slew input_pins fanout} -digits {4} > ./sta_output/min_max_$list_of_lib_files($i).txt
    
    exec echo "$list_of_lib_files($i)" >> ./sta_output/sta_worst_max_slack.txt
    report_worst_slack -max -digits {4} >> ./sta_output/sta_worst_max_slack.txt
    
    exec echo "$list_of_lib_files($i)" >> ./sta_output/sta_worst_min_slack.txt
    report_worst_slack -min -digits {4} >> ./sta_output/sta_worst_min_slack.txt
    
    exec echo "$list_of_lib_files($i)" >> ./sta_output/sta_tns.txt
    report_tns -digits {4} >> ./sta_output/sta_tns.txt
    
    exec echo "$list_of_lib_files($i)" >> ./sta_output/sta_wns.txt
    report_wns -digits {4} >> ./sta_output/sta_wns.txt
    }
    ```


<br>

_________________________________________________________________________________________________________  
[Prev: Day 12](Day_12.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 14](Day_14.md)  
