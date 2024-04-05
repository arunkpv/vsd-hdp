[Back to TOC](../README.md)  
[Prev: Day 15](Day_15.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 17](Day_17.md)  
_________________________________________________________________________________________________________  
# Day 16 - Post-CTS, Post-Routing STA analysis of your Design

## 16.1 STA Comparison
* **Design Area**
  * **Synthesis**: `115293.075200`
  * **Placement**: `124358 u^2 33% utilization`
  * **CTS**: `129960 u^2 34% utilization`

| **Post-Synthesis** <br>  ![D16_riscv_core_post-synthesis_STA](/docs/images/D16_riscv_core_post-synthesis_STA.png) | **Post-Placement (Pre-CTS)** <br>  ![D16_riscv_core_post-placement_STA](/docs/images/D16_riscv_core_post-placement_STA.png) |
|:---:|:---:|
| **Post-Routing** <br>  ![D16_riscv_core_post-Route_STA](/docs/images/D16_riscv_core_post-Route_STA.png) | **Post-CTS** <br>  ![D16_riscv_core_post-CTS_STA](/docs/images/D16_riscv_core_post-CTS_STA.png) |

| **Post-Synthesis** <br>  ![D16_riscv_core_post-synthesis_STA2](/docs/images/D16_riscv_core_post-synthesis_STA2.png) | **Post-Placement (Pre-CTS)** <br>  ![D16_riscv_core_post-placement_STA2](/docs/images/D16_riscv_core_post-placement_STA2.png) |
|:---:|:---:|
| **Post-Routing** <br>  ![D16_riscv_core_post-Route_STA2](/docs/images/D16_riscv_core_post-Route_STA2.png) | **Post-CTS** <br>  ![D16_riscv_core_post-CTS_STA2](/docs/images/D16_riscv_core_post-CTS_STA2.png) |

<br>

|   |  
|:---:|
| ![D16_riscv_core_PostCTS_PostRoute_STA_wns](/docs/images/D16_riscv_core_PostCTS_PostRoute_STA_wns.png) |
| ![D16_riscv_core_PostCTS_PostRoute_STA_tns](/docs/images/D16_riscv_core_PostCTS_PostRoute_STA_tns.png) |
| ![D16_riscv_core_PostCTS_PostRoute_STA_worst_setup_slack](/docs/images/D16_riscv_core_PostCTS_PostRoute_STA_worst_setup_slack.png) |
| ![D16_riscv_core_PostCTS_PostRoute_STA_worst_hold_slack](/docs/images/D16_riscv_core_PostCTS_PostRoute_STA_worst_hold_slack.png) |

* **NOTE: Writing powered verilog netlist** 
  ```
  write_powered_verilog -output_def riscv_core_powered_verilog.def -output_nl $::env(routing_logs)/$::env(DESIGN_NAME).nl.v -output_pnl $::env(routing_logs)/$::env(DESIGN_NAME).powered.v
  set_netlist $::env(routing_logs)/$::env(DESIGN_NAME).powered.v
  ```
<br>

_________________________________________________________________________________________________________  
[Prev: Day 15](Day_15.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 17](Day_17.md)  

