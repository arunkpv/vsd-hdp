[Back to TOC](../README.md)  
[Prev: Day 21](Day_21.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 23](Day_23.md)  
_________________________________________________________________________________________________________  

# Day 22: Library Cell design using Magic and Characterization using Ngspice

## 22.1 16-Mask CMOS Process
### 22.1.1 Selecting a substrate with suitable properties
  - P-type substrate with high resistivity (5~50ohms)
  - Doping level ($10^{15} cm^{-3}$)
  - Orientation (100)
  - Substrate doping should be less than the well doping.

| ![1_Substrate](/docs/images/16Mask_CMOS_Process/1_Substrate.png) |
|:---|

### 22.1.2 Creating Active Region for the transistors
| ![2a_Creating_ActiveRegion](/docs/images/16Mask_CMOS_Process/2a_Creating_ActiveRegion.png) | ![2b_Creating_ActiveRegion](/docs/images/16Mask_CMOS_Process/2b_Creating_ActiveRegion.png) |
|:---|:---|
| ![2c_Creating_ActiveRegion](/docs/images/16Mask_CMOS_Process/2c_Creating_ActiveRegion.png) | ![2d_Creating_ActiveRegion](/docs/images/16Mask_CMOS_Process/2d_Creating_ActiveRegion.png) |
| ![2e_Creating_ActiveRegion](/docs/images/16Mask_CMOS_Process/2e_Creating_ActiveRegion.png) | ![2f_Creating_ActiveRegion](/docs/images/16Mask_CMOS_Process/2f_Creating_ActiveRegion.png) |
| ![2g_Creating_ActiveRegion](/docs/images/16Mask_CMOS_Process/2g_Creating_ActiveRegion.png) | ![2h_Creating_ActiveRegion](/docs/images/16Mask_CMOS_Process/2h_Creating_ActiveRegion.png) |

### 22.1.3 N-Well and P-Well Formation
| ![3a_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3a_NWell_PWell_Formation.png) | ![3b_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3b_NWell_PWell_Formation.png) |
|:---|:---|
| ![3c_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3c_NWell_PWell_Formation.png) | ![3d_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3d_NWell_PWell_Formation.png) |
| ![3e_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3e_NWell_PWell_Formation.png) | ![3f_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3f_NWell_PWell_Formation.png) |
| ![3g_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3g_NWell_PWell_Formation.png) | ![3h_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3h_NWell_PWell_Formation.png) |
| ![3i_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3i_NWell_PWell_Formation.png) | ![3j_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3j_NWell_PWell_Formation.png) |
| ![3k_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3k_NWell_PWell_Formation.png) | ![3l_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3l_NWell_PWell_Formation.png) |
| ![3m_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3m_NWell_PWell_Formation.png) | ![3n_NWell_PWell_Formation](/docs/images/16Mask_CMOS_Process/3n_NWell_PWell_Formation.png) |

### 22.1.4 Formation of Gate
| ![4a_Gate_Formation](/docs/images/16Mask_CMOS_Process/4a_Gate_Formation.png) | ![4b_Gate_Formation](/docs/images/16Mask_CMOS_Process/4b_Gate_Formation.png) |
|:---|:---|
| ![4c_Gate_Formation](/docs/images/16Mask_CMOS_Process/4c_Gate_Formation.png) | ![4d_Gate_Formation](/docs/images/16Mask_CMOS_Process/4d_Gate_Formation.png) |
| ![4e_Gate_Formation](/docs/images/16Mask_CMOS_Process/4e_Gate_Formation.png) | ![4f_Gate_Formation](/docs/images/16Mask_CMOS_Process/4f_Gate_Formation.png) |
| ![4g_Gate_Formation](/docs/images/16Mask_CMOS_Process/4g_Gate_Formation.png) | ![4h_Gate_Formation](/docs/images/16Mask_CMOS_Process/4h_Gate_Formation.png) |
| ![4i_Gate_Formation](/docs/images/16Mask_CMOS_Process/4i_Gate_Formation.png) | ![4j_Gate_Formation](/docs/images/16Mask_CMOS_Process/4j_Gate_Formation.png) |
| ![4k_Gate_Formation](/docs/images/16Mask_CMOS_Process/4k_Gate_Formation.png) | ![4l_Gate_Formation](/docs/images/16Mask_CMOS_Process/4l_Gate_Formation.png) |
| ![4m_Gate_Formation](/docs/images/16Mask_CMOS_Process/4m_Gate_Formation.png) | ![4n_Gate_Formation](/docs/images/16Mask_CMOS_Process/4n_Gate_Formation.png) |

### 22.1.5 Lightly-Doped Drain (LDD) Formation
| ![5a_LDD_Formation](/docs/images/16Mask_CMOS_Process/5a_LDD_Formation.png) | ![5b_LDD_Formation](/docs/images/16Mask_CMOS_Process/5b_LDD_Formation.png) |
|:---|:---|
| ![5c_LDD_Formation](/docs/images/16Mask_CMOS_Process/5c_LDD_Formation.png) | ![5d_LDD_Formation](/docs/images/16Mask_CMOS_Process/5d_LDD_Formation.png) |
| ![5e_LDD_Formation](/docs/images/16Mask_CMOS_Process/5e_LDD_Formation.png) | ![5f_LDD_Formation](/docs/images/16Mask_CMOS_Process/5f_LDD_Formation.png) |
| ![5g_LDD_Formation](/docs/images/16Mask_CMOS_Process/5g_LDD_Formation.png) | ![5h_LDD_Formation](/docs/images/16Mask_CMOS_Process/5h_LDD_Formation.png) |
| ![5i_LDD_Formation](/docs/images/16Mask_CMOS_Process/5i_LDD_Formation.png) | ![5j_LDD_Formation](/docs/images/16Mask_CMOS_Process/5j_LDD_Formation.png) |

### 22.1.6 Source and Drain Formation
| ![6a_Source_Drain_Formation](/docs/images/16Mask_CMOS_Process/6a_Source_Drain_Formation.png) | ![6b_Source_Drain_Formation](/docs/images/16Mask_CMOS_Process/6b_Source_Drain_Formation.png) |
|:---|:---|
| ![6c_Source_Drain_Formation](/docs/images/16Mask_CMOS_Process/6c_Source_Drain_Formation.png) | ![6d_Source_Drain_Formation](/docs/images/16Mask_CMOS_Process/6d_Source_Drain_Formation.png) |
| ![6e_Source_Drain_Formation](/docs/images/16Mask_CMOS_Process/6e_Source_Drain_Formation.png) | ![6f_Source_Drain_Formation](/docs/images/16Mask_CMOS_Process/6f_Source_Drain_Formation.png) |
| ![6g_Source_Drain_Formation](/docs/images/16Mask_CMOS_Process/6g_Source_Drain_Formation.png) | ![6h_Source_Drain_Formation](/docs/images/16Mask_CMOS_Process/6h_Source_Drain_Formation.png) |

### 22.1.7 Formation of Contacts and Local Interconnects
| ![7a_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7a_Contacts_Local_Interconnect_Formation.png) | ![7b_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7b_Contacts_Local_Interconnect_Formation.png) |
|:---|:---|
| ![7c_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7c_Contacts_Local_Interconnect_Formation.png) | ![7d_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7d_Contacts_Local_Interconnect_Formation.png) |
| ![7e_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7e_Contacts_Local_Interconnect_Formation.png) | ![7f_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7f_Contacts_Local_Interconnect_Formation.png) |
| ![7g_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7g_Contacts_Local_Interconnect_Formation.png) | ![7h_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7h_Contacts_Local_Interconnect_Formation.png) |
| ![7i_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7i_Contacts_Local_Interconnect_Formation.png) | ![7j_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7j_Contacts_Local_Interconnect_Formation.png) |
| ![7k_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7k_Contacts_Local_Interconnect_Formation.png) | ![7l_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7l_Contacts_Local_Interconnect_Formation.png) |
| ![7m_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7m_Contacts_Local_Interconnect_Formation.png) | ![7n_Contacts_Local_Interconnect_Formation](/docs/images/17Mask_CMOS_Process/7n_Contacts_Local_Interconnect_Formation.png) |

### 22.1.8 Formation of Higher Level Metal Layers
| ![8a_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8a_Higher_Level_Metal_Formation.png) | ![8b_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8b_Higher_Level_Metal_Formation.png) |
|:---|:---|
| ![8c_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8c_Higher_Level_Metal_Formation.png) | ![8d_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8d_Higher_Level_Metal_Formation.png) |
| ![8e_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8e_Higher_Level_Metal_Formation.png) | ![8f_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8f_Higher_Level_Metal_Formation.png) |
| ![8g_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8g_Higher_Level_Metal_Formation.png) | ![8h_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8h_Higher_Level_Metal_Formation.png) |
| ![8i_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8i_Higher_Level_Metal_Formation.png) | ![8j_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8j_Higher_Level_Metal_Formation.png) |
| ![8k_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8k_Higher_Level_Metal_Formation.png) | ![8l_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8l_Higher_Level_Metal_Formation.png) |
| ![8m_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8m_Higher_Level_Metal_Formation.png) | ![8n_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8n_Higher_Level_Metal_Formation.png) |
| ![8o_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8o_Higher_Level_Metal_Formation.png) | ![8p_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8p_Higher_Level_Metal_Formation.png) |
| ![8q_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8q_Higher_Level_Metal_Formation.png) | ![8r_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8r_Higher_Level_Metal_Formation.png) |
| ![8s_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8s_Higher_Level_Metal_Formation.png) | ![8t_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8t_Higher_Level_Metal_Formation.png) |

### 22.1.9 Final Wafer after Fabrication
| ![8u_Higher_Level_Metal_Formation](/docs/images/18Mask_CMOS_Process/8u_Higher_Level_Metal_Formation.png) |
|:---|

## Lab: Introduction to Sky130 basic layers layout and LEF using inverter
  * Clone a custom standard cell design from the following github repo for this exercise
    [https://github.com/nickson-jose/vsdstdcelldesign.git](https://github.com/nickson-jose/vsdstdcelldesign.git)
  * To open the design in magic: `magic -T sky130A.tech sky130_inv.mag`
  * Get familiarized with the different layers in sky130 technology.
  * To get the details about any drawn element in the layout, hover the mouse pointer over it and press `s` to select it (pressing multiple times selects the elements hierarchically).
    Then, from the **tkcon shell**, use the command `what` to print the details:
    
  | **sky130 Layers in Magic for an Inverter**<br>  ![D22_Lab_Magic_sky130_Layers](/docs/images/D22_Lab_Magic_sky130_Layers.png) |
  |:---|

## Lab: Create the Inverter Standard Cell layout and extract the SPICE netlist
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

## Lab: Create a SPICE deck to run a simple transient simulation using ngspice
  * Modify the spice file to run a sample transient simulation using ngspice:
    * Add VDD and GND:
      ```
      VDD VPWR 0 3.3V
      VSS VGND 0 0V
      ``` 
    * Add a pulse source to the input node: `Va A VGND PULSE(0V 3.3V 0 0.1ns 0.1ns 2ns 4ns)`
    * Transient simulation: `.tran 1n 20n`
    * Finally, for some weird reasons, ngspice throws an **unknown subckt** error with transistor instance names starting with `X`. So, modify the instance names to M0 and M1

    | **SPICE deck to run trans sim using the extracted netlist**<br>  ![D22_Inverter_Extracted_SPICE_netlist_trans_sim](/docs/images/D22_Inverter_Extracted_SPICE_netlist_trans_sim.png) |
    |:---|
    | **Trans sim results with Waveforms**<br>  ![D22_Inverter_Extracted_SPICE_trans_sim_waveform](/docs/images/D22_Inverter_Extracted_SPICE_trans_sim_waveform.png) |

## Lab: Introduction to DRC using Magic tool
  * Obtain the tutorial files for DRC labs from the following link:
    ```
    wget http://opencircuitdesign.com/open_pdks/archive/drc_tests.tgz
    tar xfz drc_tests.tgz
    ```
  * The Design Rules for Skywater 130nm technology can be found here: [**https://skywater-pdk.readthedocs.io/en/main/rules.html**](https://skywater-pdk.readthedocs.io/en/main/rules.html)

### <ins>DRC Lab 1: met3.mag</ins>
  * To open Magic using OpenGL or Cairo graphical interfaces, invoke magic using the `-d` option:
    * For OpenGL: `magic -d XR &`
    * For Cairo: `magic -d OGL &`
  
  * Open the `met3.mag` tutorial file in Magic either via the command line or from the GUI via **File -> Open...**
  * To view the DRC errors/ violations flagged for an area:
    * Position the cursor box around the required area by using the left and right mouse buttons.
    * Commands to the **tkcon console** can be passed without leaving the main layout GUI window by pressing the `:` key followed by entering the required command
    * For example, to view the DRC error for the m3.2 section, position the cursor box around it and type: `:drc why`
    * The **console** window will now display the DRC rule that is being violated
  
    | **Rule M3.2: Spacing of metal 3 to metal 3 - 0.300µm**<br>  ![D22_sky130_DRC_Lab_M3.2](/docs/images/D22_sky130_DRC_Lab_M3.2.png) |
    |:---|
<br>

  * Vias are a kind of derived layer in Magic, in which the drawn via represents an area that is filled with contact cuts. The contact cuts (which is essentially the Mask layer for VIA2 in the output GDS) don't actually exist in the drawn layout view. They are created from rules in the CIF output section of the tech file that tell Magic how to draw contact cuts in the drawn contact area.
    * Draw an area of M3 contact by enclosing some area in the cursor box using the left and right mouse buttons, hover the mouse pointer over the `m3contact` icon in the sidebar and click the middle mouse-button (or, press the `p` key)
    * Otherwise, use the `paint m3contact` command after enclosing the required area in the cursor box.
    * To view the M3 contact cuts, from the layout window, type `:cif see VIA2`
      This view in the layout window is called a **feedback entry** and can be dismissed using the `feedback clear` command.
    * As a sidenote, rules like these will always be correct by design and can be confirmed by measuring the distance from the contact cut to the edge of M3 contact by drawing a cursor box.
      *  To align the cursor box to the edge of the via shown in the CIF view, use the `snap int` command.
  
    | **Rule M3.4: Via2 must be enclosed by Met3 by at least 0.065µm**<br>  ![D22_sky130_DRC_Lab_M3.4_M3ContactCut_VIA2](/docs/images/D22_sky130_DRC_Lab_M3.4_M3ContactCut_VIA2.png) |
    |:---|

### <ins>DRC Lab 2: poly.mag - Exercise to fix poly.9 error in Sky130 tech-file</ins>
  * [https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#poly](https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#poly)
  * **poly.9**: Poly resistor spacing to poly or spacing (no overlap) to diff/tap 0.480 µm
  * This exercise deals with fixing an incomplete DRC rule in the `sky130A.tech` file
  * The section shown below is violating the poly.9 DRC rule, but it is not reported as a DRC violation due to the rule being incompletely implemented in the `sky130A.tech` file

    | **Rule poly.9: Poly resistor spacing to poly or spacing (no overlap) to diff/tap 0.480µm**<br>  ![D22_sky130_DRC_Lab_poly.9_Missing_DRC_rule_1](/docs/images/D22_sky130_DRC_Lab_poly.9_Missing_DRC_rule_1.png) |
    |:---|
  * In the `sky130A.tech` file:
    * The rules for poly resistor spacing to alldiffusion and nsd (nsubstratediff or N-tap) are implemented. So we need to implement the missing poly resistor spacing to poly rules.

    | **sky130A.tech** | |
    |:---|:---|
    | ![D22_sky130_DRC_Lab_poly.9_Missing_DRC_rule_2](/docs/images/D22_sky130_DRC_Lab_poly.9_Missing_DRC_rule_2.png) | ![D22_sky130_DRC_Lab_poly.9_Missing_DRC_rule_3](/docs/images/D22_sky130_DRC_Lab_poly.9_Missing_DRC_rule_3.png) |

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

    | **Magic DRC engine now shows the poly resistor to poly spacing error**<br>  ![D22_sky130_DRC_Lab_poly.9_Missing_DRC_rule_4](/docs/images/D22_sky130_DRC_Lab_poly.9_Missing_DRC_rule_4.png) |
    |:---|

### <ins>DRC Lab 3: poly.mag - Exercise to implement poly resistor spacing to diff and tap</ins>
  * The additions we made for the poly.9 DRC rule are still not complete. We can check this by creating two copies of the three resistors (`npolyres, ppolyres and xhrpolyres`)
  * We will add `ndiffussion, pdiffusion, nsubstratendiff & psubstratepdiff` around the two copies of the three poly resistors as shown.
  * Also draw an `nwell` under the pdiffusion and N-tap (nsubstratendiff) to avoid the flagging of any diffusion-related DRC errors since we are not interested in them for this exercise.

  * From the layout, we can see that all the poly resistors except the `npolyres` are showing the DRC spacing violations. The `npolyres` is only flagging the DRC spacing violation to the N-tap.
    This can be fixed by changing the npres spacing rule to consider all diffusion instead of just `nsd`
    
  | Before | After |
  |:---|:---|
  |  <pre>spacing npres *nsd 480 touching_illegal \ <br>   "poly.resistor spacing to N-tap < %d (poly.9)"</pre> | <pre>spacing npres alldiff 480 touching_illegal \ <br>   "poly.resistor spacing to N-tap < %d (poly.9)"</pre> |
  | ![D22_sky130_DRC_Lab_poly.9_Diffusion_1](/docs/images/D22_sky130_DRC_Lab_poly.9_Diffusion_1.png) | ![D22_sky130_DRC_Lab_poly.9_Diffusion_2](/docs/images/D22_sky130_DRC_Lab_poly.9_Diffusion_2.png) |

### <ins>DRC Lab 4: nwell.mag - Challenge exercise to describe DRC error as geometrical construct</ins>
  * [https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#nwell](https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#nwell)
  * **nwell.5**: Deep nwell must be enclosed by nwell by atleast… 0.400µm.  
     Exempted inside UHVI or areaid.lw Nwells can merge over deep nwell if spacing too small (as in rule nwell.2)
  * **nwell.6**: Min enclosure of nwell hole by deep nwell outside UHVI 1.030µm
  * Relevant DRC rules in `sky130A.tech` file

  | ![D22_sky130_DRC_Lab_nwell.5_0](/docs/images/D22_sky130_DRC_Lab_nwell.5_0.png) | ![D22_sky130_DRC_Lab_nwell.5_1](/docs/images/D22_sky130_DRC_Lab_nwell.5_1.png) |
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

  | **nwell.6 drawing <br>**  ![D22_sky130_DRC_Lab_nwell.5_2](/docs/images/D22_sky130_DRC_Lab_nwell.5_2.png) | **cif ostyle drc <br>cif see dnwell_shrink** <br>  ![D22_sky130_DRC_Lab_nwell.5_3](/docs/images/D22_sky130_DRC_Lab_nwell.5_3.png) |
  |:---|:---|
  | **feed clear <br>cif see nwell_missing** <br>  ![D22_sky130_DRC_Lab_nwell.5_4](/docs/images/D22_sky130_DRC_Lab_nwell.5_4.png) | |
  
  * **NOTE**:
    * Any edge based rules could be implemented using cifoutput operators but generating these layers is highly compute-intensive.
    * Hence to avoid Magic getting sluggish by these geometrically defined rules it is better to use the simple DRC edge-based rules whenever possible and put the cifoutput rules into a separate style variant, that can be run on-demand and can be prevented from running during interactive layout.
    * In `sky130A.tech` file, there are two variants of DRC rule styles:
      * `drc fast`: intended for working on backend metal layers and large synthesized digital designs without checking all the layers below metal
      * `drc full`: will check everything. As long as the layout is relatively small, it can be enabled during interactive layout without everything turning sluggish.
      * Switch between the two using: `drc style drc(fast)`, `drc style drc(full)`

### <ins>DRC Lab 5: nwell.mag - Challenge  to find missing or incorrect rules and fix them</ins>
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
  | **untapped nwell being flagged for DRC violn. <br>**  ![D22_sky130_DRC_Lab_nwell.4_1](/docs/images/D22_sky130_DRC_Lab_nwell.4_1.png) | **tapped nwell showing no DRC violn.** <br>  ![D22_sky130_DRC_Lab_nwell.4_2](/docs/images/D22_sky130_DRC_Lab_nwell.4_2.png) |
  |:---|:---|


_________________________________________________________________________________________________________  
[Prev: Day 21](Day_21.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 23](Day_23.md)  
