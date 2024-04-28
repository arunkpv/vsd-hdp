[Back to TOC](../README.md)  
[Prev: Day 22](Day_22.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 24](Day_24.md)  
_________________________________________________________________________________________________________  
  
# Day 23: Pre-layout timing analysis and importance of good clock tree

## Lab: Steps to convert grid info to track info
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

## Lab: Adding the extracted LEF file into OpenLANE flow for picorv32a design
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

  | * Synthesis result shows the sky130_vsdinv being instanced 1537 times. <br>  ![D23_Add_sky130_vsdinv_to_flow_run_synthesis](/docs/images/D23_Add_sky130_vsdinv_to_flow_run_synthesis.png) |
  |:---|
  | **Layout showing sky130_vsdinv after placement stage** <br>  ![D23_picorv32a_Layout_after_Placement_showing_sky130_vsdinv](/docs/images/D23_picorv32a_Layout_after_Placement_showing_sky130_vsdinv.png) |

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

## 23.1 Introduction to Delay Tables
  * Gate/ Cell delay is a function of the input transition (slew) time and the output load capacitance, Cload
  * Cell delay is calculated using Non-Linear Delay Models (NLDM). NLDM is highly accurate as it is derived from SPICE characterizations.
    The delay is a function of the input transition time (i.e. slew) of the cell, the wire capacitance and the pin capacitance of the driven cells.
    * A slow input transition time will slow the rate at which the cell’s transistors can change state from logic 1 to logic 0 (or logic 0 to logic 1) thereby increasing the delay of the logic gate.
    * A large output load Cload (Cnet + Cpin) also has a similar effect wherein the delay increases with the output load. 
  * Similar to the NLDM table for cell delay, there is an corresponding table in the library to calculate output transition as well.
  * Table models are usually two-dimensional to allow lookups based on the input slew and the output load (Cload).

  | * Delay table for sky130_vsdinv @tt corner <br>  ![D23_NLDM_Delay_Table](/docs/images/D23_NLDM_Delay_Table.png) |
  |:---|

  *
    * `index_1`: Input slew
    * `index_2`: Output capacitance
    * `values`: Cell delay values
  * **Case 1:** Input transition and output load values match with table index values
    * Corresponding delay value is directly picked up from the delay “values” table.
  * **Case 2:** Output load values doesn't match with table index values
    * Interpolation is performed using the nearest available table indices to calculate the approximate delay value.
  
  | Example Interpolation algorithm in NLDM Delay table <br> _Ref: STA for Nanometer Designs - J. Bhasker, Rakesh Chadha_ <br> <br>  ![D23_NLDM_Interpolation](/docs/images/D23_NLDM_Interpolation.png) |
  |:---|

## Lab: Configure synthesis settings to fix the timing violations and improve slack
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

## 23.2 Timing analysis with ideal clocks using openSTA

**Note**: We have already gone through STA basics previously. We will capture the important essentials once again here.  

### Setup timing analysis and introduction to flip-flop setup time
<!---
| _**Ref: Digital Integrated Circuits: A Design Perspective by J. Rabaey et al.**_ | |
|:---|:---|
| **Single-Cycle Path Timing (Ideal Clock)** <br>  ![D23_Synchronous_Timing_Basics_Ideal_Clocks](/docs/images/D23_Synchronous_Timing_Basics_Ideal_Clocks.png) | **Origin of Flip-flop setup time** <br>  <br>  ![D23_Positive-Edge_Triggered_MS_DFF](/docs/images/D23_Positive-Edge_Triggered_MS_DFF.png) |
| | **Example DFF Implementation using TG-Muxes** <br>  ![D23_Positive-Edge_Triggered_MS_DFF_using_TG-based_Muxes](/docs/images/D23_Positive-Edge_Triggered_MS_DFF_using_TG-based_Muxes.png) |
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

    | ![D23_Positive-Edge_Triggered_MS-DFF](/docs/images/D23_Positive-Edge_Triggered_MS-DFF.png) |
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

    | ![D23_Setup_Uncertainty](/docs/images/D23_Setup_Uncertainty.png) |
    |:---|

### Lab: Configure OpenSTA for Post-synth timing analysis
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

### Lab: Optimize Synthesis to reduce setup violations
  * In addition to the synthesis configuration variables that we have seen before, there are a few more that we can use to optimize synthesis to improve setup slack.
  * If there are setup timing violations (and possible slew & max cap violations) from nets with high fanout, we can limit the fanout to improve hte delay using:  
    ```
    set ::env(SYNTH_MAX_FANOUT) 4
    ```
  * To view the nets driven by the output pin of a cell, the following command can be used:  
    ```
    report_net -connections <net_name>
    ```

### Lab: Steps to do basic Timing ECO
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

## 23.3 Clock Tree Synthesis using TritonCTS and Signal Integrity
Clock Tree Synthesis is the process of connecting the clocks to the clock pins of all sequential elements in the design by using inverters/ buffers in order to balance the skew and to minimize the insertion delay.

| **Ideal Clock Tree before CTS** <br>  ![D23_Ideal_clock_tree_before_CTS](/docs/images/D23_Ideal_clock_tree_before_CTS.png) | **Real Clock tree (H-tree) after CTS** <br>  ![D23_Real_clock_tree_(H-tree)_after_CTS](/docs/images/D23_Real_clock_tree_(H-tree)_after_CTS.png)
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

### Clock tree routing and buffering using H-Tree algorithm
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

    | ![D23_H_tree_Algorithm](/docs/images/D23_H_tree_Algorithm.gif) |
    |:---|
  * **Clock buffering**
    * To ensure the clock signal reaching each sink pin is having the required target slew/ transition time, we need to add clock repeaters or clock buffers at multiple points of the distribution network, ensuring the RC wire load is split across multiple levels of buffers.
    * To reduce Duty Cycle Distortion (DCD), clock buffers need to have equal rise and fall times. Usually it is very difficult to design buffers with equal rise and fall times and in a long clock tree with multiple levels of buffering, this can often lead to DCD. Hence instead of clock buffers, clock inverters are used in clock trees to reduce the introduction of DCD.

### Clock Signal Integrity: Crosstalk and Clock Net Shielding
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

### Lab: Steps to run CTS using TritonCTS
  * Command to run cts: `run_cts`
  * After CTS, a new netlist **<design_name>.synthesis_cts.v** will be created in the `runs/<tag>/results/synthesis/` folder that includes the information on the generated clock clock tree and the newly instanced clock buffers.

  | ![D23_New_netlist_after_CTS](/docs/images/D23_New_netlist_after_CTS.png) |
  |---|

### Lab: Steps to verify CTS runs
  * CTS configuration variables to verify:

  | Configuration Variable | Details |
  |:---|:---|
  | `CTS_TARGET_SKEW` | The target clock skew in picoseconds, usually 10% of the clock period. |
  | `CTS_ROOT_BUFFER` | The name of cell inserted at the root of the clock tree (`sky130_fd_sc_hd__clkbuf_16` in our case) |
  | `CTS_TOLERANCE` | An integer value that represents a tradeoff of QoR and runtime. <br>  Higher values will produce smaller runtime but worse QoR. |
  | `LIB_CTS` | The liberty file used for CTS. By default, this is the `LIB_SYNTH_COMPLETE` minus the cells with drc errors. |
  | `CTS_MAX_CAP` | Defines the maximum capacitance for clock tree synthesis in the design in pF. |

## 23.4 Timing Analysis with real clocks using OpenSTA

### Setup timing analysis using real clocks

### Hold timing analysis using real clocks

### Lab: Steps to analyze timing with real clocks (Post-CTS STA) using OpenSTA
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
    ##read_liberty -max $::env(LIB_SLOWEST)
    ##read_liberty -min $::env(LIB_FASTEST)
    link_design picorv32a
    read_sdc /openLANE_flow/designs/picorv32a/src/my_base.sdc
    set_propagated_clock [all_clocks]
    report_checks -path_delay min_max -format full_clock_expanded -digits 4 -fields {net cap slew input_pins fanout}
    ```
  * Be sure to perform the timing analysis with the correct library file which was used for CTS (which was the LIB_SYNTH_COMPLETE or the LIB_TYPICAL in our case). 
  * **Note:** As of now, CTS does not support multi-corner optimization.

### Lab: Steps to observe impact of bigger CTS buffers on setup and hold timing
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

_________________________________________________________________________________________________________  
[Prev: Day 22](Day_22.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 24](Day_24.md)  
