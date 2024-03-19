[Back to TOC](../README.md)  
[Prev: Day 13](Day_13.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 15](Day_15.md)  
_________________________________________________________________________________________________________  
# Day 14 - Advanced Physical Design using OpenLANE/ Sky130

## Day 14.1: Inception of open-source EDA, OpenLANE and Sky130 PDK

  * **IC terminologies**
    * Chip Package
    * Pads & Padring
    * Core, die
    * IPs, Macros

### [**Overview of ASIC Design Flow using OpenLane**](http://ef.content.s3.amazonaws.com/OpenLane-DialUp-MohamedShalan.pdf)
  * ASIC implementation consists of numerous steps involving lots of detailed sub-processes at each step.
  * A **design methodology** is needed for a successful ASIC implementation without any hiccups.
  * The methodology is implemented through a **flow** that pieces together different tools to carry out the different steps of the design process from RTL to GDSII tapeout.

#### Simplified RTL to GDSII ASIC Design Flow
<kbd> ![Simplified Flow](/docs/images/D14.1_Simplified_Flow.png) </kbd>

  1) **Synthesis**: Converts RTL to a circuit using components from the Standard Cell Library (SCL)
  2) **Floor/ Power-planning**:
     **Floor-planning**  
     * _**Chip Floor-planning**_: Partition chip die area between the different building macros, IPs and place the I/O pads in the pad ring
     * _**Macro Floor-planning**_: Define the dimensions, pin locations and the internal row definitions of the macro
     **Power-Planning**: Design the Power Distribution Network (PDN) to ensure stable and efficient power delivery taking into account the different voltage rails, power usage trends and requirements of different blocks within the digital core, I/O and other AMS circuits.
  3) **Placement**: Place the cells on the floorplan rows aligned with the sites, non-overlapping with each other.  
     Usually done in 2 dteps: Global and Detailed
  4) **Clock Tree Synthesis (CTS)**: Create a balanced clock distribution network that ensure minial skew and achieves proper timing across the entire design.  
     Different types: H-tree, X-tree, Fish bone, Clock mesh.
  5) **Routing**: Implement the interconnections using the available metal layers.
     * Metal traacks form a routing grid, which is huge
     * Perform routing using a divide and conquer approach:
       * Global routing generates routing guides
       * Detailed routing uses the routing guides to implement the actual wires
  5) **Sign-Off**:
     * Physical Verification
       * Design Rule Checking (RDC)
       * Layout vs. Schematic (LVS)
     * Timing Verification
       * Static Timing Analysis (STA)

#### OpenLANE ASIC Design Flow
Main requirements of Digital ASIC Design:
  * RTL Design
  * EDA Tools
  * PDK

<kbd> ![D14.1_OpenSource_ASIC_Design](/docs/images/D14.1_OpenSource_ASIC_Design.png) </kbd>
  
Open Source RTL IPs and competitive EDA tools have been available.  
However, an OpenSource PDK was not available until Google collaborated with SkyWater to open source the skywater-130nm PDK.
  
**Process Design Kit (PDK)** : Interface between FAB and the designer, Process Design Kit, include:
  * Process Design Rule: DRC, LVS, PEX
  * Device Models
  * Digital Standard Cell Libraries
  * I/O Libraries

**Introduction to OpenLANE**  
  * Started as an Open-Source Flow for a True Open Source Tape-out Experiment
  * **Main Goal:** Produce a clean GDSII with no human intervention (no-human-in-the-loop)
  * **Clean means:** No LVS Errors and No DRC Errors
  * Tuned for SkyWater 130nm Open PDK. Also supports XFAB180 and GF130G
  * Containerized: Functional out of the box
  * Can be used to harden Macros and Chips
  * Two modes of operation:
    * Autonomous or Interactive
  * Supports Design Space Exploration: Find the best set of flow configurations


  
**OpenLANE ASIC Flow**  
  * OpenLANE project GitHub Page: [OpenLANE](https://github.com/efabless/openlane)
  * [OpenLANE ReadMe](https://openlane.readthedocs.io/en/latest/flow_overview.html)

  <kbd> ![OpenLANE Flow](/docs/images/D14.1_OpenLANE_Flow.png) </kbd>
  <br>
  
  1) Synthesis
     * `Yosys`: RTL Synthesis
     * `abc`: Technology mapping
  2) Post-synthesis STA
     * `OpenSTA`
  3) DFS Insertion
     * `Fault`: Scan Insertion, ATPG, Test Patterns compaction, Fault coverage, Fault simulation
  4) Floor-planning, Placement, CTS, Fake Antenna Diodes Insertion, Global Routing
     * `OpenROAD`: Also called automated PnR
  5) Logical Equivalence Check (LEC)
     * `Yosys`
       * Every time the netlist is modified (ECO), verification must be performed
         * CTS modifies the netlist
         * Post Placement optimizations modifies the netlist
       * LEC is used to formally confirm that the function did not change by modifying the netlist
  6) Detailed Routing
     * `TritonRoute`
  7) Fake Antenna Diodes removal
     * `Custom scripts in OpenROAD`
  8) RC Extraction:
     * `DEF2SPEF`
  9) Post-route STA
     * `OpenSTA`
  10) Physical Verification
      * `Magic` is used for Design Rules Checking and SPICE Extraction from Layout
      * `Netgen` is used for LVS
        * Extracted SPICE by Magic vs. Verilog netlist
  11) GDSII streaming
      * `Magic`

[**OpenROAD**](https://github.com/The-OpenROAD-Project/OpenROAD)
  * Everything in Floorplanning through Routing in the OpenLANE flow is done using OpenROAD and its various sub-utilities.
  * Also called automated PnR (Place and Route)
  * Performs:
    * Floor/Power Planning
    * End Decoupling Capacitors and Tap cells insertion
    * Placement: Global and Detailed
    * Post placement optimization
    * Clock Tree Synthesis (CTS)
    * Routing: Global and Detailed

<ins>**Handling of Antenna Rules Violations in OpenLANE flow</ins>**  
  * When a metal wire segment is fabricated, it can act as an antenna.
    * Reactive ion etching causes charge to accumulate on the wire.
    * Transistor gates can be damaged during fabrication  
    <kbd> ![Antenna_Rules](/docs/images/D14.1_AntennaRules_1.png) </kbd>
  * _**Two solutions:**_  
  <kbd> ![Antenna_Rules_Soln](/docs/images/D14.1_AntennaRules_Soln.png) </kbd>
    * Bridging attaches a higher layer intermediary
      * Requires Router awareness (not there yet!)
    * Add antenna diode cell to leak away charges
      * Antenna diodes are provided by the SCL  
  * _**Methodology followed:**_ a preventive approach
    * Add a Fake Antenna Diode next to every cell input after placement
    * Run the Antenna Checker (Magic) on the routed layout
    * If the checker reports a violation on the cell input pin, replace the Fake Diode cell by a real one
  <kbd> ![D14.1_AntennaRules_FakeDiode_RealDiode](/docs/images/D14.1_AntennaRules_FakeDiode_RealDiode.png) </kbd>


### Lab: Familiarize with OpenLANE flow

**Objectives**:  
Using an existing design provided in the OpenLANE package to:
  * Familiarize with the OpenLANE directory structure and different input files
  * Familiarize with the OpenLANE flow
  * Analyse the intermediate step results
  * Learn about the different control knobs and switches available for design space exploration  
    The OpenLANE flow can be configured using the following available variables for design
    * **Flow Configuration variables**: [https://openlane.readthedocs.io/en/latest/reference/configuration.html](https://openlane.readthedocs.io/en/latest/reference/configuration.html)
    * **PDK Configuration variables**: [https://openlane.readthedocs.io/en/latest/reference/pdk_configuration.html](https://openlane.readthedocs.io/en/latest/reference/pdk_configuration.html)  

**Design used for this exercise: picorv32a**
  
  1) To invoke OpenLANE, cd to the home directory of OpenLANE and run docker:  
    `docker run -it -v $(pwd):/openLANE_flow -v $PDK_ROOT:$PDK_ROOT -e PDK_ROOT=$PDK_ROOT -u $(id -u $USER):$(id -g $USER) efabless/openlane:v0.21`  
    where the env variable PDK_ROOT points to the directory path containing the **sky130A** library.

  2) The entry point for OpenLANE is the `./flow.tcl` script. This script is used to run the flow, start interactive sessions, select the configuration and create OpenLane design files.
     * To run the automated flow for a design:
       ```
       ./flow.tcl -design <design_name>
       ```
     * To start an [**interactive session**](https://openlane.readthedocs.io/en/latest/reference/interactive_mode.html):
       ```
       ./flow.tcl -interactive
       ```
  3) We will be using the interactive mode to learn about the different steps in the flow.
     * The commands to start an interactive session and run the synthesis of the **picorv32a** example design are given below:
       ```
       ./flow.tcl -interactive
       package require openlane 0.9
       prep -design picorv32a
       run_synthesis
       ```  
| ![D14.1_Lab1_OpenLANE_InteractiveMode](/docs/images/D14.1_Lab1_OpenLANE_InteractiveMode.png) |
|-|

   * **Synthesis Result:**

| ![D14.1_Lab2_run_synthesis](/docs/images/D14.1_Lab2_run_synthesis.png) |
|-|

       === picorv32a ===
       
          Number of wires:              14596
          Number of wire bits:          14978
          Number of public wires:        1565
          Number of public wire bits:    1947
          Number of memories:               0
          Number of memory bits:            0
          Number of processes:              0
          Number of cells:              14876
            sky130_fd_sc_hd__a2111o_2       1
            sky130_fd_sc_hd__a211o_2       35
            sky130_fd_sc_hd__a211oi_2      60
            sky130_fd_sc_hd__a21bo_2      149
            sky130_fd_sc_hd__a21boi_2       8
            sky130_fd_sc_hd__a21o_2        57
            sky130_fd_sc_hd__a21oi_2      244
            sky130_fd_sc_hd__a221o_2       86
            sky130_fd_sc_hd__a22o_2      1013
            sky130_fd_sc_hd__a2bb2o_2    1748
            sky130_fd_sc_hd__a2bb2oi_2     81
            sky130_fd_sc_hd__a311o_2        2
            sky130_fd_sc_hd__a31o_2        49
            sky130_fd_sc_hd__a31oi_2        7
            sky130_fd_sc_hd__a32o_2        46
            sky130_fd_sc_hd__a41o_2         1
            sky130_fd_sc_hd__and2_2       157
            sky130_fd_sc_hd__and3_2        58
            sky130_fd_sc_hd__and4_2       345
            sky130_fd_sc_hd__and4b_2        1
            sky130_fd_sc_hd__buf_1       1656
            sky130_fd_sc_hd__buf_2          8
            sky130_fd_sc_hd__conb_1        42
            sky130_fd_sc_hd__dfxtp_2     1613
            sky130_fd_sc_hd__inv_2       1615
            sky130_fd_sc_hd__mux2_1      1224
            sky130_fd_sc_hd__mux2_2         2
            sky130_fd_sc_hd__mux4_1       221
            sky130_fd_sc_hd__nand2_2       78
            sky130_fd_sc_hd__nor2_2       524
            sky130_fd_sc_hd__nor2b_2        1
            sky130_fd_sc_hd__nor3_2        42
            sky130_fd_sc_hd__nor4_2         1
            sky130_fd_sc_hd__o2111a_2       2
            sky130_fd_sc_hd__o211a_2       69
            sky130_fd_sc_hd__o211ai_2       6
            sky130_fd_sc_hd__o21a_2        54
            sky130_fd_sc_hd__o21ai_2      141
            sky130_fd_sc_hd__o21ba_2      209
            sky130_fd_sc_hd__o21bai_2       1
            sky130_fd_sc_hd__o221a_2      204
            sky130_fd_sc_hd__o221ai_2       7
            sky130_fd_sc_hd__o22a_2      1312
            sky130_fd_sc_hd__o22ai_2       59
            sky130_fd_sc_hd__o2bb2a_2     119
            sky130_fd_sc_hd__o2bb2ai_2     92
            sky130_fd_sc_hd__o311a_2        8
            sky130_fd_sc_hd__o31a_2        19
            sky130_fd_sc_hd__o31ai_2        1
            sky130_fd_sc_hd__o32a_2       109
            sky130_fd_sc_hd__o41a_2         2
            sky130_fd_sc_hd__or2_2       1088
            sky130_fd_sc_hd__or2b_2        25
            sky130_fd_sc_hd__or3_2         68
            sky130_fd_sc_hd__or3b_2         5
            sky130_fd_sc_hd__or4_2         93
            sky130_fd_sc_hd__or4b_2         6
            sky130_fd_sc_hd__or4bb_2        2
       
          Chip area for module '\picorv32a': 147712.918400
      
   * **Flop Ratio**
     ```
     Flop Ratio = (Total no. of Flops/ Total no. of cells in the design)
                = 1613/ 14876
                = 10.843%
     ```
  
  * **NOTE:**
    The order of precedence of the config files in the OpenLANE flow is as follows, with the settings in the highest priority config overriding the values set in the previous config files:  
    _**From lowest to highest:**_  
    * Default OpenLANE config values
    * openlane/designs/<design-name>/config.tcl
    * openlane/designs/<design-name>/sky130A_sky130_fd_sc_hd_config.tcl
_________________________________________________________________________________________________________  

## Day 14.2: Floorplan considerations, Placement, Library Cells

### 14.2.1 Floorplan considerations
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

### Lab: Run floorplan using OpenLANE and review the layout in Magic
  * To run the floorplan creation, execute the following command from the OpenLANE shell: `run_floorplan`
       
  <kbd> ![D14.1_Lab_3a_run_floorplan](/docs/images/D14.1_Lab_3a_run_floorplan.png) </kbd>

  * To view the floor plan in Magic: 
    ```
    1) cd to the floorplan results directory for the current run: openlane/designs/<design-name>/runs/<time-stamp>/results/floorplan
    2) magic -T $PDK_ROOT/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.lef def read ./picorv32a.floorplan.def &
    ```

| **Floorplan view in Magic<br>  (FP_IO_MODE=1, Random equidistant mode)**<br>  ![D14.1_Lab_3b_floorplan_in_Magic](/docs/images/D14.1_Lab_3b_floorplan_in_Magic.png) |
|:---|
| **Floorplan Zoomed in at (0,0)** <br>  ![D14.1_Lab_3c_floorplan_in_Magic_Cells_at_0_0](/docs/images/D14.1_Lab_3c_floorplan_in_Magic_Cells_at_0_0.png) |
| **FP_IO_MODE=0<br>  (Matching mode)** <br>  ![D14.1_Lab_3d_floorplan_in_Magic_FP_IO_Mode_0](/docs/images/D14.1_Lab_3d_floorplan_in_Magic_FP_IO_Mode_0.png) |
| **FP_IO_MODE=1 Zoomed**<br>  ![D14.1_Lab_3d_floorplan_in_Magic_FP_IO_Mode_1_Zoomed](/docs/images/D14.1_Lab_3d_floorplan_in_Magic_FP_IO_Mode_1_Zoomed.png) |


### 14.2.2 Placement and Routing
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
   
  4) Congestion aware placement using RePlAce
     * HPWL (Half-Parameter Wire Length) based routing


### 14.2.3 Cell Design Flow
**Library**
  * Std cells of different:
    * logic functionality
    * size/ drive strengths
    * threshold voltages

**Stages**  
<kbd> ![D14.2_Cell_Design_Flow](/docs/images/D14.2_Cell_Design_Flow.png) </kbd>
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
          
          --> Now, feed in all this to GUNA tool --> to generate Timing, noise, power .libs, function
  
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
         * Large RC delays
  
  3) Transition time
     * t_rise = time(slew_high_rise_thr) - time(slew_low_rise_thr)
     * t_fall = time(slew_low_fall_thr) - time(slew_high_fall_thr)
  
_________________________________________________________________________________________________________  
  
## Day 14.3: Design library cell using Magic layout tool and characterization using ngspice


<br>

_________________________________________________________________________________________________________  
[Prev: Day 13](Day_13.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 15](Day_15.md)  
