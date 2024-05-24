[Back to TOC](../README.md)  
[Prev: Day 20](Day_20.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 22](Day_22.md)  
_________________________________________________________________________________________________________  
# Day 21: Floorplan considerations, Placement, Library Cells

## 21.1 Floorplan considerations
  1) Utilization factor and aspect ratio
       * Define W, H of core and die
           * Utilization Factor = (Area occupied by netlist)/(Total area of the core)
           * Usually we aim for 50-60 % Utilization Factor
        * Aspect Ratio = Height/ Width
        
  2) Define locations of pre-placed cells (macros and IPs ?)
       * IPs/ blocks have user-defined locations and hence placed before automated PnR and are called as pre-placed cells
       * Automated PnR tools places the remaining logical cells in the design onto the chip
        
  3) Decaps
       * Decouples the circuit from the VDD rail
       * Reduce Zpdn for the required frequencies of operation
       * Serve as a charge reservoir for the switching current demands that the VDD rail cannot satisfy.
       * Surround pre-placed cells with Decaps to compensate for the switching current demands (di/dt)
        
  4) Power Planning
     * SSN
       * L*di/dt
         * Discharging : Ground bounce
         * Charging    : Voltage Droop
       * **Solution:** Reduce the Vdd/ Vss parasitics ->
         * Power grid
         * Multiple VDD, VSS pins/ balls 
    
  5) Pin Placement
     * Usually: East -> West, North -> South, {East, North} -> {West, South}
     * Pin ordering is random (unless we specify explicitly ?)
     * Front-End to Back-End team communication/ handshaking needed for optimal pin placement
     * CLK ports/ pins are usually bigger to reduce the clk net resistance
        
  6) Logical Cell placement blockage - so that no cells are placed by the PnR tool inside the IP blocks/ macro area.

**Now Floorplan is ready for PnR**

### 21.1.1 Lab: Run floorplan using OpenLANE and review the layout in Magic
  * To run the floorplan creation, execute the following command from the OpenLANE shell: `run_floorplan`
       
  <kbd> ![D21_Lab_3a_run_floorplan](/docs/images/D21_Lab_3a_run_floorplan.png) </kbd>

  * To view the floor plan in Magic: 
    ```
    1) cd to the floorplan results directory for the current run: openlane/designs/<design-name>/runs/<time-stamp>/results/floorplan
    2) magic -T $PDK_ROOT/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.lef def read ./picorv32a.floorplan.def &
    ```

| **Floorplan view in Magic<br>  (FP_IO_MODE=1, Random equidistant mode)**<br>  ![D21_Lab_3b_floorplan_in_Magic](/docs/images/D21_Lab_3b_floorplan_in_Magic.png) |
|:---|
| **Floorplan Zoomed in at (0,0)** <br>  ![D21_Lab_3c_floorplan_in_Magic_Cells_at_0_0](/docs/images/D21_Lab_3c_floorplan_in_Magic_Cells_at_0_0.png) |
| **FP_IO_MODE=0<br>  (Matching mode)** <br>  ![D21_Lab_3d_floorplan_in_Magic_FP_IO_Mode_0](/docs/images/D21_Lab_3d_floorplan_in_Magic_FP_IO_Mode_0.png) |
| **FP_IO_MODE=1 Zoomed**<br>  ![D21_Lab_3d_floorplan_in_Magic_FP_IO_Mode_1_Zoomed](/docs/images/D21_Lab_3d_floorplan_in_Magic_FP_IO_Mode_1_Zoomed.png) |


## 21.2 Placement and Routing
  1) Bind netlist with physical cells
     * Library files
       * Shape, dimension info, power & timing/ delay info
       * Various flavors of all available std cells

  2) Placement
     * The location of pre-placed cells are fixed and PnR tools will not place any cells inside that area.
     * Initial global placement based on the input, output pins to reduce wire lengths
  
  3) Optimize placement
     * Ensure that Signal Integrity is maintained
         * Estimate the wire length and capacitance and insert repeaters/ buffers
         * MaxTrans delay/ signal slew
   
  4) Congestion aware placement using RePlAce followed by detailed placement using OpenDP
     * Global placement: HPWL (Half-Parameter Wire Length) based

### 21.2.1 Lab: Run placement
  * The `run_placement` command runs the global placement followed by detailed placement.
  * First the global placement happens, where the main objective is to reduce the wire length. Algorithm used is Half-Parameter Wire Length (HPWL).
  * Then detailed placement is performed to legalize the globally placed components.

| **run_placement**<br>  ![D21_Lab_4a_run_placement](/docs/images/D21_Lab_4a_run_placement.png) |
|:---|
| **Layout after placement**<br>  ![D21_Lab_4b_run_placement_Magic](/docs/images/D21_Lab_4b_run_placement_Magic.png) |
| **Layout after placement (Zoomed)** <br>  ![D21_Lab_4b_run_placement_Magic_zoomed](/docs/images/D21_Lab_4b_run_placement_Magic_zoomed.png) |

## 21.3 Cell Design Flow
**Library**
  * Std cells of different:
    * logic functionality
    * size/ drive strengths
    * threshold voltages

**Stages**  
<kbd> ![D21_Cell_Design_Flow](/docs/images/D21_Cell_Design_Flow.png) </kbd>
  1) **Inputs for Cell Design Flow**  
     From foundry, PDKs:  
       * DRC, LVS rules (eg: lambda-based design rules)
       * SPICE modelsfor the NMOS & PMOS devices
       * Library and user-defined specifications
         * Cell height (separation b/w VDD and GND rails) must be maintained
         * Cell width is determined by the drive strengths required
         * Supply voltage
         * Metal layers requirements
         * Pin locations
         * Drawn gate-length
  
  2) **Design Steps**
     * Circuit Design
       * Transistor sizing based on current drive, voltage transfer and other performance/ quality parameter requirements
     * Layout Design
       * Art of layout - Euler's path and stick diagram
     * Characterization
       1) Read the nmos, pmos models
       2) Read the extracted spice netlist
       3) Recognize the behaviour of the cell
       4) Read the sub-circuits
       5) Attach the power sources
       6) Apply the stimulus
       7) Provide the necessary output capacitance
       8) Provide the necessary simulation commands
          
     * Now, feed in all this to [**GUNA characterization tool**](https://www.paripath.com/Products/Guna)  --> to generate Timing, noise, power .libs, function
  
  3) **Outputs**
     * CDL (Circuit Description Language)
     * GDSII, LEF (dimensions), extracted spice netlist (.cir)
     * Timing, noise, power .libs, function
       
**Timing characterization parameters**
  1) Timing threshold definitions
     | Parameter | Usually used values |
     | --------- | ------------------- |
     | slew_low_rise_thr | 10%, 20% |
     | slew_high_rise_thr | 90%, 80% |
     | slew_low_fall_thr  | 10%, 20% |
     | slew_high_fall_thr | 90%, 80% |
     | in_rise_thr | 50% |
     | in_fall_thr | 50% |
     | out_rise_thr | 50% |
     | out_fall_thr | 50% |
  
  2) Propagation delay
     * propagation delay = time(out_*_thr) - time(in_*_thr)
       * Problematic cases:
         * Choice of threshold levels
         * Large RC delays (due to improper designs and/ or large loads, long routes)
  
  3) Transition time
     * t_rise = time(slew_high_rise_thr) - time(slew_low_rise_thr)
     * t_fall = time(slew_low_fall_thr) - time(slew_high_fall_thr)
  

_________________________________________________________________________________________________________  
[Prev: Day 20](Day_20.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 22](Day_22.md)  
