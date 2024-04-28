[Back to TOC](../README.md)  
[Prev: Day 23](Day_23.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 25](Day_25.md)  
_________________________________________________________________________________________________________  

# Day 24: Final steps for RTL2GDS using tritonRoute and openSTA
##  24.1 Routing and Design Rule Check (DRC)
### Introduction to Maze Routing - Lee's Algorithm
  * Lee's algorithm is one possible solution for maze routing problems based on breadth-first search.
    * If a path exists between the source and target, this algorithm guarantees finding it.
    * It always finds the shortest path between the source and target.
  * <ins>**Steps**</ins>
    1) The layout area is divided into a Routing grid with keep-off areas for the pre-placed macros and logical blockages for the I/O pad ring.
    2) The next step is to identify the source pin (S) and target pin (T) of the cells in the grid
    3) Now, based on the distance from the grid box "S", adjacent grid boxes (only horizontal and vertical grid boxes are considered adjacent and not the diagonal ones) are labelled as 1. Next, the grid boxes adjacent to those labelled 1 are now labelled as 2. This iterative process progresses until we hit the target pin's, "T" grid box.
    * **Note**: The wave expansion marks only points in the routable area of the chip, not in the blocks or already wired parts.
  * Routes with lower number of bends are preferred.

  | **Lee's Routing Algorithm** <br>  ![D24_Lees_Routing_Algorithm_resized](/docs/images/D24_Lees_Routing_Algorithm_resized.png) <br>  **The blue route is preferred over the black one due to lower number of bends** |
  |:---|
  
  * This algorithm, however, has a high cost in term of both memory usage and run time.
  * To overcome these short-comings, there are other more advanced algorithms like Line Search algorithm & Steiner tree algorithm.

### Design Rule Check during routing
  * While performing routing, the router tool needs to follow the DRC rules related to routing provided by the PDK.
  * Basically, the origin of these DRCs come from the manufacturing process used like photolithography or others, that for example, define the minimum wire width that can be manufactured, the minimum spacing between two wire in a metal layer etc.

  | **Typical DRC rules for wires like width, spacing and pitch** <br>  ![D24_Routing_DRC_Typical_Rules_about_wire](/docs/images/D24_Routing_DRC_Typical_Rules_about_wire.png) |
  |:---|

  * Check out the DRC rules related to the local interconnect and the metal layers for [sky130 PDK DRC](https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#li).

  | **A Signal short during route** <br>  **Fixing it using other metal layers gives rise to new DRC checks related to VIAs** <br>  ![D24_Routing_DRC_Check_Examples_2](/docs/images/D24_Routing_DRC_Check_Examples_2.png) |
  |:---|

## 24.2 Power Distribution Network and Routing
### Lab: Steps to build Power Distribution Network
  * Levels of Power distribution
    ```
    > VDD, VSS pins/ balls
      |--> VDD, VSS pads
           |--> Core Power Rings
                |--> VDD, VSS Horizontal, Vertical Straps
                     |--> Standard Cell Rails
                     |
                     |--> Macro Power Ring
    ```

  | ![D24_Power_Distribution_Network_resized](/docs/images/D24_Power_Distribution_Network_resized.png) |
  |:---|
  | _**Source:**_ [Power Distribution Network](https://vlsibyjim.blogspot.com/2015/03/power-planning.html) |

  * Command to generate PDN in openLANE: `run_power_grid_generation`

  | **Layout after PDN generation** <br>  ![D24_Layout_after_PDN_Generation](/docs/images/D24_Layout_after_PDN_Generation.png) |
  |:---|
  | **Layout zoomed** <br>  ![D24_Layout_after_PDN_Generation_Zoomed](/docs/images/D24_Layout_after_PDN_Generation_Zoomed.png) |


### Lab: Steps to perform routing
  * To run the routing in OpenLANE, execute: `run_routing`

  | **No DRC violations after routing** <br> ![D24_Detailed_Routing_No_DRC_Viols](/docs/images/D24_Detailed_Routing_No_DRC_Viols.png) |
  |:---|
  | **No Timing violations at TYPICAL corner** <br> ![D24_STA_for_typical_after_routing](/docs/images/D24_STA_for_typical_after_routing.png) |
  | **Layout after routing (KLayout)** <br>  ![D24_Layout_after_routing_in_klayout](/docs/images/D24_Layout_after_routing_in_klayout.png) |
  | **Layout after routing - Zoomed (Magic)** <br>  ![D24_Layout_after_Routing](/docs/images/D24_Layout_after_Routing.png) |
  
  * **Post-route STA**
    ```
    read_lef /openLANE_flow/designs/picorv32a/runs/latest_25-03/tmp/merged.lef
    read_def /openLANE_flow/designs/picorv32a/runs/latest_25-03/results/routing/picorv32a.def
    read_spef /openLANE_flow/designs/picorv32a/runs/latest_25-03/results/routing/picorv32a.spef
    
    write_db picorv32a_routing.db
    
    read_db picorv32a_routing.db
    read_verilog /openLANE_flow/designs/picorv32a/runs/latest_25-03/results/synthesis/picorv32a.synthesis_preroute.v
    read_liberty $::env(LIB_SYNTH_COMPLETE)
    ##read_liberty -max $::env(LIB_SLOWEST)
    ##read_liberty -min $::env(LIB_FASTEST)
    link_design picorv32a
    read_sdc /openLANE_flow/designs/picorv32a/src/my_base.sdc
    set_propagated_clock [all_clocks]
    report_checks -path_delay min_max -format full_clock_expanded -digits 4 -fields {net cap slew input_pins fanout}
    ```
 
### Basics of global and detail routing
  * Global route using `fast route` and Detailed route using `tritonRoute`
  * Global route provides a routing guide.
  * In Detailed route, algorithms are used to find the best possible connectivity using the routing guides from global route.

### TritonRoute Features
  * Performs initial detail route
  * Honors the preprocessed route guides (obtained after global route) - i.e., attempts as much as possible to route within route guides.
  * Assumes route guides for each net satisfy inter-guide connectivity.
  * Works on proposed MILP-based panel routing scheme with intra-layer parallel and inter-layer sequential routing framework.

<br>

_________________________________________________________________________________________________________  
[Prev: Day 23](Day_23.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 25](Day_25.md)  
