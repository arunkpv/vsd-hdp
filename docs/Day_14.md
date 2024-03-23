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
       
  <kbd> ![D14.2_Lab_3a_run_floorplan](/docs/images/D14.2_Lab_3a_run_floorplan.png) </kbd>

  * To view the floor plan in Magic: 
    ```
    1) cd to the floorplan results directory for the current run: openlane/designs/<design-name>/runs/<time-stamp>/results/floorplan
    2) magic -T $PDK_ROOT/sky130A/libs.tech/magic/sky130A.tech lef read ../../tmp/merged.lef def read ./picorv32a.floorplan.def &
    ```

| **Floorplan view in Magic<br>  (FP_IO_MODE=1, Random equidistant mode)**<br>  ![D14.2_Lab_3b_floorplan_in_Magic](/docs/images/D14.2_Lab_3b_floorplan_in_Magic.png) |
|:---|
| **Floorplan Zoomed in at (0,0)** <br>  ![D14.2_Lab_3c_floorplan_in_Magic_Cells_at_0_0](/docs/images/D14.2_Lab_3c_floorplan_in_Magic_Cells_at_0_0.png) |
| **FP_IO_MODE=0<br>  (Matching mode)** <br>  ![D14.2_Lab_3d_floorplan_in_Magic_FP_IO_Mode_0](/docs/images/D14.2_Lab_3d_floorplan_in_Magic_FP_IO_Mode_0.png) |
| **FP_IO_MODE=1 Zoomed**<br>  ![D14.2_Lab_3d_floorplan_in_Magic_FP_IO_Mode_1_Zoomed](/docs/images/D14.2_Lab_3d_floorplan_in_Magic_FP_IO_Mode_1_Zoomed.png) |


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
   
  4) Congestion aware placement using RePlAce followed by detailed placement using OpenDP
     * Global placement: HPWL (Half-Parameter Wire Length) based

### Lab: Run placement
  * The `run_placement` command runs the global placement followed by detailed placement.
  * First the global placement happens, where the main objective is to reduce the wire length. Algorithm used is Half-Parameter Wire Length (HPWL).
  * Then detailed placement is performed to legalize the globally placed components.

| **run_placement**<br>  ![D14.2_Lab_4a_run_placement](/docs/images/D14.2_Lab_4a_run_placement.png) |
|:---|
| **Layout after placement**<br>  ![D14.2_Lab_4b_run_placement_Magic](/docs/images/D14.2_Lab_4b_run_placement_Magic.png) |
| **Layout after placement (Zoomed)** <br>  ![D14.2_Lab_4b_run_placement_Magic_zoomed](/docs/images/D14.2_Lab_4b_run_placement_Magic_zoomed.png) |

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
  
## Day 14.3: Design library cell using Magic layout tool and characterization using ngspice

### 16-Mask CMOS Process
TODO: Documentation

### Lab: Introduction to Sky130 basic layers layout and LEF using inverter
  * Clone a custom standard cell design from the following github repo for this exercise
    [https://github.com/nickson-jose/vsdstdcelldesign.git](https://github.com/nickson-jose/vsdstdcelldesign.git)
  * To open the design in magic: `magic -T sky130A.tech sky130_inv.mag`
  * Get familiarized with the different layers in sky130 technology.
  * To get the details about any drawn element in the layout, hover the mouse pointer over it and press `s` to select it (pressing multiple times selects the elements hierarchically).
    Then, from the **tkcon shell**, use the command `what` to print the details:
    
  | **sky130 Layers in Magic for an Inverter**<br>  ![D14.3_Lab_Magic_sky130_Layers](/docs/images/D14.3_Lab_Magic_sky130_Layers.png) |
  |:---|

### Lab: Create the Inverter Standard Cell layout and extract the SPICE netlist
  * The steps to layout a custom inverter standard cell in Magic is explained in this github repo: [vsdstdcelldesign](https://github.com/nickson-jose/vsdstdcelldesign?tab=readme-ov-file#standard-cell-layout-design-in-magic)
    * Magic has an interactive DRC engine - DRC violations are updated continuously in Magic every time we make a change (draw, erase, move) in the layout.
    * When we make small changes to an existing layout, we can find out immediately if we have introduced errors, without having to completely recheck the entire layout.
  * To extract the SPICE netlist of the layout including the parasitics, switch to the **tkcon shell** of Magic:
    ```
    extract all
    ext2spice cthresh 0 rthresh 0
    ext2spice
    ```
  * Open the extracted netlist and correct the following:
    * Ensure the Scaling: Open the layout in magic, enable the grid (Window menu -> Grid on), and zoom in to select one unit box. Find its dimensions by the command `box` from the **tkcon shell**
    * Include the SPICE models for sky130 short-channel PMOS and NMOS.
    * Change the PMOS and NMOS model names to match the ones in the included model files - `pshort_model.0, nshort_model.0`.

### Lab: Create a SPICE deck to run a simple transient simulation using ngspice
  * Modify the spice file to run a sample transient simulation using ngspice:
    * Add VDD and GND:
      ```
      VDD VPWR 0 3.3V
      VSS VGND 0 0V
      ``` 
    * Add a pulse source to the input node: `Va A VGND PULSE(0V 3.3V 0 0.1ns 0.1ns 2ns 4ns)`
    * Transient simulation: `.tran 1n 20n`
    * Finally, for some weird reasons, ngspice throws an **unknown subckt** error with transistor instance names starting with `X`. So, modify the instance names to M0 and M1

    | **SPICE deck to run trans sim using the extracted netlist**<br>  ![D14.3_Inverter_Extracted_SPICE_netlist_trans_sim](/docs/images/D14.3_Inverter_Extracted_SPICE_netlist_trans_sim.png) |
    |:---|
    | **Trans sim results with Waveforms**<br>  ![D14.3_Inverter_Extracted_SPICE_trans_sim_waveform](/docs/images/D14.3_Inverter_Extracted_SPICE_trans_sim_waveform.png) |

### Lab: Introduction to DRC using Magic tool
  * Obtain the tutorial files for DRC labs from the following link:
    ```
    wget http://opencircuitdesign.com/open_pdks/archive/drc_tests.tgz
    tar xfz drc_tests.tgz
    ```
  * The Design Rules for Skywater 130nm technology can be found here: [**https://skywater-pdk.readthedocs.io/en/main/rules.html**](https://skywater-pdk.readthedocs.io/en/main/rules.html)

#### <ins>Lab 1: met3.mag</ins>
  * To open Magic using OpenGL or Cairo graphical interfaces, invoke magic using the `-d` option:
    * For OpenGL: `magic -d XR &`
    * For Cairo: `magic -d OGL &`
  
  * Open the `met3.mag` tutorial file in Magic either via the command line or from the GUI via **File -> Open...**
  * To view the DRC errors/ violations flagged for an area:
    * Position the cursor box around the required area by using the left and right mouse buttons.
    * Commands to the **tkcon console** can be passed without leaving the main layout GUI window by pressing the `:` key followed by entering the required command
    * For example, to view the DRC error for the m3.2 section, position the cursor box around it and type: `:drc why`
    * The **console** window will now display the DRC rule that is being violated
  
    | **Rule M3.2: Spacing of metal 3 to metal 3 - 0.300µm**<br>  ![D14.3_sky130_DRC_Lab_M3.2](/docs/images/D14.3_sky130_DRC_Lab_M3.2.png) |
    |:---|
<br>

  * Vias are a kind of derived layer in Magic, in which the drawn via represents an area that is filled with contact cuts. The contact cuts (which is essentially the Mask layer for VIA2 in the output GDS) don't actually exist in the drawn layout view. They are created from rules in the CIF output section of the tech file that tell Magic how to draw contact cuts in the drawn contact area.
    * Draw an area of M3 contact by enclosing some area in the cursor box using the left and right mouse buttons, hover the mouse pointer over the `m3contact` icon in the sidebar and click the middle mouse-button (or, press the `p` key)
    * Otherwise, use the `paint m3contact` command after enclosing the required area in the cursor box.
    * To view the M3 contact cuts, from the layout window, type `:cif see VIA2`
      This view in the layout window is called a **feedback entry** and can be dismissed using the `feedback clear` command.
    * As a sidenote, rules like these will always be correct by design and can be confirmed by measuring the distance from the contact cut to the edge of M3 contact by drawing a cursor box.
      *  To align the cursor box to the edge of the via shown in the CIF view, use the `snap int` command.
  
    | **Rule M3.4: Via2 must be enclosed by Met3 by at least 0.065µm**<br>  ![D14.3_sky130_DRC_Lab_M3.4_M3ContactCut_VIA2](/docs/images/D14.3_sky130_DRC_Lab_M3.4_M3ContactCut_VIA2.png) |
    |:---|

#### <ins>Lab 2: poly.mag - Exercise to fix poly.9 error in Sky130 tech-file</ins>
  * [https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#poly](https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#poly)
  * **poly.9**: Poly resistor spacing to poly or spacing (no overlap) to diff/tap 0.480 µm
  * This exercise deals with fixing an incomplete DRC rule in the `sky130A.tech` file
  * The section shown below is violating the poly.9 DRC rule, but it is not reported as a DRC violation due to the rule being incompletely implemented in the `sky130A.tech` file

    | **Rule poly.9: Poly resistor spacing to poly or spacing (no overlap) to diff/tap 0.480µm**<br>  ![D14.3_sky130_DRC_Lab_poly.9_Missing_DRC_rule_1](/docs/images/D14.3_sky130_DRC_Lab_poly.9_Missing_DRC_rule_1.png) |
    |:---|
  * In the `sky130A.tech` file:
    * The rules for poly resistor spacing to alldiffusion and nsd (nsubstratediff or N-tap) are implemented. So we need to implement the missing poly resistor spacing to poly rules.

    | **sky130A.tech** | |
    |:---|:---|
    | ![D14.3_sky130_DRC_Lab_poly.9_Missing_DRC_rule_2](/docs/images/D14.3_sky130_DRC_Lab_poly.9_Missing_DRC_rule_2.png) | ![D14.3_sky130_DRC_Lab_poly.9_Missing_DRC_rule_3](/docs/images/D14.3_sky130_DRC_Lab_poly.9_Missing_DRC_rule_3.png) |

  * 
    * If we look at the aliases, we can see that there is a definition for allpolyres as follows:
      `allpolyres       mrp1,xhrpoly,uhrpoly,rmp`

    * So we can implement the missing poly.9 spacing rules by adding the following lines to the tech file at the appropriate sections:
      ```
      spacing npres allpolynonres 480 touching_illegal \
              "poly.resistor spacing to poly < %d (poly.9)"
      
      spacing xhrpoly,uhrpoly,xpc allpolynonres 480 touching_illegal \
            "xhrpoly/uhrpoly resistor spacing to poly < %d (poly.9)"
      ```
  * Now, from the console window, reload the tech file: `tech load sky130A.tech`
  * The DRC checks needs to be run again, by executing: `drc check`

    | **Magic DRC engine now shows the poly resistor to poly spacing error**<br>  ![D14.3_sky130_DRC_Lab_poly.9_Missing_DRC_rule_4](/docs/images/D14.3_sky130_DRC_Lab_poly.9_Missing_DRC_rule_4.png) |
    |:---|

#### <ins>Lab 3: poly.mag - Exercise to implement poly resistor spacing to diff and tap</ins>
  * The additions we made for the poly.9 DRC rule are still not complete. We can check this by creating two copies of the three resistors (`npolyres, ppolyres and xhrpolyres`)
  * We will add `ndiffussion, pdiffusion, nsubstratendiff & psubstratepdiff` around the two copies of the three poly resistors as shown.
  * Also draw an `nwell` under the pdiffusion and N-tap (nsubstratendiff) to avoid the flagging of any diffusion-related DRC errors since we are not interested in them for this exercise.

  * From the layout, we can see that all the poly resistors except the `npolyres` are showing the DRC spacing violations. The `npolyres` is only flagging the DRC spacing violation to the N-tap.
    This can be fixed by changing the npres spacing rule to consider all diffusion instead of just `nsd`
    
  | Before | After |
  |:---|:---|
  |  <pre>spacing npres *nsd 480 touching_illegal \ <br>   "poly.resistor spacing to N-tap < %d (poly.9)"</pre> | <pre>spacing npres alldiff 480 touching_illegal \ <br>   "poly.resistor spacing to N-tap < %d (poly.9)"</pre> |
  | ![D14.3_sky130_DRC_Lab_poly.9_Diffusion_1](/docs/images/D14.3_sky130_DRC_Lab_poly.9_Diffusion_1.png) | ![D14.3_sky130_DRC_Lab_poly.9_Diffusion_2](/docs/images/D14.3_sky130_DRC_Lab_poly.9_Diffusion_2.png) |

#### <ins>Lab 4: nwell.mag - Challenge exercise to describe DRC error as geometrical construct</ins>
  * [https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#nwell](https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#nwell)
  * **nwell.5**: Deep nwell must be enclosed by nwell by atleast… 0.400µm.  
     Exempted inside UHVI or areaid.lw Nwells can merge over deep nwell if spacing too small (as in rule nwell.2)
  * **nwell.6**: Min enclosure of nwell hole by deep nwell outside UHVI 1.030µm
  * Relevant DRC rules in `sky130A.tech` file

  | ![D14.3_sky130_DRC_Lab_nwell.5_0](/docs/images/D14.3_sky130_DRC_Lab_nwell.5_0.png) | ![D14.3_sky130_DRC_Lab_nwell.5_1](/docs/images/D14.3_sky130_DRC_Lab_nwell.5_1.png) |
  |:---|:---|
  
  * Everything in the cifoutput DRC style is implemented as a templayer and not an actual layer.
  * `templayer nwell_missing dnwell`:
    * Depends on another templayer, **dnwell_shrink**
    * **dnwell_shrink** is defined above it.
      ```
      templayer dnwell_shrink dnwell
      shrink 1030
      ```
      * It takes the deep nwell and shrinks it by 1030nm (or 1.03um), which is the mininum required distance the nwell must overlap the deep nwell on the inside.
      What this represents is the largest open area inside the area of the drawn deep nwell.
  * Coming back to the **nwell_missing** templayer, it starts with the **dnwell** and grows it by 400nm (or 0.4um, `grow 400`), which is the minimum required distance the deep nwell must be enclosed by the nwell.
    This will give the smallest nwell area needed to cover the deep nwell.
  * `and-not dnwell_shrink`: Does nwell_missing AND-NOT dnwell_shrink, which generates a ring-shaped area that requires the least nwell to satisfy both the nwell to deep nwell inside overlap and the outside surround of deep nwell by nwell.
    * i.e., if any of this area does not contain nwell, it will be flagged as an error as either of the two rules is being violated.
  * `and-not nwell`: Results in anything leftover is passed back to the cifmaxwidth rule in the DNWELL

  * Put the cursor box around the nwell.6 drawing and execute the following commands step by step reviewing the DRC errors flagged at each step:
    ```
    cif ostyle drc   --> to see the layers of the cifoutput style drc
    cif see dnwell_shrink
    feed clear
    cif see nwell_missing
    ```

  | **nwell.6 drawing <br>**  ![D14.3_sky130_DRC_Lab_nwell.5_2](/docs/images/D14.3_sky130_DRC_Lab_nwell.5_2.png) | **cif ostyle drc <br>cif see dnwell_shrink** <br>  ![D14.3_sky130_DRC_Lab_nwell.5_3](/docs/images/D14.3_sky130_DRC_Lab_nwell.5_3.png) |
  |:---|:---|
  | **feed clear <br>cif see nwell_missing** <br>  ![D14.3_sky130_DRC_Lab_nwell.5_4](/docs/images/D14.3_sky130_DRC_Lab_nwell.5_4.png) | |
  
  * **NOTE**:
    * Any edge based rules could be implemented using cifoutput operators but generating these layers is highly compute-intensive.
    * Hence to avoid Magic getting sluggish by these geometrically defined rules it is better to use the simple DRC edge-based rules whenever possible and put the cifoutput rules into a separate style variant, that can be run on-demand and can be prevented from running during interactive layout.
    * In `sky130A.tech` file, there are two variants of DRC rule styles:
      * `drc fast`: intended for working on backend metal layers and large synthesized digital designs without checking all the layers below metal
      * `drc full`: will check everything. As long as the layout is relatively small, it can be enabled during interactive layout without everything turning sluggish.
      * Switch between the two using: `drc style drc(fast)`, `drc style drc(full)`

#### <ins>Lab 5: nwell.mag - Challenge  to find missing or incorrect rules and fix them</ins>
  * **nwell.4**: All n-wells will contain metal-contacted tap (rule checks only for licon on tap) . Rule exempted from high voltage cells inside UHVI.
  * Every nwell must have an n-tap layer contact inside it, which is called `nsubstratencontact` or `nsc`.
  * Since there is no distance/ spacing associated with this rule, it is not possible to write this as an edge-based DRC rule. But it can be written as a cifoutput rule.
    * To the NWELL rules section, add the following cifoutput rule:
      ```
       variant (full)   # -> Run this rule only for drc(fast) style
       cifmaxwidth nwell_untapped 0 bend_illegal \
               "N-well missing tap (nwell.4))"
       variant *        # -> Run the rules below for all styles, unless explicitly specified
      ```
    * Now, in the style drc section, define the following templayers:
      ```
      templayer nwell_tapped           # Create a templayer nwell_tapped
      bloat-all nsc nwell              # that takes all nsc layers and expand it to fill any nwell underneath it
      templayer nwell_untapped nwell   # Now, create a second templayer nwell_untapped that starts with allnwell geometries
      and-not nwell_tapped             # and subtract all nwell_tapped geometries
      ```
  | **untapped nwell being flagged for DRC violn. <br>**  ![D14.3_sky130_DRC_Lab_nwell.4_1](/docs/images/D14.3_sky130_DRC_Lab_nwell.4_1.png) | **tapped nwell showing no DRC violn.** <br>  ![D14.3_sky130_DRC_Lab_nwell.4_2](/docs/images/D14.3_sky130_DRC_Lab_nwell.4_2.png) |
  |:---|:---|

_________________________________________________________________________________________________________  
  
## Day 14.4: Pre-layout timing analysis and importance of good clock tree

### Lab: Steps to convert grid info to track info
  * **Objective**: Extract LEF file for the sky130_inv.mag and plug this custom std cell into OpenLANE flow
  
  * From PnR point of view, we only need the following information: PnR boundary of the standard cell, the power and ground rails, and finally the input & output ports.
    LEF file has all these information.
    
  * Few guidelines to be followed by the layout:
    * Input and Output ports must lie on the intersection of the vertical and horizontal tracks
    * Width of the standard cell must be an odd multiple of the track pitch
    * Height of the standard cell must be a multiple of the track vertical pitch
      * Tracks:
        * Track information is used during the routing stage as the routes can go only over the tracks.
        * Track information for the locali and the differet metal layers is specified in the `pdks/sky130A/libs.tech/openlane/sky130_fd_sc_hd/tracks.info` file.
  
  * Before extracting the LEF file, we need to define the ports and set the correct class and use attributes to each port.
    1) For each layer (to be turned into port), make a box on that particular layer and input a label name along with a sticky label of the layer name with which the port needs to be associated.
       Ensure the Port enable checkbox is checked and default checkbox is unchecked.
       
    2) Next, the **port class** and **port use** attributes need to be set.
       These attributes are used by the LEF and DEF format read and write routines, and match the LEF/DEF CLASS and USE properties for macro cell pins.
       * Valid port classes: `default, input, output, tristate, bidirectional, inout, feedthrough, and feedthru`.
       * Valid port uses: `default, analog, signal, digital, power, ground, and clock`.  
       These attributes can be set in the **console** window after selecting each port in the layout window.
       ```
       # For ports A, Y:
       port class input
       port use signal

       # For VPWR, VGND
       port class inout
       port use power
       ```

  * Now the LEF file can be written from the **console window** by the following command: `lef write`

### Lab: Adding the extracted LEF file into OpenLANE flow for picorv32a design
  * Copy the LEF file into the `openlane/designs/picorv32a/src` directory.
  * Now we need to have the cell characterized and added to the technology library.
    * This particular cell - **sky130_vsdinv** - it has already been characterized and added to the `sky130_fd_sc_hd__*.lib` files.
    * Copy the downloaded timing lib files with the characterization info for **sky130_vsdinv** into the `openlane/designs/picorv32a/src` directory.
  * Modify the `config.tcl` with the following:
    * Set the PDK configuration variables to use the newly copied timing lib files for synthesis and sta.
    * Add the LEF file of the inverter macro using the EXTRA_LEF flow configuration variable.
      ```
      set ::env(LIB_SYNTH) $::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__typical.lib
      set ::env(LIB_SLOWEST) $::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__slow.lib
      set ::env(LIB_FASTEST) $::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__fast.lib
      set ::env(LIB_TYPICAL) $::env(OPENLANE_ROOT)/designs/picorv32a/src/sky130_fd_sc_hd__typical.lib
      
      set ::env(EXTRA_LEFS) [glob $::env(OPENLANE_ROOT)/designs/$::env(DESIGN_NAME)/src/*.lef]
      ```
  * Now invoke OpenLANE in interactive mode and after the `prep -design picorv32a` command is executed, run the following two commands to merge the custom cell(s)' LEF file(s) to the existing processed LEF files.
    ```
    lefs [glob $::env(DESIGN_DIR)/src/*.lef]
    add_lefs -src $lefs
    ```

  | * Synthesis result shows the sky130_vsdinv being instanced 1537 times. <br>  ![D14.4_Add_sky130_vsdinv_to_flow_run_synthesis](/docs/images/D14.4_Add_sky130_vsdinv_to_flow_run_synthesis.png) |
  |:---|
  | **Layout showing sky130_vsdinv after placement stage** <br>  ![D14.4_picorv32a_Layout_after_Placement_showing_sky130_vsdinv](/docs/images/D14.4_picorv32a_Layout_after_Placement_showing_sky130_vsdinv.png) |

  * **Note**:
    * The `run_floorplan` command gave an error saying `Cannot find any macros in the design` after including the sky130_vsdinv cell.
    * The error message was popping up when the function `basic_macro_placement` was being called by `run_floorplan` which inturn was calling `openroad ./scripts/openroad/or_basic_mpl.tcl`.
    * Within `or_basic_mpl.tcl`, the error was being spewed out by `macro_placement` command and we don't have anymore info on why this error was being shown.
    * Hence, until things are cleared, `run_floorplan` is run manually instead with the following sub-routine calls:
      ```
      run_synthesis

      # run_floorplan
      init_floorplan
      place_io
      apply_def_template    # harmless I believe
      global_placement_or
      tap_decap_or
      scrot_klayout -layout $::env(CURRENT_DEF) # again, harmless

      # run_placement
      global_placement_or
      run_openPhySyn    # Gets skipped, so just keep it here
      run_resizer_design
      detailed_placement_or
      ```

### Introduction to Delay Tables
  * Gate/ Cell delay is a function of the input transition (slew) time and the output load capacitance, Cload
  * Cell delay is calculated using Non-Linear Delay Models (NLDM). NLDM is highly accurate as it is derived from SPICE characterizations.
    The delay is a function of the input transition time (i.e. slew) of the cell, the wire capacitance and the pin capacitance of the driven cells.
    * A slow input transition time will slow the rate at which the cell’s transistors can change state from logic 1 to logic 0 (or logic 0 to logic 1) thereby increasing the delay of the logic gate.
    * A large output load Cload (Cnet + Cpin) also has a similar effect wherein the delay increases with the output load. 
  * Similar to the NLDM table for cell delay, there is an corresponding table in the library to calculate output transition as well.
  * Table models are usually two-dimensional to allow lookups based on the input slew and the output load (Cload).

  | * Delay table for sky130_vsdinv @tt corner <br>  ![D14.4_NLDM_Delay_Table](/docs/images/D14.4_NLDM_Delay_Table.png) |
  |:---|

  *
    * `index_1`: Input slew
    * `index_2`: Output capacitance
    * `values`: Cell delay values
  * **Case 1:** Input transition and output load values match with table index values
    * Corresponding delay value is directly picked up from the delay “values” table.
  * **Case 2:** Output load values doesn't match with table index values
    * Interpolation is performed using the nearest available table indices to calculate the approximate delay value.
  
  | Example Interpolation algorithm in NLDM Delay table <br> _Ref: STA for Nanometer Designs - J. Bhasker, Rakesh Chadha_ <br> <br>  ![D14.4_NLDM_Interpolation](/docs/images/D14.4_NLDM_Interpolation.png) |
  |:---|

### Lab: Configure synthesis settings to fix the timing violations and improve slack
  * The synthesis results with the present settings has a huge wns slack of -26.53ns and tns of -3232.44. To obtain timing closure in post-route STA, this negative slack needs to be reduced in synthesis.
     
  * Read back the Synthesis configuration variables that could be potentitally wrecking the timing:
    * `echo $::env(SYNTH_STRATEGY)` :== `AREA 0`
    * `echo $::env(SYNTH_BUFFERING)` :== `1`
    * `echo $::env(SYNTH_SIZING)` :== `0`
    * `echo $::env(SYNTH_DRIVING_CELL)` :== `sky130_fd_sc_hd__inv_8` 
  * Change the SYNTH_STRATEGY to optimize delay and enable cell sizing instead of buffering.
    * `set ::env(SYNTH_STRATEGY) "DELAY 1"`
    * `set ::env(SYNTH_SIZING) 1`
  * **Comparison of synthesis results with the modified settings**
    | **Before** | **After** |
    |---|---|
    | <pre>Chip area for module '\picorv32a': 147950.646400 <br> tns -3232.44 <br> wns -26.53 </pre> | <pre>Chip area for module '\picorv32a': 209179.369600 <br> tns -266.36 <br> wns -2.95 </pre>

    The wns and tns values look much better and easier to fix later on.

### Timing analysis with ideal clocks using openSTA

**Note**: We have already gone through STA basics previously. We will capture the important essentials once again here.  

#### Setup timing analysis and introduction to flip-flop setup time
<!---
| _**Ref: Digital Integrated Circuits: A Design Perspective by J. Rabaey et al.**_ | |
|:---|:---|
| **Single-Cycle Path Timing (Ideal Clock)** <br>  ![D14.4_Synchronous_Timing_Basics_Ideal_Clocks](/docs/images/D14.4_Synchronous_Timing_Basics_Ideal_Clocks.png) | **Origin of Flip-flop setup time** <br>  <br>  ![D14.4_Positive-Edge_Triggered_MS_DFF](/docs/images/D14.4_Positive-Edge_Triggered_MS_DFF.png) |
| | **Example DFF Implementation using TG-Muxes** <br>  ![D14.4_Positive-Edge_Triggered_MS_DFF_using_TG-based_Muxes](/docs/images/D14.4_Positive-Edge_Triggered_MS_DFF_using_TG-based_Muxes.png) |
--->
  * Considering Ideal clocks, the condition to meet the setup timing for a single-cycle path (using same clock at launch and capture flops) is:
    T_clk > tc_q + t_comb + t_setup
    where,
      * T_clk : Ideal Clock Period
      * tc_q  : Clock-to-Q Delay of the FF
      * t_comb : Total Combination Delay (including the wire/ net delay) from the output pin of the launch flop till the input pin of the capture flop. 
      * t_setup : Setup time requirement of the FF

  * **Origin of FF setup-time**
    * The minimum time required for the relevant internal nodes of the Flip-Flop circuit to capture the value at the "D" input pin, before the arrival of the clock triggering edge.
    * The exact values depend on the FF implementation style. If we consider a Mux/ Latch-based implementation of an edge-triggerted FF (where a negative latch is followed by a positive latch), the setup time is the time required for the 'D' input to reach the internal node, QM (i.e., the delay of the first Mux/ Latch)

    | ![D14.4_Positive-Edge_Triggered_MS-DFF](/docs/images/D14.4_Positive-Edge_Triggered_MS-DFF.png) |
    |:---|

  * **Clock Jitter**
    * Clock jitter refers to the temporal variation of the clock period at a given point — that is, the clock period can reduce or expand on a cycle-by-cycle basis.
    * It is strictly a temporal uncertainty measure and is often specified at a given point on the chip.
    * Jitter can be measured and cited in one of many ways.
      * Cycle-to-cycle jitter refers to time varying deviation of a single clock period and for a given spatial location i is given as:
        `Tjitter,i(n) = [(Ti, n+1 - Ti,n) - TCLK]`, where
        * Ti,n is the clock period for period n
        * Ti, n+1 is clock period for period n+1
        * and TCLK is the nominal clock period

  * **Setup Uncertainty**
    * Clock uncertainty specifies a window within which a clock edge can occur.
    * With respect to setup timing, we specify a new parameter called _**setup uncertainty**_ to model several factors like clock jitter, additional margins and clock skew (at pre-cts stage).

    | ![D14.4_Setup_Uncertainty](/docs/images/D14.4_Setup_Uncertainty.png) |
    |:---|

#### Lab: Configure OpenSTA for Post-synth timing analysis
  * During the PnR flow, it is very much possible that some timing violations may get fixed, some violations will get better, some worse and new violations could also be introduced.
  * In any PnR flow, the separate timing tool (like PrimeTime) is usually invoked outside of the automated flow for performing the timing analysis and timing ECO generation.
  * In the OpenLANE flow, we use OpenSTA tool for Post-synthesis timing analysis.
  * **OpenSTA config file: pre_sta.conf**:
    ```
    set_cmd_units -time ns -capacitance fF -current uA -voltage V -resistance kOhm -distance um
    
    read_liberty -max ./designs/picorv32a/src/sky130_fd_sc_hd__slow.lib
    read_liberty -min ./designs/picorv32a/src/sky130_fd_sc_hd__fast.lib
    
    #read_verilog ./designs/picorv32a/src/picorv32a.v
    read_verilog ./designs/picorv32a/runs/latest_21-03/results/synthesis/picorv32a.synthesis.v
    
    link_design picorv32a
    read_sdc ./designs/picorv32a/src/my_base.sdc
    
    check_setup -verbose
    
    report_checks -path_delay min_max -fields {nets cap slew trans input_pins}
    report_tns
    report_wns
    ```
    
  * **SDC file: my_base.sdc**:
    ```
    set ::env(CLOCK_PORT) clk
    set ::env(CLOCK_PERIOD) 12.000
    set ::env(SYNTH_DRIVING_CELL) sky130_fd_sc_hd__inv_8
    set ::env(SYNTH_DRIVING_CELL_PIN) Y
    set ::env(SYNTH_CAP_LOAD) 17.65
    create_clock [get_ports $::env(CLOCK_PORT)]  -name $::env(CLOCK_PORT)  -period $::env(CLOCK_PERIOD)
    set IO_PCT  0.2
    set input_delay_value [expr $::env(CLOCK_PERIOD) * $IO_PCT]
    set output_delay_value [expr $::env(CLOCK_PERIOD) * $IO_PCT]
    puts "\[INFO\]: Setting output delay to: $output_delay_value"
    puts "\[INFO\]: Setting input delay to: $input_delay_value"
    
    
    set clk_indx [lsearch [all_inputs] [get_port $::env(CLOCK_PORT)]]
    #set rst_indx [lsearch [all_inputs] [get_port resetn]]
    set all_inputs_wo_clk [lreplace [all_inputs] $clk_indx $clk_indx]
    #set all_inputs_wo_clk_rst [lreplace $all_inputs_wo_clk $rst_indx $rst_indx]
    set all_inputs_wo_clk_rst $all_inputs_wo_clk
    
    
    # correct resetn
    set_input_delay $input_delay_value  -clock [get_clocks $::env(CLOCK_PORT)] $all_inputs_wo_clk_rst
    #set_input_delay 0.0 -clock [get_clocks $::env(CLOCK_PORT)] {resetn}
    set_output_delay $output_delay_value  -clock [get_clocks $::env(CLOCK_PORT)] [all_outputs]
    
    # TODO set this as parameter
    set_driving_cell -lib_cell $::env(SYNTH_DRIVING_CELL) -pin $::env(SYNTH_DRIVING_CELL_PIN) [all_inputs]
    set cap_load [expr $::env(SYNTH_CAP_LOAD) / 1000.0]
    puts "\[INFO\]: Setting load to: $cap_load"
    set_load  $cap_load [all_outputs]
    ```

  * Invoke OpenSTA from another terminal and provide above config file as the input:
    ```sta pre_sta.conf```

#### Lab: Optimize Synthesis to reduce setup violations
  * In addition to the synthesis configuration variables that we have seen before, there are a few more that we can use to optimize synthesis to improve setup slack.
  * If there are setup timing violations (and possible slew & max cap violations) from nets with high fanout, we can limit the fanout to improve hte delay using:  
    ```
    set ::env(SYNTH_MAX_FANOUT) 4
    ```
  * To view the nets driven by the output pin of a cell, the following command can be used:  
    ```
    report_net -connections <net_name>
    ```

#### Lab: Steps to do basic Timing ECO
  * From analysing the setup violations in OpenSTA, we will be able to infer the possible reasons for the violations
  * One common reason could a large output slew for a net due to large capacitance load/ fanout which the synthesis tool could not optimize further.
    In this case, we can **upsize** the cell (i.e., replace the cell instance with a higher drive strength version of it) to reduce the delay using the `replace_cell` command.
    ```
    Syntax : replace_cell replace_cell instance lib_cell
    Example: replace_cell _44195_ sky130_fd_sc_hd__inv_4
             where, _44195_ is the instance name of the cell to be replaced
                    sky130_fd_sc_hd__inv_4 is the upsized std cell version
    ```
    * To check if the violation has been resolved:
      ```
      report_checks -from <instance or pin> -to <instance or pin> -through <instance> -path_delay max
      Example: report_checks -from <instance or pin> -to <instance or pin> -through _44195_ -path_delay min_max
      ```
  * The above step of upsizing the cell to improve timing would obviously change the netlist, which needs to be updated in the netlist file for it to be captured in the OpenLANE flow.
    To write the updated netlist:  
    ```
    write_verilog $OPENLANE_HOME/designs/picorv32a/runs/latest_21-03/results/synthesis/picorv32a.synthesis.v
    ```
  * **Note:**
    * Fixing timing violations by ECOs is an iterative cyclical process.
    * The STA engineer(s) will do the necessary modifications like upsizing, replacing cell with a different Vt cell, inserting buffers etc. to fix a violation and provide the ECO to the PnR engineer(s).
    * The PnR engineer(s) will then take this ECO and do the PnR and perform the post-route timing analysis with the back-annotated values that capture the parasitics as well.
    * This may fix or improve the existing the timing violation, while there is a chance that it may introduce new violations.
    * Now the STA engineer(s) will take the new data and perform STA analysis again and provide new timing ECOs for the new violations.
    * This "spinning" process goes on till all voilations are rectified.

### Clock Tree Synthesis using TritonCTS and Signal Integrity
Clock Tree Synthesis is the process of connecting the clocks to the clock pins of all sequential elements in the design by using inverters/ buffers in order to balance the skew and to minimize the insertion delay.

| **Ideal Clock Tree before CTS** <br>  ![D14.4_Ideal_clock_tree_before_CTS](/docs/images/D14.4_Ideal_clock_tree_before_CTS.png) | **Real Clock tree (H-tree) after CTS** <br>  ![D14.4_Real_clock_tree_(H-tree)_after_CTS](/docs/images/D14.4_Real_clock_tree_(H-tree)_after_CTS.png)
|---|---|

**Image courtesy:** [_https://www.physicaldesign4u.com/2020/02/clock-tree-synthesis.html_](https://www.physicaldesign4u.com/2020/02/clock-tree-synthesis.html)

  * **QoR parameters for a Clock Tree**:
    1) Clock Insertion Delay/ Latency: Refers to the arrival time of the clock signal at the sink pin with respect to the clock source.
    2) Clock Skew: Refers to the difference in the clock arrival time between two sinks. It can further be sub-divided into Local Clock Skew and Global Clock Skew:
       * Local Clock Skew – The difference in the arrival times of the clock signal reaching any pair of registers that have a valid timing path between them.
       * Global Clock Skew – The difference in the arrival times of the clock signal reaching any pair of registers that may or may not have a valid timing path between them.
    3) Clock Slew (Transition Time): Clock slew needs to be as small as possible to provide a sharp timing edge by reducing the timing uncertainty. However this will have th implication of higher area and power if we use larger clock tree buffers.
    4) Duty Cycle: Unequal rise and fall times of the clock buffers is the primary cause of duty cycle distortion in a clock tree. Usually inverters are used instead of buffers to reduce DCD in a clock tree.
    5) Pulse Width: Usually SRAMs, flip-flops and latches will have minimum pulse width requirements to meet their internal timing. There will be minimum pulse width requirements for both the high and low times of a clock period. 

#### Clock tree routing and buffering using H-Tree algorithm
  * **H-Tree algorithm**
    * This is a clock tree routing algorithm that tries to minimize the skew by minimizing the routing length.
    * The clock routing taked place in the shape of the capital letter **"H"**
    * <ins>Algorithm Steps:</ins>
      1) Find out all the flops being clocked by the clock signal under consideration.
      2) Find out the center of all the flops.
      3) Trace clock port to center point.
      4) Now divide the core into two parts, trace both the parts and reach to each center.
      5) Then from this center, again divide the area into two and again trace till center at both the end.
      6) Repeat this algorithm till the time we reach the flop clock pin.
    * This is demonstrated in the following GIF file from [wikipedia page](https://en.wikipedia.org/wiki/H_tree):

    | ![D14.4_H_tree_Algorithm](/docs/images/D14.4_H_tree_Algorithm.gif) |
    |:---|
  * **Clock buffering**
    * To ensure the clock signal reaching each sink pin is having the required target slew/ transition time, we need to add clock repeaters or clock buffers at multiple points of the distribution network, ensuring the RC wire load is split across multiple levels of buffers.
    * To reduce Duty Cycle Distortion (DCD), clock buffers need to have equal rise and fall times. Usually it is very difficult to design buffers with equal rise and fall times and in a long clock tree with multiple levels of buffering, this can often lead to DCD. Hence instead of clock buffers, clock inverters are used in clock trees to reduce the introduction of DCD.

#### Clock Signal Integrity: Crosstalk and Clock Net Shielding
  * **Crosstalk Glitch**
    * If a high slew net is somehow routed near to the clock net, a transition on this agressor net can cause a glitch on the the clock net while the clock net is at a logic LOW or HIGH level.
    * This happens due to the capacitive coupling between the nets and can cause the signal level on the clock net to temporarily go above the VIH or VIL level resulting in a spurious unwanted high/ low pulse on this clock net.
    * Depending on the height (and width) of the glitch, it could be a safe or unsafe one.
      * If the glitch height within the noise margin, it can be considered a safe glitch.
      * If the glitch height is above the noise margin limits, it is a potentially unsafe glitch.
      * If the glitch heigh is within the noise margin limits, it is an unpredictable case as the output transition may be random and could cause some flop to go metastable.  
    * A glitch on the clock signal can have serious ramifications on the operation of the whole system and it can result in timing failure, writing of an invalid data to some flops or cause it to go metastable, eventually even resulting in system failure.
    * Theoretically, the reverse could also happen wherein the clock net can act as an aggressor since the edge rate of clock nets are usually very high.

  * **Crosstalk Delta Delay**
    * Crosstalk delay occurs when both aggressor and victim nets switch together.
    * There can be two cases:
      1) When both the aggressor and victim nets transition in the same direction
         * The transition of the victim net becomes faster, being aided by the crosstalk, reducing its rise/ fall time and thus the cell delay.
      2) When the aggressor and victim nets transition in opposite direction
         * Transition of the victim net gets becomes delayed due to the crosstalk trying to oppose the transition on the victim net, causing a voltage bump on its rising or falling edge. This increases the transition time and hence the cell delay.
    * If the victim net is a clock net, crosstalk can cause a previously skew-balanced clock tree to become unbalanced.
      Since the clock skew is affected, it may result in some paths getting faster or slower resulting in hold or setup violations respectively.

  * **Clock Net Shielding**
    * The critical clock nets are shielded to prevent any unwanted crosstalk on to the clock nets.
    * Shielding nets are placed on either sides of the clock net along its entire length, to decouple the aggressor net.
      The shielding nets are connected to either VDD or GND (either both of them to VDD (or GND), or one of them to VDD & the other to GND).
      (Basically the shielding nets need to be connected to a non-transitioning net, low impedance upon which an aggressor has no effect).

#### Lab: Steps to run CTS using TritonCTS
  * Command to run cts: `run_cts`
  * After CTS, a new netlist **<design_name>.synthesis_cts.v** will be created in the `runs/<tag>/results/synthesis/` folder that includes the information on the generated clock clock tree and the newly instanced clock buffers.

  | ![D14.4_New_netlist_after_CTS](/docs/images/D14.4_New_netlist_after_CTS.png) |
  |---|

#### Lab: Steps to verify CTS runs
  * CTS configuration variables to verify:

  | Configuration Variable | Details |
  |:---|:---|
  | `CTS_TARGET_SKEW` | The target clock skew in picoseconds, usually 10% of the clock period. |
  | `CTS_ROOT_BUFFER` | The name of cell inserted at the root of the clock tree (`sky130_fd_sc_hd__clkbuf_16` in our case) |
  | `CTS_TOLERANCE` | An integer value that represents a tradeoff of QoR and runtime. <br>  Higher values will produce smaller runtime but worse QoR. |
  | `LIB_CTS` | The liberty file used for CTS. By default, this is the `LIB_SYNTH_COMPLETE` minus the cells with drc errors. |
  | `CTS_MAX_CAP` | Defines the maximum capacitance for clock tree synthesis in the design in pF. |

### Timing Analysis with real clocks using OpenSTA

#### Setup timing analysis using real clocks

#### Hold timing analysis using real clocks

#### Lab: Steps to analyze timing with real clocks using OpenSTA (Post-CTS STA)
  * In OpenRoad, the timing analysis is performed by creating a db file using the LEF and DEF files of the design.
  * db creation is a one-time process (unless the def changes).
    To create the db, invoke OpenRoad from within the OpenLANE shell using `openroad`. And then from within the OpenRoad shell execute the following commands:  
    ```
    read_lef /openLANE_flow/designs/picorv32a/runs/latest_21-03/tmp/merged.lef
    read_def /openLANE_flow/designs/picorv32a/runs/latest_21-03/results/cts/picorv32a.cts.def
    write_db picorv32a_cts.db
    ```
  * Performing STA:
    ```
    read_db picorv32a_cts.db
    read_verilog /openLANE_flow/designs/picorv32a/runs/latest_21-03/results/synthesis/picorv32a.synthesis_cts.v
    read_liberty $::env(LIB_SYNTH_COMPLETE)
    read_liberty -max $::env(LIB_SLOWEST)
    read_liberty -min $::env(LIB_FASTEST)
    link_design picorv32a
    read_sdc /openLANE_flow/designs/picorv32a/src/my_base.sdc
    set_propagated_clock [all_clocks]
    report_checks -path_delay min_max -format full_clock_expanded -digits 4 -fields {net cap slew input_pins fanout}
    ```

#### Lab: Steps to observe impact of bigger CTS buffers on setup and hold timing
  * Modify the `CTS_CLK_BUFFER_LIST` variable to exclude the `sky130_fd_sc_hd__clkbuf_1` cell and re-run CTS again.
  * Be sure to modify the `CURRENT_DEF` variable to point to the DEF file after placement before triggering the CTS run.
    ```
    % echo $::env(CTS_CLK_BUFFER_LIST)
    sky130_fd_sc_hd__clkbuf_1 sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8

    set ::env(CTS_CLK_BUFFER_LIST) [lreplace $::env(CTS_CLK_BUFFER_LIST) 0 0]
    set ::env(CURRENT_DEF) /openLANE_flow/designs/picorv32a/runs/latest_21-03/results/placement/picorv32a.placement.def

    run_cts
    ```
  * We will be able to see the setup and hold slacks having some amount of improvement, but do note that this comes with a potentially large area & power penalty due to the larger clock buffers used.

<br>

_________________________________________________________________________________________________________  
[Prev: Day 13](Day_13.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 15](Day_15.md)  
