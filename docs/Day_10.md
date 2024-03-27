[Back to TOC](../README.md)  
[Prev: Day9](Day9.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 11](Day_11.md)  
_________________________________________________________________________________________________________  
# Day 10 - GLS

  * The functional verification of the design has already been completed successfully in the Makerchip IDE itself.
  * To perform GLS of the implementation, we need to first convert the TL-Verilog code into synthesizable verilog and then perform the synthesis using Yosys.


## 10.1 Conversion of TL-Verilog code to Verilog using Sandpiper
SandPiper TL-Verilog compiler, developed by Redwood EDA can be used to convert TL-Verilog code to Verilog or SystemVerilog code. SandPiper-SaaS provides a command-line interface to run the SandPiper TL-Verilog compiler as a microservice in the cloud.  

  * Commonly used Sandpiper arguments:
    | Argument | Details |
    |-|-|
    | `-p` | <ul> <li>Project name, corresponding to project configuration directory (e.g. -p verilog).</li> <li>(default: default)</li></ul> |
    | `--hdl` | <ul><li>The extended and target hardware description language.</li> <li>One of: 'verilog', 'sv'.</li> <li>This argument is implicit if a project (--p) argument is given.</li> <li>(default: sv) |
    | `-i` | <ul> <li>Input TL-X file (with absolute or relative path).</li> <li>(See also, --basename.)</li></ul> |
    | `-o` | <ul> <li>Produce the given translated HDL file, where the HDL language is determined from the project (-p) arg OR (--hdl ) arg.</li> <li>File is specified as an absolute path or a path relative to the current directory, or --outdir, if given.</li> <li>If a path ending in "/" or no/empty arg is given, the file name is derived from --basename or -i.</li> <li>A value of "STDOUT" may also be used.</li> </ul> |
    | `--outdir` | A root directory for all produced files as a relative or absolute path. |
    | `--inlineGen` | Produce the generated code in an inline code block within the translated code, rather than in a separate file. |
    | `--iArgs` | Process command-line arguments provided in the source file. |
    | `--bestsv` | Optimize the readability/maintainability of the generated SV, unconstrained by correlation w/ TLV source. |
    | `--noline` | Disable `line directive in SV output |
    | `--verbose` | Verbose output for debug. |
    | `--clkAlways` | <ul> <li>Use a clocking strategy for deasserted 'when' conditions (vs. clkGate and clkEnable) in which all sequential elements use an always-enabled clock with no clock gating or clock enabling.</li> <li>Thus, no power is saved from clock distribution and avoided logic propagation.</li> <li> State signal values are held using explicit recirculation. </li></ul> |
    | `--clkGate` | <ul> <li>This is the default and takes precedence over the other two --clk* flags.</li> <li>Use a clocking strategy for deasserted 'when' conditions in which gated clock signals are provided to sequential elements.</li> <li>Power is saved in clock distribution and by avoiding the propagation of unused values.</li> <li> Explicit recirculation of state is produced only when state is consumed in the cycle that the next state value is produced.</li> </ul> |
    | `--clkEnable` | <ul> <li>'when' conditions are applied as clock enables to staging flip-flops.</li> <li>It is generally recommended to use this in combination with --clkStageAlways.</li> <li>This overrides --clkAlways.</li> </ul> |
    | `--clkStageAlways` | <ul> <li>'when' conditions such that gating/enabling is applied only to the first flip-flop after each  assignment with subsequent staging using the free-running clock.</li> </ul> |


  * The Sandpiper arguments could be provided either in the source file as inline arguments or in the terminal while invoking sandpiper-saas.

### a) Providing the SandPiper arguments in the source file
  * The first line of a TL-X file, called the **"File Format Line"**, must identify the TL-X File Format Version and HDL Language, as well as a URL to the language specification.  
    For example, for a TL-Verilog source file using m4 macro pre-processing language, the first line will look like as follows:  
    `\m4_TLV_version 1d: tl-x.org`
    <br>
    
  * To this File Format line in the source file, we can add the required command-line arguments to be passed to Sandpiper, as shown in the following example:  
    `\m4_TLV_version 1d -p verilog --bestsv --noline --inlineGen --verbose: tl-x.org`
    <br>
    
  * So the command-line to be executed with the above arguments added to the File Format line in the source file is:  
    `sandpiper-saas -i <input_tlv_file.tlv> -o <output_file.v> --outdir <output_dir> --inlineGen --iArgs`
    <br>
    
    **NOTE:** Based on my observation, the argument `--iArgs` needs to be provided in the terminal itself for it to take effect for some reason.
    <br>
    
### b) Providing the SandPiper arguments in the command-line/ shell
  * The first line in the source file - i.e., the "File Format Line" can be kept as it is and all the required arguments to sandpiper can be provided in the terminal.  
    The first line will remain unchanged in the standard format as follows: `\m4_TLV_version 1d: tl-x.org`
    <br>
    
  * The sandpiper-saas command-line now needs to include all the required arguments.
  * To specify the target HDL language, either the project (`-p`) argument or the target HDL (`--hdl`) argument can be used.
    * When the `-p verilog` argument is used, it needs to be provided as the last item in the command-line to avoid some issue with the argument interpretation by the tool.
<br>

#### <ins>Method 1:</ins> Using the Makerchip IDE
  * The Makerchip IDE provides within itself indirect access to Sandpiper - i.e., the compilation output result files can be accessed via the IDE's Editor ("E") dropdown menu.
  * If the design is relatively small and not spread across multiple files, it is easier to use the [Makerchip IDE](https://makerchip.com/sandbox/#) itself to convert the TL-Verilog code to Verilog/ SystemVerilog.
  * In this case, as we do not have direct access to "terminal/ shell", all the sandpiper arguments need to be provided in the source file.

**<ins>Steps:</ins>**
  1) Enter the TL-Verilog code in the Makerchip IDE's Editor interface.
  2) Under the Editor ("E") dropdown menu, choose **Compile/ Sim** to perform the TL-Verilog code compilation and simulation.
     |![D10_TLV_to_Verilog_using_MakerChipIDE_1](/docs/images/D10_TLV_to_Verilog_using_MakerChipIDE_1.png)|
     |-|
     
  3) Under the Editor ("E") dropdown menu, choose **Open Results**.
     * This will open up a new webpage that has links to the last SystemVerilog output files of the compilation.
       |![D10_TLV_to_Verilog_using_MakerChipIDE_3](/docs/images/D10_TLV_to_Verilog_using_MakerChipIDE_3.png)|
       |-|
     
  * Alternately, under the Editor ("E") dropdown menu, choose **Show Verilog**.
    * This will open up a new webpage that shows the last compiled SystemVerilog results, along with some statistics about your TL-Verilog and SystemVerilog code.
      |![D10_TLV_to_Verilog_using_MakerChipIDE_2](/docs/images/D10_TLV_to_Verilog_using_MakerChipIDE_2.png)|
      |-|
<br>

#### <ins>Method 2:</ins> Using Sandpiper-SaaS
  * Install Sandpiper-SaaS by following the steps in the following link: [https://pypi.org/project/sandpiper-saas/](https://pypi.org/project/sandpiper-saas/)
  * Usage Examples:  
    ```shell
    sandpiper-saas -i <input_tlv_file.tlv> -o <output_file.v> --outdir <output_dir> --bestsv --noline --iArgs --inlineGen -p verilog
    sandpiper-saas -i <input_tlv_file.tlv> -o <output_file.v> --outdir <output_dir> --bestsv --noline --iArgs --inlineGen --hdl verilog
    ```
  
**NOTE:**  
There is a "bug" with argrument parsing by sandpiper-saas wherein the first argument that is not a switch (like --inlineGen, --bestsv etc.) but an optional argument (like -p verilog, --hdl verilog) gets parsed incorrectly. Because of this bug, they had to be given as the last item of the command-line as shown in the usage examples above.
<br>

The following GitLab merge request documents the issue and the fix for the same: [https://gitlab.com/rweda/sandpiper-saas/-/merge_requests/2](https://gitlab.com/rweda/sandpiper-saas/-/merge_requests/2)  
To install sandpiper-saas with the above fix, clone the following repo [https://gitlab.com/arunkumarpv/sandpiper-saas.git](https://gitlab.com/arunkumarpv/sandpiper-saas.git) and install sandpiper-saas.  
```
git clone https://gitlab.com/arunkumarpv/sandpiper-saas.git
cd sandpiper-saas
pip3 install .
```
<br>

#### <ins>Method 3:</ins> Using Sandpiper-SaaS with Edalize, FuseSoc
  * Sandpiper-SaaS supports the Flow API and thus allowing sandpiper-saas to be used as a "frontend" to convert TL-Verilog to SystemVerilog/Verilog for any flow.
  * An example of how to use sandpiper-saas with Edalize or Fusesoc in various contexts - viz. standalone tool, frontend to Vivado, in a Custom flow) is available here:<br>
    [edalize_sandpiper_example](https://github.com/shariethernet/edalize_sandpiper_example)  

Additional Reference Links:  
  1) [Edalize](https://github.com/olofk/edalize.git)
  2) [Fusesoc](https://fusesoc.readthedocs.io/en/stable/user/installation.html)

<br>
    
## 10.2 GLS of the implemented RISC-V CPU Core
The TL-Verilog code of the RISC-V CPU core implementation was successfully converted to Verilog using Sandpiper-SaaS.  
  * To ensure that the flow is clean, I first tried GLS for a simple counter circuit:
    1) TL-V code of counter was verified in Makerchip IDE
    2) Conversion to Verilog using Sandpiper-SaaS
    3) Verify functionality using iverilog
    4) Perform synthesis using Ysosys
    5) Verify correctness by performing GLS using the synthesis output in iverilog
  
  * All steps until (iv) are verified to be working fine, however, the GLS using the synthesis tool generated netlist is failing with all signals being "X".  
  
This turned out to be due to known issues:  
  * [OpenLane Issue #518](https://github.com/The-OpenROAD-Project/OpenLane/issues/518):
    * Behavioral models in the Skywater 130 PDK are buggy and we need to switch to using the functional models by passing the FUNCTIONAL define to iverilog.
    * The UNIT_DELAY macro also needs to be set to some value.  
      `#iverilog -DFUNCTIONAL -DUNIT_DELAY=#1 ./lib/verilog_model/primitives.v ./lib/verilog_model/sky130_fd_sc_hd.v riscv_pipelined_Final_netlist.v tb_top_post-synth.v`
    
  * [Skywater-PDK Issue #297](https://github.com/google/skywater-pdk/issues/297), [Skywater-PDK Issue #298](https://github.com/google/skywater-pdk/issues/298):  
    In `sky130_fd_sc_hd.v`:
    * Comment out all `wire 1;` statements
    * Change `endif SKY130_FD_SC_HD__LPFLOW_BLEEDER_FUNCTIONAL_V` to `endif //SKY130_FD_SC_HD__LPFLOW_BLEEDER_FUNCTIONAL_V`
  
With the above changes the "X"es in the simulation of the synthesized netlist is resolved and the GLS of the RISC-V CPU core is performed successfully.
```shell
iverilog -DFUNCTIONAL -DUNIT_DELAY=#1 ./lib/verilog_model/primitives.v ./lib/verilog_model/sky130_fd_sc_hd.v riscv_pipelined_Final_netlist.v tb_top_post-synth.v
./a.out
gtkwave postsynth_sim.vcd &
```

  * [**Yosys synthesis script**](../code/riscv/scripts/yosys.ys)
    * The synthesis script was updated at a later point in time, based on the inputs obtained from the [Yosys issue raised for a problem found in post-synth STA](https://github.com/YosysHQ/yosys/issues/4266#).
      * (* keep *) attributes were added to some of the wire declarations to prevent them from getting optimized out by Yosys, abc during synthesis.
      * To avoid retaining DFF with constant inputs, the synthesis script was updated with two passes of abc.
     
    ```shell
    read_liberty -lib ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib
    read_verilog ./riscv_pipelined_Final2.v
    
    hierarchy -check -top riscv_core
    synth -top riscv_core -flatten
    opt
    stat
    
    abc
    opt
    opt_clean -purge
    stat
    
    dfflibmap -liberty ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib
    
    abc -liberty ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib -script +strash;scorr;ifraig;retime,{D};strash;dch,-f;map,-M,1,{D}
    setundef -undriven -init -zero
    opt
    opt_clean -purge
    rename -enumerate
    stat
    
    write_verilog -noattr ./synth/riscv_pipelined_Final_netlist.v
    ```

 * [**Generated netlist**](../code/riscv/verilog/riscv_pipelined_Final_netlist.v)
  
 * **Statistics of synthesis output:**
    ```
    === riscv_core ===
    
       Number of wires:               6845
       Number of wire bits:          10386
       Number of public wires:        6845
       Number of public wire bits:   10386
       Number of memories:               0
       Number of memory bits:            0
       Number of processes:              0
       Number of cells:               9446
         sky130_fd_sc_hd__a2111o_1       5
         sky130_fd_sc_hd__a2111oi_0     21
         sky130_fd_sc_hd__a211oi_1      11
         sky130_fd_sc_hd__a21boi_0       1
         sky130_fd_sc_hd__a21oi_1     1886
         sky130_fd_sc_hd__a221oi_1     281
         sky130_fd_sc_hd__a22o_2        30
         sky130_fd_sc_hd__a22oi_1      307
         sky130_fd_sc_hd__a31o_2         1
         sky130_fd_sc_hd__a31oi_1      259
         sky130_fd_sc_hd__a32o_1        23
         sky130_fd_sc_hd__a32oi_1        2
         sky130_fd_sc_hd__a41oi_1        1
         sky130_fd_sc_hd__and2_2         6
         sky130_fd_sc_hd__clkinv_1     847
         sky130_fd_sc_hd__dfxtp_1     1907
         sky130_fd_sc_hd__maj3_1         2
         sky130_fd_sc_hd__nand2_1     1122
         sky130_fd_sc_hd__nand3_1      115
         sky130_fd_sc_hd__nand3b_1       7
         sky130_fd_sc_hd__nand4_1      141
         sky130_fd_sc_hd__nor2_1       546
         sky130_fd_sc_hd__nor3_1        45
         sky130_fd_sc_hd__nor3b_1        1
         sky130_fd_sc_hd__nor4_1        14
         sky130_fd_sc_hd__nor4b_1        1
         sky130_fd_sc_hd__o2111a_1       3
         sky130_fd_sc_hd__o2111ai_1      6
         sky130_fd_sc_hd__o211ai_1      62
         sky130_fd_sc_hd__o21a_1         5
         sky130_fd_sc_hd__o21ai_0     1480
         sky130_fd_sc_hd__o21bai_1       7
         sky130_fd_sc_hd__o221ai_1       8
         sky130_fd_sc_hd__o22ai_1      178
         sky130_fd_sc_hd__o31ai_1        5
         sky130_fd_sc_hd__o32ai_1        1
         sky130_fd_sc_hd__o41ai_1        4
         sky130_fd_sc_hd__or2_2          5
         sky130_fd_sc_hd__or3_2          6
         sky130_fd_sc_hd__or4_2         12
         sky130_fd_sc_hd__xnor2_1       22
         sky130_fd_sc_hd__xor2_1        60
    ```

  * **Comparison of Pre-synth and Post-synth simulation results**
    * The top module level input/ outputs are identical in both the Pre-Synth and Post-Synth simulation results.
    * The internal signals of relevance are also identical now that they are not optimized out due to using the (* keep *) attribute.
      <br>

    |  | _**Comparison of Top Module Input, Outputs:**_ |
    |:---:|:---|
    | Pre-Synth | ![D10_PreSynth_Simlation_Final_Output](/docs/images/D10_PreSynth_Simlation_Final_Output.png) |
    | Post-Synth | ![D10_PostSynth_Simlation_Final_Output](/docs/images/D10_PostSynth_Simlation_Final_Output.png) |

    |  | _**Simulation time: Reset De-assertion**_ |
    |:---:|:---|
    | Pre-Synth | ![D10_PreSynth_Simlation_Reset_Deassertion_Zoomed](/docs/images/D10_PreSynth_Simlation_Reset_Deassertion_Zoomed.png) |
    | Post-Synth | ![D10_PostSynth_Simlation_Reset_Deassertion_Zoomed](/docs/images/D10_PostSynth_Simlation_Reset_Deassertion_Zoomed.png) |

    |  | _**Simulation time: Test Program Final Output**_ |
    |:---:|:---|
    | Pre-Synth | ![D10_PreSynth_Simlation_Final_Output_Zoomed.png](/docs/images/D10_PreSynth_Simlation_Final_Output_Zoomed.png) |
    | Post-Synth | ![D10_PostSynth_Simlation_Final_Output_Zoomed.png](/docs/images/D10_PostSynth_Simlation_Final_Output_Zoomed.png) |

_________________________________________________________________________________________________________  
_________________________________________________________________________________________________________  

  * [**(OLD) Yosys synthesis script**](../code/riscv/scripts/yosys_OLD.ys)
    ```shell
    read_liberty -lib ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib
    read_verilog ./riscv_pipelined_Final.v

    hierarchy -check -top riscv_core
    synth -top riscv_core

    dfflibmap -liberty ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib
    opt

    abc -liberty ./lib/sky130_fd_sc_hd__tt_025C_1v80.lib -script +strash;scorr;ifraig;retime,{D};strash;dch,-f;map,-M,1,{D}
    flatten
    setundef -undriven -init -zero

    opt_clean -purge
    rename -enumerate
    stat
    write_verilog -noattr ./synth/riscv_pipelined_Final_netlist.v
    ```

 * [**(OLD) Generated netlist**](../code/riscv/verilog/riscv_pipelined_Final_netlist_OLD.v)
  
 * **<details><summary>(OLD) Statistics of synthesis output:</summary>**
    ```
    === riscv_core ===
    
       Number of wires:               7014
       Number of wire bits:          10175
       Number of public wires:        7014
       Number of public wire bits:   10175
       Number of memories:               0
       Number of memory bits:            0
       Number of processes:              0
       Number of cells:               9049
         sky130_fd_sc_hd__a2111oi_0     20
         sky130_fd_sc_hd__a211oi_1      17
         sky130_fd_sc_hd__a21boi_0       9
         sky130_fd_sc_hd__a21o_2         1
         sky130_fd_sc_hd__a21oi_1      917
         sky130_fd_sc_hd__a221oi_1     238
         sky130_fd_sc_hd__a22o_2        27
         sky130_fd_sc_hd__a22oi_1      479
         sky130_fd_sc_hd__a311oi_1       5
         sky130_fd_sc_hd__a31oi_1      738
         sky130_fd_sc_hd__a32o_1         3
         sky130_fd_sc_hd__a32oi_1        3
         sky130_fd_sc_hd__and2_2        12
         sky130_fd_sc_hd__and3_2         2
         sky130_fd_sc_hd__clkinv_1     784
         sky130_fd_sc_hd__dfxtp_1     1962
         sky130_fd_sc_hd__maj3_1         2
         sky130_fd_sc_hd__mux2i_1        3
         sky130_fd_sc_hd__nand2_1      860
         sky130_fd_sc_hd__nand3_1      247
         sky130_fd_sc_hd__nand3b_1       3
         sky130_fd_sc_hd__nand4_1      175
         sky130_fd_sc_hd__nor2_1       573
         sky130_fd_sc_hd__nor3_1        52
         sky130_fd_sc_hd__nor4_1        46
         sky130_fd_sc_hd__nor4b_1        2
         sky130_fd_sc_hd__o2111ai_1     17
         sky130_fd_sc_hd__o211a_1        1
         sky130_fd_sc_hd__o211ai_1      46
         sky130_fd_sc_hd__o21a_1         3
         sky130_fd_sc_hd__o21ai_0     1476
         sky130_fd_sc_hd__o21bai_1      29
         sky130_fd_sc_hd__o221ai_1       5
         sky130_fd_sc_hd__o22ai_1      183
         sky130_fd_sc_hd__o2bb2ai_1      2
         sky130_fd_sc_hd__o311a_2        1
         sky130_fd_sc_hd__o311ai_0       9
         sky130_fd_sc_hd__o31ai_1        1
         sky130_fd_sc_hd__o41ai_1        1
         sky130_fd_sc_hd__or2_2         19
         sky130_fd_sc_hd__or2b_2         1
         sky130_fd_sc_hd__or3_2          1
         sky130_fd_sc_hd__or4_2          1
         sky130_fd_sc_hd__xnor2_1       25
         sky130_fd_sc_hd__xor2_1        48
    ```
    </details>

  * **(OLD) Comparison of Pre-synth and Post-synth simulation results**
    * The top module level input/ outputs are identical in both the Pre-Synth and Post-Synth simulation results.
    * However, on a closer look, due to the fact that we are hardcoding the test program in the RTL, the synthesis tools optimizes out some of the constant signals that are _**unused**_.
      Hence, the values of all of the interal signals may not necessarily match between Pre-Synth and Post-Synth simulation.  
      <br>
      For example, the signal **CPU_imem_rd_data_a1** is different in the two due to the fact that the instructions to be executed are hardcoded as constants and not all of the bits in the 32-bit Instruction are necessary for decoding.  
      <br>

    |  | _**(OLD) Comparison of Top Module Input, Outputs:**_ |
    |:---:|:---:|
    | Pre-Synth | ![D10_GLS_PreSynth](/docs/images/D10_GLS_PreSynth.png) |
    | Post-Synth | ![D10_GLS_PostSynth](/docs/images/D10_GLS_PostSynth.png) |

    |  | _**(OLD) Comparison of some Internal Signals:**_ |
    |:---:|:---:|
    | Pre-Synth | ![D10_GLS_PreSynth](/docs/images/D10_GLS_PreSynth_Zoomed.png) |
    | Post-Synth | ![D10_GLS_PostSynth](/docs/images/D10_GLS_PostSynth_Zoomed.png) |
    
_________________________________________________________________________________________________________  
[Prev: Day9](Day9.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 11](Day_11.md)  
