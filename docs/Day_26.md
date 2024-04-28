[Back to TOC](../README.md)  
[Prev: Day 25](Day_25.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 27](Day_27.md)  
_________________________________________________________________________________________________________  
# Day 26 - Post-CTS, Post-Routing STA analysis of your Design

## 26.1 STA Comparison
**OpenLane Configuration:**
  * [config.tcl](/code/openlane/designs/riscv_core/config.tcl)
  * [sky130A_sky130_fd_sc_hd_config.tcl](/code/openlane/designs/riscv_core/sky130A_sky130_fd_sc_hd_config.tcl)
  * [Pre-CTS SDC File](/code/openlane/designs/riscv_core/src/riscv_base_pre_cts.sdc)
  * [Post-CTS SDC File](/code/openlane/designs/riscv_core/src/riscv_base_post_cts.sdc)

**Design Area**
  * **Synthesis**: `115293.075200`
  * **Placement**: `124358 u^2 33% utilization`
  * **CTS**: `129960 u^2 34% utilization`

| **Post-Synthesis** <br>  ![D26_riscv_core_post-synthesis_STA](/docs/images/D26_riscv_core_post-synthesis_STA.png) | **Post-Placement (Pre-CTS)** <br>  ![D26_riscv_core_post-placement_STA](/docs/images/D26_riscv_core_post-placement_STA.png) |
|:---:|:---:|
| **Post-Routing** <br>  ![D26_riscv_core_post-Route_STA](/docs/images/D26_riscv_core_post-Route_STA.png) | **Post-CTS** <br>  ![D26_riscv_core_post-CTS_STA](/docs/images/D26_riscv_core_post-CTS_STA.png) |

|   |  
|:---:|
| ![D26_riscv_core_PostCTS_PostRoute_STA_wns](/docs/images/D26_riscv_core_PostCTS_PostRoute_STA_wns.png) |
| ![D26_riscv_core_PostCTS_PostRoute_STA_tns](/docs/images/D26_riscv_core_PostCTS_PostRoute_STA_tns.png) |
| ![D26_riscv_core_PostCTS_PostRoute_STA_worst_setup_slack](/docs/images/D26_riscv_core_PostCTS_PostRoute_STA_worst_setup_slack.png) |
| ![D26_riscv_core_PostCTS_PostRoute_STA_worst_hold_slack](/docs/images/D26_riscv_core_PostCTS_PostRoute_STA_worst_hold_slack.png) |

**NOTE:** Writing powered verilog netlist
  ```
  write_powered_verilog -output_def riscv_core_powered_verilog.def -output_nl $::env(routing_logs)/$::env(DESIGN_NAME).nl.v -output_pnl $::env(routing_logs)/$::env(DESIGN_NAME).powered.v
  set_netlist $::env(routing_logs)/$::env(DESIGN_NAME).powered.v
  ```

<!--
  | **Post-Synthesis** <br>  ![D26_riscv_core_post-synthesis_STA2](/docs/images/D26_riscv_core_post-synthesis_STA2.png) | **Post-Placement (Pre-CTS)** <br>  ![D26_riscv_core_post-placement_STA2](/docs/images/D26_riscv_core_post-placement_STA2.png) |
  |:---:|:---:|
  | **Post-Routing** <br>  ![D26_riscv_core_post-Route_STA2](/docs/images/D26_riscv_core_post-Route_STA2.png) | **Post-CTS** <br>  ![D26_riscv_core_post-CTS_STA2](/docs/images/D26_riscv_core_post-CTS_STA2.png) |
-->


<br>

_________________________________________________________________________________________________________  
[Prev: Day 25](Day_25.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 27](Day_27.md)  

