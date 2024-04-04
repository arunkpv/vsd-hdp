# VSD-HDP
This GitHub repository is created as part of attending the VLSI Hardware Development Program ([VSD-HDP](https://www.vlsisystemdesign.com/hdp/), Cohort: 21 October, 2023 – 29 December, 2023).
<br />
<br />
 **Progress Status**
 | Day # | Topic(s) Covered | Status |
 |---|---|---|
 |[Day 0](/docs/Day0.md) | GitHub repo creation, System/ Tools Setup | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 1](/docs/Day1.md) | Introduction to Verilog RTL design and Synthesis | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 2](/docs/Day2.md) | <ol><li>Familiarization of .lib file structure and various timing models (QTMs/ETMs)</li><li>Hierarchical vs. Flat synthesis</li><li>Various Flip-Flop designs</li></ol> | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 3](/docs/Day3.md) | Logic Synthesis Optimizations<ol><li>Combinational</li><li>Sequential</li></ol> | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 4](/docs/Day4.md) | <ol><li>Gate Level Simulation</li><li>Synthesis-Simulation mismatch</li></ol> | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 5](/docs/Day5.md) | Introduction to RISC-V ISA and GNU Compiler Toolchain | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 6](/docs/Day6.md) | Introduction to ABI and basic verification flow | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 7](/docs/Day7.md) | Digital Logic with TL-Verilog and Makerchip | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 8](/docs/Day8.md) | Basic RISC-V CPU Microarchitecture | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 9](/docs/Day9.md) | Complete Pipelined RISC-V CPU Microarchitecture | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 10](/docs/Day_10.md)| GLS of the implemented RISC-V CPU Core <ol><li>Conversion of TL-Verilog code to Verilog/ SystemVerilog</li> <li>GLS of the RISC-V CPU Core</li> </ol> | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 11](/docs/Day_11.md)| Advanced Synthesis and STA with DC<br>**Pending:** Documentation | ![](https://progress-bar.dev/90/?title=progress) |
 |[Day 12](/docs/Day_12.md)| Circuit Design using sky130<br>**Pending:** Documentation | ![](https://progress-bar.dev/75/?title=progress) |
 |[Day 13](/docs/Day_13.md)| PVT Corner Analysis | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 14](/docs/Day_14.md)| Advanced Physical Design using OpenLANE/ Sky130 | ![](https://progress-bar.dev/100/?title=done) |
 |[Day 15](/docs/Day_15.md)| Post-placement STA checks for your design <br>  * on ss,ff,tt corners <br>  * Compare with Post-synth | ![](https://progress-bar.dev/100/?title=done) |
  |[Day 16](/docs/Day_16.md)| Post-CTS STA checks for your design <br>  * on ss,ff,tt corners <br>  * Compare with previous results | ![](https://progress-bar.dev/80/?title=done) |

<!--
## Day 0
### System Setup
The program uses Open Source EDA tools and thus a linux OS environment is preferred.
<br />  
__Virtual Machine Requirements:__
  - OS: Ubuntu 18.04+
  - RAM: 6GB or above
  - HDD: 50GB or above
  - CPU cores: 4 vCPUs or more
  
### Tools Setup
 **1. yosys – Yosys Open SYnthesis Suite**  
We will be building Yosys from the source using gcc, the instructions for which are available in the official README for yosys in its GitHub repo.
[Build Yosys from source](https://github.com/YosysHQ/yosys#building-from-source)
<br />
   - Clone source code from git repository:
     ```
     git clone https://github.com/YosysHQ/yosys.git
     ```
    
  - Install the build system prerequsites/ dependencies:
    ```
    sudo apt-get install build-essential clang bison flex \
        libreadline-dev gawk tcl-dev libffi-dev git \
        graphviz xdot pkg-config python3 libboost-system-dev \
        libboost-python-dev libboost-filesystem-dev zlib1g-dev
    ```
    
  - Build (using gcc) and install Yosys:
    ```
    make config-gcc
    make
    sudo make install
    ```
    
  - Invoke from shell:  
    ![day0_yosys](/docs/images/day0_yosys.png)
  
 **2. iverilog - Icarus Verilog**  
   - Install from official Ubuntu repository:
     ```
     sudo apt-get install iverilog
     ```
     
   - Invoke from shell:  
     ![day0_iverilog](/docs/images/day0_iverilog.png)
  
 **3. GTKWave**
   - Install from official Ubuntu repository:
     ```
     sudo apt-get install gtkwave
     ```
     
   - Invoke from shell:  
     ![day0_gtkwave](/docs/images/day0_gtkwave.png)  
  
## Day 1
### Labs 1,2: Functional Simulation of RTL design using iverilog and gktwave
In this lab, we clone the gihthub repo - [sky130RTLDesignAndSynthesisWorkshop](https://github.com/kunalg123/sky130RTLDesignAndSynthesisWorkshop) - and use one of the example RTL design sources together with its corresponding testbench to get familiarised with the functional simulation of an RTL design using iverilog and gtkwave.   
<br />
1. Clone the github repo with the RTL design examples and sky130*.lib files
```
git clone https://github.com/kunalg123/sky130RTLDesignAndSynthesisWorkshop.git
```

2. We will be performing functional simulation of the module good_mux (defined in good_mux.v), as an example.
```
# Step1: Use iverilog to read and interpret the source and testbench file(s) and generate 
# a compiled output (with default output format=vvp)
# Syntax: iverilog -o <outfile> <file1.v> <file2.v> ... <tb_top.v>

iverilog -o good_mux good_mux.v tb_good_mux.v


# Step 2: iverilog has now generated a compiled output named "good_mux", which can now be run using
# the simulation runtime engine, vvp
# Syntax: vvp <outfile>

vvp good_mux


# Step 3: Running the verilog simulation in step 2 will generate & dump the stimulus and output 
# signal values for the defined simulation duration in the testbench to a vcd file.
# This can now be viewed using gtkwave.
# Syntax: gtkwave <dumpfile.vcd>

gtkwave tb_good_mux.vcd
```
_Snapshot of the waves from the above simulation in gtkwave:_
![day1_lab1_2input_mux_iverilog_gktwave](/docs/images/day1_lab1_2input_mux_iverilog_gktwave.png)
<br />
<br />
### Lab 3: Synthesis of RTL design using Yosys with sky130 library as target
In this lab, we will perform gate-level synthesis of the example RTL design simulated in the previous session using Yosys and sky130 as the target library.
<br />
```
# 1. Invoke the yosys shell (since we are doing each step manually this time around)
yosys

# 2. Read the library file(s)
# Syntax: read_liberty -lib <path-to-libfile(s)>

read_liberty -lib ../my_lib/lib/sky130_fd_sc_hd__tt_025C_1v80.lib


# 3. Read the RTL design files
# Syntax: read_verilog <verilog_file.v>

read_verilog good_mux.v


# 4. Perform the synthesis
# Syntax: synth -top <module_name> 

synth -top good_mux


# 5. Generate the gate-level netlist for the target library
# Syntax: abc -liberty <path-to-libfile(s)>
# Note: Pay attention to the syntesis results!

abc -liberty ../my_lib/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

------------------------------------------------------
ABC Result:
------------------------------------------------------
4.1.2. Re-integrating ABC results.
ABC RESULTS:   sky130_fd_sc_hd__mux2_1 cells:        1
ABC RESULTS:        internal signals:        0
ABC RESULTS:           input signals:        3
ABC RESULTS:          output signals:        1
------------------------------------------------------


# 6. (Optional) Show a graphical flow diagram of the logic realized by the 
# synthesis tool for the provided target library file(s)
# Syntax: show
show


# 7. Write the output netlist
# Syntax: write_verilog <netlist_outfile.v>
#         write_verilog -noattr  <netlist_outfile.v>  (excluding attributes)

write_verilog -noattr good_mux_netlist.v


Generated Netlist:
-------------------------------------------------------------------------------------------
/* Generated by Yosys 0.34+43 (git sha1 d21c464ae, gcc 9.4.0-1ubuntu1~20.04.2 -fPIC -Os) */

module good_mux(i0, i1, sel, y);
  wire _0_;
  wire _1_;
  wire _2_;
  wire _3_;
  input i0;
  wire i0;
  input i1;
  wire i1;
  input sel;
  wire sel;
  output y;
  wire y;
  sky130_fd_sc_hd__mux2_1 _4_ (
    .A0(_0_),
    .A1(_1_),
    .S(_2_),
    .X(_3_)
  );
  assign _0_ = i0;
  assign _1_ = i1;
  assign _2_ = sel;
  assign y = _3_;
endmodule
-------------------------------------------------------------------------------------------
```
  
_Logic realized by the synthesis tool in the above example:_
![day1_lab3_2input_mux_synth_logical_diagram](/docs/images/day1_lab3_2input_mux_synth_logical_diagram.png)
  
## Day 2
### Lab 4: Familiarization of the .lib file structure and various timing models (QTMs/ETMs)
1. Open up the **sky130_fd_sc_hd__tt_025C_1v80.lib** library file and get familiarized with the overall structure and the various parameters defined like:
<ul>
 <li>PVT corner for which the lib file is defined</li>
 <li>Process technology</li>
 <li>Delay model</li>
 <li>For the different standard cells, various parameters like: Cell Area, Pin capacitances, Leakage power for different input combinations, Dynamic power during transitions, Transition times, Propagation Delay times etc.</li>
</ul>
  
2. Read up about the various timing models (QTM, ETM, NLDM etc.)  
Ref:  
  [1]: STA for Nanometer Designs - J. Bhasker, Rakesh Chadha (Chapter 3)  
  [2]: [https://www.vlsi-expert.com/2011/02/etm-extracted-timing-models-basics.html](https://www.vlsi-expert.com/2011/02/etm-extracted-timing-models-basics.html)  
  [3]: [https://asic-pd.blogspot.com/2011/08/basic-of-timing-analysis-in-physical_22.html](https://asic-pd.blogspot.com/2011/08/basic-of-timing-analysis-in-physical_22.html)
<br />
  
### Lab 5: Hierarchical vs. Flat Synthesis
In this experiment, we will take a look at how the Yosys tool performs the synthesis and generates the netlst for a multi-module design with and without preserving the design hierarchy.  
For this example, we will use the design file, multiple_modules.v, which contains some logic implementation using two sub-modules.  
<br />
  **1. Hierarchical**  
  Perform the hierarchical synthesis from the Yosys shell using the following commands:  
  ```
  read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
  read_verilog multiple_modules.v
  synth -top multiple_modules
  abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
  write_verilog -noattr multiple_modules_hier.v
  show -stretch multiple_modules
  show sub_module1
  show sub_module2
  ```
  
  Synthesis result preserving the design hierarchy:  
  ![day2_multiple_modules_hier](/docs/images/day2_multiple_modules_hier.png)
  <br />
  <br />
-->
<!--
  Corresponding Netlist - multiple_modules_hier.v:  
  ```
  /* multiple_modules_hier.v
  /* Generated by Yosys 0.34+43 (git sha1 d21c464ae, gcc 9.4.0-1ubuntu1~20.04.2 -fPIC -Os) */
module multiple_modules(a, b, c, y);
  input a;
  wire a;
  input b;
  wire b;
  input c;
  wire c;
  wire net1;
  output y;
  wire y;
  sub_module1 u1 (
    .a(a),
    .b(b),
    .y(net1)
  );
  sub_module2 u2 (
    .a(net1),
    .b(c),
    .y(y)
  );
endmodule

module sub_module1(a, b, y);
  wire _0_;
  wire _1_;
  wire _2_;
  input a;
  wire a;
  input b;
  wire b;
  output y;
  wire y;
  sky130_fd_sc_hd__and2_0 _3_ (
    .A(_1_),
    .B(_0_),
    .X(_2_)
  );
  assign _1_ = b;
  assign _0_ = a;
  assign y = _2_;
endmodule

module sub_module2(a, b, y);
  wire _0_;
  wire _1_;
  wire _2_;
  input a;
  wire a;
  input b;
  wire b;
  output y;
  wire y;
  sky130_fd_sc_hd__or2_0 _3_ (
    .A(_1_),
    .B(_0_),
    .X(_2_)
  );
  assign _1_ = b;
  assign _0_ = a;
  assign y = _2_;
endmodule
  ```
-->
<!--
________________________________________________________________________________________________________________________
  
  **2. Flattened**  
  To flatten the hierarchical design, the command **flatten** is used following which we can write the netlist, as shown below:  
  ```
  flatten
  write_verilog -noattr multiple_modules_flat.v
  show -stretch multiple_modules 
  ```
    
  Synthesis result after flattening:  
  ![day2_multiple_modules_flat](/docs/images/day2_multiple_modules_flat.png)
  <br />
  <br />
-->
<!--
  Corresponding Netlist - multiple_modules_flat.v:  
  ```
  /* multiple_modules_flat.v
  /* Generated by Yosys 0.34+43 (git sha1 d21c464ae, gcc 9.4.0-1ubuntu1~20.04.2 -fPIC -Os) */

module multiple_modules(a, b, c, y);
  wire _0_;
  wire _1_;
  wire _2_;
  wire _3_;
  wire _4_;
  wire _5_;
  input a;
  wire a;
  input b;
  wire b;
  input c;
  wire c;
  wire net1;
  wire \u1.a ;
  wire \u1.b ;
  wire \u1.y ;
  wire \u2.a ;
  wire \u2.b ;
  wire \u2.y ;
  output y;
  wire y;
  sky130_fd_sc_hd__and2_0 _6_ (
    .A(_1_),
    .B(_0_),
    .X(_2_)
  );
  sky130_fd_sc_hd__or2_0 _7_ (
    .A(_4_),
    .B(_3_),
    .X(_5_)
  );
  assign _4_ = \u2.b ;
  assign _3_ = \u2.a ;
  assign \u2.y  = _5_;
  assign \u2.a  = net1;
  assign \u2.b  = c;
  assign y = \u2.y ;
  assign _1_ = \u1.b ;
  assign _0_ = \u1.a ;
  assign \u1.y  = _2_;
  assign \u1.a  = a;
  assign \u1.b  = b;
  assign net1 = \u1.y ;
endmodule
  ```
-->
<!--
  **Comparing the netlist generated for hierarchical and flat synthesis:**  
  ![multiple_modules_hierarchical_vs_flat](/docs/images/multiple_modules_hierarchical_vs_flat.png)
________________________________________________________________________________________________________________________
  
### Lab 6: Various Flip-Flop Designs
Here, we will take a look at the simulation and synthesis of different flip-flops.  
<br>
  **1. DFF with Asynchronous Reset**  
  ```
  module dff_asyncres ( input clk ,  input async_reset , input d , output reg q );
  always @ (posedge clk , posedge async_reset)
  begin
	  if(async_reset)
		  q <= 1'b0;
	  else	
		  q <= d;
  end
  endmodule
  ```
  
  **NOTE :**
    To synthesize flip-flops using Ysosys, we need to provide an additional command ```dfflibmap``` so as to map the internal flip-flop cells to the flip-flop cells in the technology
library specified in the given liberty file.  
  
  ```
  # For example, to perform synthesis of the dff_asyncres module for the sky130 library:
  
  read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib 
  read_verilog dff_asyncres.v 
  synth -top dff_asyncres 
  dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib 
  abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib 
  show
  ```
  
  **Behavioral Simulation:**  
  | Reset Deassertion | Reset Assertion |
  |-------------------|-----------------|
  | ![dff_asyncres_reset_deassertion](/docs/images/dff_asyncres_reset_deassertion.png) | ![dff_asyncres_reset_asserted](/docs/images/dff_asyncres_reset_asserted.png) |
  
  **Synthesis Result:**
  ![dff_asyncres](/docs/images/dff_asyncres.png)  
_________________________________________________________________________________________________________  
  **2. DFF with Synchronous Reset**  
  ```
  module dff_syncres ( input clk , input async_reset , input sync_reset , input d , output reg q );
  always @ (posedge clk )
  begin
	  if (sync_reset)
		  q <= 1'b0;
	  else	
		  q <= d;
  end
  endmodule
  ```
    
  **Behavioral Simulation:**  
  | Reset Deassertion | Reset Assertion |
  |-------------------|-----------------|
  | ![dff_syncres_reset_deassertion](/docs/images/dff_syncres_reset_deassertion.png) | ![dff_syncres_reset_assertion](/docs/images/dff_syncres_reset_assertion.png) |
    
  **Synthesis Result:**
  ![dff_syncres](/docs/images/dff_syncres.png)  
_________________________________________________________________________________________________________  
  **3. DFF with both Asynchronous & Synchronous Reset**  
  ```
  module dff_asyncres_syncres ( input clk , input async_reset , input sync_reset , input d , output reg q );
  always @ (posedge clk , posedge async_reset)
  begin
	  if(async_reset)
		  q <= 1'b0;
	  else if (sync_reset)
		  q <= 1'b0;
	  else	
		  q <= d;
  end
  endmodule
  ```
    
  **Behavioral Simulation:**  
  ![dff_asyncres_syncres_waves](/docs/images/dff_asyncres_syncres_waves.png)

    
  **Synthesis Result:**
  ![dff_asyncres_syncres](/docs/images/dff_asyncres_syncres.png)
_________________________________________________________________________________________________________  
  
### Lab 7: Some interesting synthesis optimizations involving multipliers  
<br>
Here, we will take a look at the synthesis of two special cases of multipliers where no cells are used at all.  
<br>  
<br>

  **1. Multiply by 2**  
  The input is an n-bit binary number and the output is twice the input.  
  ```
  i.e., output[n:0] = 2 * input[n-1 : 0]  

  This is equivalent to left-shifting the input by 1 bit position with trailing 0 added in the LSB.
  In this case also, we can see that there aren't any cells needed to realize this logic,
  and the input to output interconnections involve just wires.  
  ```
  <br>
  
  Netlist generated by Yosys:
  ```
  module mul2(a, y);
    input [2:0] a;
    wire [2:0] a;
    output [3:0] y;
    wire [3:0] y;
    assign y = { a, 1'h0 };
  endmodule
  ```

  Synthesis result:  
  ![mult_2](/docs/images/mult_2.png)  
_________________________________________________________________________________________________________  
<br>

  **2. Multiply a 3-bit number by 9**  
  The input is a 3-bit binary number and the output is defined to be 9 * input.  
  ```
  i.e., output[5:0] = 9 * input[2:0]

  In other words,  
      output[5:0] = 4'b1001 * input[2:0]  
      output[5:0] = {input[2:0], input[2:0]}
  
  In this case also, we can see that there aren't any cells needed to realize this logic,
  and the input to output interconnections involve just wires.  
  ```
  <br>
  
  Netlist generated by Yosys:
  ```
  module mult8(a, y);
    input [2:0] a;
    wire [2:0] a;
    output [5:0] y;
    wire [5:0] y;
    assign y = { a, a };
  endmodule
  ```


  Synthesis result:  
  ![mult8](/docs/images/mult8.png)  
_________________________________________________________________________________________________________  
<br>

## Day 3
### Combinational Logic Optimizations  
The combinational logic is simplified to the most optimized form which is efficient in terms of area & power savings.  
**1. Constant Propagation** : This is a direct optimization method wherein the Boolean expression of the synthesized logic is simplified if any of the inputs are "a constant" and subsequently some of the logic gate outputs also propagate a constant value always.  
**2. Boolean Logic Optimization** : The various Boolean expression optimization techniques like K-maps (graphical), Quine-McLusky, reduction to standard SOP/ POS forms best suited for the cell library/ technology etc.  
<br>

**NOTE :** The command to perform logic optimization in Yosys is ```opt_clean```.  
Additionally, for a hierarchical design involving multiple sub-modules, the design must be flattened by running the ```flatten``` command before executing the ```opt_clean``` command.
```
USAGE:
After the synth -top <module_name> command is executed, do:
    opt_clean -purge

This command identifies wires and cells that are unused and removes them.
The additional switch, purge also removes the internal nets if they have a public name.
```
```
# Example showing the sequence of commands to perform combinational logic optimization using Yosys
# on module opt_check in opt_check.v:
    read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib 
    read_verilog opt_check.v 
    synth -top opt_check 
    opt_clean -purge
    abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib 
    show
```

#### Lab 8: Example 1: opt_check.v 
```
module opt_check (input a , input b , output y);
    assign y = a?b:0;
endmodule

# We can see by direct simplification that:
#      y = a*b + a_bar*0 = ab
# i.e, a 2-input AND Gate. 
```
<br>

Synthesis Result:  
![opt_check](/docs/images/opt_check.png)  
<br>
_________________________________________________________________________________________________________  

#### Lab 8: Example 2: opt_check2.v
```
module opt_check2 (input a , input b , output y);
    assign y = a?1:b;
endmodule

# Boolean simplification:
#      y = a + a_bar*b
#        = ab + a*b_bar + a_bar*b
#        = (ab + ab) + a*b_bar + a_bar*b
#        = (ab + a*b_bar) + (ab + a_bar*b)
#        = a + b 
# i.e, a 2-input OR Gate. 
```
<br>

Synthesis Result:  
_The cell library already seems to have an OR gate available as the synthesis result is an OR gate itself and not a NAND-realization of the OR to avoid the stacked PMOS as shown in the demo videos_  
![opt_check2](/docs/images/opt_check2.png)  
<br>
_________________________________________________________________________________________________________  

#### Lab 8: Example 3: opt_check3.v
```

module opt_check3 (input a , input b, input c , output y);
    assign y = a?(c?b:0):0;
endmodule

# Boolean simplification:
#      y = a* (bc) + a_bar*0
#        = abc
# i.e, a 3-input AND Gate.
```
<br>

Synthesis Result:  
![opt_check3](/docs/images/opt_check3.png)  
<br>
_________________________________________________________________________________________________________  

#### Lab 8: Example 4: opt_check4.v
```

module opt_check4 (input a , input b , input c , output y);
    assign y = a?(b?(a & c):c):(!c);
endmodule

# Boolean simplification:
#      y = a*(abc + b_bar*c) + a_bar*c_bar
#        = abc + a*b_bar*c + a_bar*c_bar
#        = abc + a*b_bar*c + (a_bar*b*c_bar + a_bar*b_bar*c_bar)
#        = ac + a_bar*c_bar
#        = 
# i.e, a 2-input XNOR Gate.
```
<br>

Synthesis Result:  
![opt_check4](/docs/images/opt_check4.png)  
<br>
_________________________________________________________________________________________________________  

#### Lab 8: Example 5: multiple_module_opt.v
```
module sub_module1(input a , input b , output y);
    assign y = a & b;
endmodule

module sub_module2(input a , input b , output y);
    assign y = a^b;
endmodule

module multiple_module_opt(input a , input b , input c , input d , output y);
    wire n1,n2,n3;

    sub_module1 U1 (.a(a) , .b(1'b1) , .y(n1));
    sub_module2 U2 (.a(n1), .b(1'b0) , .y(n2));
    sub_module2 U3 (.a(b), .b(d) , .y(n3));

    assign y = c | (b & n1); 
endmodule
```
<br>

Synthesis Result:  
![multiple_module_opt](/docs/images/multiple_module_opt.png)  
<br>
_________________________________________________________________________________________________________  

#### Lab 8: Example 6: multiple_module_opt2.v
```
module sub_module(input a , input b , output y);
    assign y = a & b;
endmodule

module multiple_module_opt2(input a , input b , input c , input d , output y);
    wire n1,n2,n3;

    sub_module U1 (.a(a) , .b(1'b0) , .y(n1));
    sub_module U2 (.a(b), .b(c) , .y(n2));
    sub_module U3 (.a(n2), .b(d) , .y(n3));
    sub_module U4 (.a(n3), .b(n1) , .y(y));
endmodule
```
<br>

Synthesis Result:  
![multiple_module_opt2](/docs/images/multiple_module_opt2.png)  
<br>

_________________________________________________________________________________________________________  

### Sequential Logic Optimizations
**1. Constant Propagation** : Optimization technique used when a constant value is propagated through a flip-flop -- i.e., irrespective of the state of the triggering signals (CLK, Reset, Set), there are no transitions in the flip-flop output.  
<br>

***[Other Advanced optimization methods not covered by examples in detail:]***  
**2. State optimization** : Unused states in the sequential design are optimized and/or the total states needed in the FSM are minimized.  
**3. Cloning** : This is a physically-aware (PnR-aware) optimization method where some of the flops in the design are cloned/ duplicated so that the timing can be met post-PnR for the timing arcs involved (provided there is already some minimum positive slack available).  
**4. Retming** : The pipelining flops in the design are placed optimally so that the combinational delay at each pipeline stage is more or less equalized so that the maximum clock frequency can be increased.  
<br>

```
# Example showing the sequence of commands to perform combinational logic optimization using Yosys
# on module dff_const1 in dff_const1.v:
    read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib 
    read_verilog dff_const1.v 
    synth -top dff_const1
    opt_clean -purge
    dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib 
    abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib 
    show
```

#### Lab 9: Example 1: dff_const1.v 
```
module dff_const1(input clk, input reset, output reg q);
    always @(posedge clk, posedge reset)
    begin
	    if(reset)
                q <= 1'b0;
	    else
                q <= 1'b1;
    end
endmodule
```
In this example, no optimization is possible as the flop output, q changes.  

<br>

| Behavioral Simulation | ![dff_const1_waves](/docs/images/dff_const1_waves.png)  |
|-----------------------|------------------|
| **Synthesis Result** | ![dff_const1](/docs/images/dff_const1.png) |  
<br>

_________________________________________________________________________________________________________

#### Lab 9: Example 2: dff_const2.v 
```
module dff_const2(input clk, input reset, output reg q);
    always @(posedge clk, posedge reset)
    begin
    if(reset)
        q <= 1'b1;
    else
        q <= 1'b1;
    end
endmodule
```
Here, the the flip-flop output, q remains constant at 1 irrespective of the other signals in the sensitivity list.  
Thus the realization does not need any cells and q is connected to 1'b1.  

<br>

| Behavioral Simulation | ![dff_const2_waves](/docs/images/dff_const2_waves.png) |
|-----------------------|------------------|
| **Synthesis Result** | ![dff_const2](/docs/images/dff_const2.png) |
<br>

_________________________________________________________________________________________________________  

#### Lab 9: Example 3: dff_const3.v 
```
module dff_const3(input clk, input reset, output reg q);
    reg q1;

    always @(posedge clk, posedge reset)
    begin
        if(reset)
            begin
	         q <= 1'b1;
                q1 <= 1'b0;
            end
        else
	     begin
                 q1 <= 1'b1;
	          q <= q1;
	     end
    end
endmodule
```
Here, both q1 & q have transitions and thus cannot be optimized further.  
So the design will have two DFFs.  
<br>

| Behavioral Simulation | ![dff_const3_waves](/docs/images/dff_const3_waves.png) |
|-----------------------|------------------|
| **Synthesis Result** | ![dff_const3](/docs/images/dff_const3.png) |
<br>

_________________________________________________________________________________________________________  

#### Lab 9: Example 4: dff_const4.v 
```
module dff_const4(input clk, input reset, output reg q);
    reg q1;
    
    always @(posedge clk, posedge reset)
    begin
        if(reset)
            begin
                q <= 1'b1;
                q1 <= 1'b1;
            end
        else
            begin
                q1 <= 1'b1;
                q <= q1;
            end
        end
endmodule
```
In this example, both q1 & q remain constant at 1'b1.  
Thus, the design can be optimized to have only wires. Further, q1 being an internal net can also be removed.  
<br>

| Behavioral Simulation | ![dff_const4_waves](/docs/images/dff_const4_waves.png) |
|-----------------------|------------------|
| **Synthesis Result** | ![dff_const4](/docs/images/dff_const4.png) |
<br>

_________________________________________________________________________________________________________  

#### Lab 9: Example 5: dff_const5.v 
```
module dff_const5(input clk, input reset, output reg q);
    reg q1;
    
    always @(posedge clk, posedge reset)
    begin
        if(reset)
            begin
                q <= 1'b0;
                q1 <= 1'b0;
            end
        else
            begin
                q1 <= 1'b1;
                q <= q1;
            end
        end
endmodule
```
<br>

| Behavioral Simulation | ![dff_const5_waves](/docs/images/dff_const5_waves.png) |
|-----------------------|------------------|
| **Synthesis Result** | ![dff_const5](/docs/images/dff_const5.png) |
<br>

_________________________________________________________________________________________________________  

#### Lab 9: Example 6: counter_opt.v 
```
module counter_opt (input clk , input reset , output q);
    reg [2:0] count;
    assign q = count[0];
    
    always @(posedge clk ,posedge reset)
    begin
        if(reset)
            count <= 3'b000;
        else
            count <= count + 1;
    end
endmodule
```
This design serves as an example for Sequential logic optimization with designs having unused outputs.  
Although we have a 3-bit up counter in the RTL design, only the LSB, count[0:0] is used for generating the output signal, q.  
Since count[0:0] toggles every clock cycle, there really is a need for only one flip-flop in the circuit.  
In other words, the synthesis output does not have a 3-bit up counter and its associated count incrementing logic.  
<br>

| Behavioral Simulation | ![counter_opt_waves](/docs/images/counter_opt_waves.png) |
|-----------------------|------------------|
| **Synthesis Result w/o opt_clean switch** | ![counter_opt_without_optimization](/docs/images/counter_opt_without_optimization.png) |
| **Synthesis Result with opt_clean switch** | ![counter_opt](/docs/images/counter_opt.png) |

<br>

_________________________________________________________________________________________________________  

#### Lab 9: Example 7: counter_opt2.v 
```
module counter_opt (input clk , input reset , output q);
    reg [2:0] count;
    assign q = (count[2:0] == 3'b100);

    always @(posedge clk ,posedge reset)
    begin
        if(reset)
            count <= 3'b000;
        else
            count <= count + 1;
        end
endmodule
```
In this design, we have a 3-bit up counter and all the bits in the counter state value, count[2:0] are used for generating the output signal, q.  
q = 1, when count[2:0] = 3'b100  
So when this design is synthesized, we expect 3 DFF instantiations to be present along with the count incrementing logic and the logic to generate, q.  

<br>

| Behavioral Simulation | ![counter_opt2_waves](/docs/images/counter_opt2_waves.png) |
|-----------------------|------------------|
| **Synthesis Result** | ![counter_opt2_with_optimizations](/docs/images/counter_opt2_with_optimizations.png) |
<br>

_________________________________________________________________________________________________________  

## Day 4
### Gate Level Simulation (GLS)
  * _Gate Level_ refers to the netlist view of a design after the synthesis has been performed.
  * RTL simulations are pre-synthesis, while GLS is post-synthesis - i.e., in RTL simulations, the Device Under Test (DUT) is the RTL design itself while in GLS, the DUT is the netlist generated after synthesis.
  * The RTL code and the generated netlist are logically equivalent (well, supposed to be!)  and hence the same testbenches can be used to verify both.
  * Although it is expected that the generated netlist has the same logical correctness as the RTL design, there can sometimes be mismatches between the RTL-level simulation and the sythesized design (Synthesis - Simulation mismatch) and thus arises the need to run GLS to help identify such scenarios and fix them to ensure the logical correctness post-synthesis as well.

To run GLS, we need to provide the Gate level netlist, the testbench and the Gate Level verilog models to the simulator.  
GLS can be run in different delay modes:
   1. Functional validation (zero delay similar to RTL sim): if the Gate Level verilog models do not have the timing information for various corners, we can only verify the functional correctness of the design by running GLS.
   2. Full Timing validation: if the Gate level verilog models have the necessary timing information, both the functional correctness and the timing behaviour can be verified by GLS.  
<br>

**GLS using iverilog**  
The following block diagram shows the GLS flow using iverilog:  
![Day4_GLS_using_iverilog](/docs/images/Day4_GLS_using_iverilog.png)  
<br>

The Gate level verilog model(s) need to be provided as shown below to do GLS using iverilog:
```
Syntax:
    iverilog <path-to-gate-level-verilog-model(s)> <netlist_file.v> <tb_top.v>

Example using ternary_operator_mux_netlist.v:
    iverilog ../my_lib/verilog_model/primitives.v ../my_lib/verilog_model/sky130_fd_sc_hd.v ternary_operator_mux_netlist.v tb_ternary_operator_mux.v
```
<br>

### Synthesis - Simulation mismatch
Some of the common reasons for Synthesis - Simulation mismatch (mismatch between pre- and post-synthesis simulations) :  
  * Incomplete sensitivity list
  * Use of blocking assignments inside always block vs. non-blocking assignments
    * Blocking assignments ("=") inside always block are executed sequentially by the simulator.
    * The RHS of non-blocking assignments ("<=") are evaluated first and then assigned to the LHS at the same simulation clock tick by the simulator. 
    * Synthesis will yield the same circuit with blocking and non-blocking assignments, with the synthesis output being that of the non-blocking case for both.
    * Hence, if the RTL was written assuming one functionality using blocking assignments, a simulation mismatch can occur in GLS.
  * Non-standard verilog coding
<br>

### Lab 10: GLS Synthesis - Sumulation mismatch - Example 1: ternary_operator_mux.v
```
module ternary_operator_mux (input i0 , input i1 , input sel , output y);
    assign y = sel ? i1 : i0;
endmodule
```
<br>

| RTL Simulation | ![ternary_operator_mux_waves](/docs/images/ternary_operator_mux_waves.png) |
|-----------------------|------------------|
| **GLS** | ![ternary_operator_mux_waves_GLS](/docs/images/ternary_operator_mux_waves_GLS.png) |
| **Synthesis Result** | ![ternary_operator_mux](/docs/images/ternary_operator_mux.png) |
<br>

_________________________________________________________________________________________________________  

### Lab 10: GLS Synthesis - Sumulation mismatch - Example 2: bad_mux.v
```
module bad_mux (input i0 , input i1 , input sel , output reg y);
    always @ (sel)
    begin
        if(sel)
            y <= i1;
        else
            y <= i0;
    end
endmodule
```
<br>

| RTL Simulation | ![bad_mux_rtl_waves](/docs/images/bad_mux_rtl_waves.png) |
|-----------------------|------------------|
| **GLS** | ![bad_mux_waves_GLS](/docs/images/bad_mux_waves_GLS.png) |
| **Synthesis Result** | ![bad_mux_rtl](/docs/images/bad_mux_rtl.png) |
<br>

In this case, we can clearly see that there is a mismatch in the simulation between pre and post-synthesis.  
The pre-synthesis simulation shows a behavior resembling that of a posedge triggered DFF with the "sel" signal acting as the CLK and the "i1" acting as the D input.  
The synthesis result, however, is a 2-input mux and not a DFF.  
In fact, yosys actually throws a warning message about the possible omission of signals from the sensitivity list assuming a purely combinational circuit.  
<br>

_Yosys warning about missing signals in sensitivity list_  
![yosys_read_verilog_message](/docs/images/yosys_read_verilog_message.png)
<br>

_________________________________________________________________________________________________________  

### Lab 10: GLS Synthesis - Sumulation mismatch - Example 3: blocking_caveat.v
```
module blocking_caveat (input a , input b , input  c, output reg d);
    reg x;

    always @ (*)
    begin
        d = x & c;
        x = a | b;
    end
endmodule

```
<br>

In this case, there is a mismatch in the simulation results between pre and post-synthesis due to the use of blocking assignments. 
Assuming we wanted to implement just a combinational logic with output, d = (a + b) * c:
  * In the RTL sim, the blocking assignments make it seem as if there is a flop in the design.
  * While in the GLS, the design is synthesized to a O2A1 gate implementing d = (a + b) * c, with no flops inferred, thus resulting in the mismatch.
  
| RTL Simulation | ![blocking_caveat_waves_RTL](/docs/images/blocking_caveat_waves_RTL.png) |
|-----------------------|------------------|
| **GLS** | ![blocking_caveat_waves_GLS](/docs/images/blocking_caveat_waves_GLS.png) |
| **Synthesis Result** | ![blocking_caveat](/docs/images/blocking_caveat.png) |

<br>

_________________________________________________________________________________________________________  

## Day 5
### Introduction to RISC-V ISA and GNU Compiler Toolchain

RISC-V is an open standard instruction set architecture based on established reduced instruction set computer(RISC) principles. It was first started by Prof. Krste Asanović and graduate students Yunsup Lee and Andrew Waterman in May 2010 as part of the Parallel Computing Laboratory, at UC Berkeley. Unlike most other ISA designs, the RISC-V ISA is provided under open source licenses that do not require fees to use, which provides it a huge edge over other commercially available ISAs. It is a simple, stable, small standard base ISA with extensible ISA support, that has been redefining the flexibility, scalability, extensibility, and modularity of chip designs.  

#### ISA base and extensions
RISC-V has a modular design, consisting of alternative base parts, with added optional extensions. The ISA base and its extensions are developed in a collective effort between industry, the research community and educational institutions. The base specifies instructions (and their encoding), control flow, registers (and their sizes), memory and addressing, logic (i.e., integer) manipulation, and ancillaries. The base alone can implement a simplified general-purpose computer, with full software support, including a general-purpose compiler.  

The standard extensions are specified to work with all of the standard bases, and with each other without conflict.  
![D5_RISC-V_ISA_Base_and_Extensions](/docs/images/D5_RISC-V_ISA_Base_and_Extensions.png)  
<br>

The RISC-V ISA is defined as a Base integer ISA, which is the basic necessity for the implemetation of any CPU core. In addition to that it also has optional extensions to the base ISA. The base RISC-V ISA has a little-endian memory system. The standard is maintained by the RISC-V foundation.  

#### RISC-V Instruction Formats
![D5_32-bit_RISC-V_instruction_formats](/docs/images/D5_32-bit_RISC-V_instruction_formats.png)  

References:
  1) [https://en.wikipedia.org/wiki/RISC-V](https://en.wikipedia.org/wiki/RISC-V)
  2) [RISC-V Technical Specifications](https://wiki.riscv.org/display/HOME/RISC-V+Technical+Specifications)
  3) [RISC-V MYTH Workshop](https://github.com/RISCV-MYTH-WORKSHOP/RISC-V-CPU-Core-using-TL-Verilog/blob/master/README.md#introduction-to-risc-v-isa)

#### RISC-V ISA Simulator and Compiler toolchain setup
  * The RISC-V ISA simulator & GNU Compiler toolchain can be installed by running the following script from the terminal:
    [run.sh](https://github.com/kunalg123/riscv_workshop_collaterals/blob/master/run.sh)
    <br>

  * The following GitHub repo contains sample programs and the verilog code for a RV32I processor core (PicoRV32):
    [RISC-V Workshop Collaterals](https://github.com/kunalg123/riscv_workshop_collaterals.git)
    <br>

  * More information on how to use the toolchain to compile a source file, simulation of the object file and using the interactive debug mode can be found in the README page of the Spike RISC-V simulator GitHub repository:
    [Spike RISC-V ISA Simulator](https://github.com/riscv-software-src/riscv-isa-sim.git)
    <br>

  * More information on the RISC-V specific compiler options like ```-march```, ```-mabi```, and ```-mtune``` can be found in the following links:
      1) [https://gcc.gnu.org/onlinedocs/gcc/RISC-V-Options.html](https://gcc.gnu.org/onlinedocs/gcc/RISC-V-Options.html)
      2) [https://www.sifive.com/blog/all-aboard-part-1-compiler-args](https://www.sifive.com/blog/all-aboard-part-1-compiler-args)
      3) [https://five-embeddev.com/toolchain/2019/06/26/gcc-targets/](https://five-embeddev.com/toolchain/2019/06/26/gcc-targets/)
      4) [https://github.com/riscv-non-isa/riscv-toolchain-conventions](https://github.com/riscv-non-isa/riscv-toolchain-conventions)

### Labs 1,2: Write a C program to compute the sum of first N natural numbers, compile using RISC-V GCC, simulate using Spike RISC-V ISA Simulator and disassemble to view the assembly code  
**C Program:**
```
#include <stdio.h>

int main() {
    int n=100, i, sum = 0;
    for (i = 1; i <= n; ++i) {
        sum += i;
    }
    printf("Sum of first %d natural numbers = %d\n", n, sum);
    return 0;
}
```

**Compilation command:**
```
riscv64-unknown-elf-gcc -O1 -mabi=lp64 -march=rv64i -o sum1toN.o sum1toN.c
    where,
        -mabi=ABI-string option specifies the ABI (Application Binary Interface) to be used.
        -march=ISA-string option specifies the RISC-V ISA for which the object code is to be generated.
        -O<number>, -Ofast, -Os, -Og etc. specify the optimize option to be used by the compiler.
```
Spike simulation output:  
![D5_sum1toN_compile_simulate](/docs/images/D5_sum1toN_compile_simulate.png)
<br>

**Disassemble command:**
```
riscv64-unknown-elf-objdump -d sum1toN.o
    where,
        -d, --disassemble flag displays the assembler contents of the executable sections.
```
Output:  
![D5_disassemble](/docs/images/D5_disassemble.png)
<br>

Comparing the generated assembly code for main function with -O1 vs -Ofast compiler options:
| -O1 | -Ofast |
|-----------------------|------------------|
| ![D5_disassemble_sum1toN_O1](/docs/images/D5_disassemble_sum1toN_O1.png) | ![D5_disassemble_sum1toN_Ofast](/docs/images/D5_disassemble_sum1toN_Ofast.png) |
<br>

### Lab 3: Use the Interactive Debug mode in Spike RISC-V ISA sim to observe the execution of the program with -Ofast flag  
A small example of how to use the debug mode can be found in the following page: [Interactive Debug Mode](https://github.com/riscv-software-src/riscv-isa-sim#interactive-debug-mode)  

To enter the interactive debug mode, launch spike with ```-d``` option:  
```
Example:
spike -d pk sum1toN.o
```
<br>

_Snapshot showing usage of Spike Interactive Debug Mode_
![D5_Spike_InteractiveDebugMode](/docs/images/D5_Spike_InteractiveDebugMode.png)
<br>

```
Interactive commands:
reg <core> [reg]                # Display [reg] (all if omitted) in <core>
freg <core> <reg>               # Display float <reg> in <core> as hex
fregh <core> <reg>              # Display half precision <reg> in <core>
fregs <core> <reg>              # Display single precision <reg> in <core>
fregd <core> <reg>              # Display double precision <reg> in <core>
vreg <core> [reg]               # Display vector [reg] (all if omitted) in <core>
pc <core>                       # Show current PC in <core>
priv <core>                     # Show current privilege level in <core>
mem [core] <hex addr>           # Show contents of virtual memory <hex addr>
                                  in [core] (physical memory <hex addr> if omitted)
str [core] <hex addr>           # Show NUL-terminated C string at virtual address <hex addr>
                                  in [core] (physical address <hex addr> if omitted)
dump                            # Dump physical memory to binary files
mtime                           # Show mtime
mtimecmp <core>                 # Show mtimecmp for <core>
until reg <core> <reg> <val>    # Stop when <reg> in <core> hits <val>
untiln reg <core> <reg> <val>   # Run noisy and stop when <reg> in <core> hits <val>
until pc <core> <val>           # Stop when PC in <core> hits <val>
untiln pc <core> <val>          # Run noisy and stop when PC in <core> hits <val>
until mem [core] <addr> <val>   # Stop when virtual memory <addr>
                                  in [core] (physical address <addr> if omitted) becomes <val>
untiln mem [core] <addr> <val>  # Run noisy and stop when virtual memory <addr>
                                  in [core] (physical address <addr> if omitted) becomes <val>
while reg <core> <reg> <val>    # Run while <reg> in <core> is <val>
while pc <core> <val>           # Run while PC in <core> is <val>
while mem [core] <addr> <val>   # Run while virtual memory <addr>
                                  in [core] (physical memory <addr> if omitted) is <val>
run [count]                     # Resume noisy execution (until CTRL+C, or [count] insns)
r [count]                         Alias for run
rs [count]                      # Resume silent execution (until CTRL+C, or [count] insns)
quit                            # End the simulation
q                                 Alias for quit
help                            # This screen!
h                                 Alias for help
Note: Hitting enter is the same as: run 1
```
_________________________________________________________________________________________________________  
<br>

## Day 6
### Introduction to ABI and basic verification flow
In computer software, an application binary interface (ABI) is an interface between two binary program modules. Often, one of these modules is a library or operating system facility, and the other is a program that is being run by a user.
An ABI defines how data structures or computational routines are accessed in machine code, which is a low-level, hardware-dependent format.  
_Reference:_ [Application binary interface](https://en.wikipedia.org/wiki/Application_binary_interface)  
<br>

RISC-V CPU architecture has 32 registers. Application programmer, can access each of these 32 registers through its ABI name; for example, if we need to move the stack pointer, the command ```addi sp, sp, -16``` will decrement the SP by 0x10, where "sp" is the ABI name of stack pointer. The following table shows the ABI Integer register calling convention :  
![RV64I_IntegerRegisterConvention](/docs/images/RV64I_IntegerRegisterConvention.png)
<br>

For more detailed information, refer to the [RISC-V ABI Specification v1.0](https://drive.google.com/file/d/1Ja_Tpp_5Me583CGVD-BIZMlgGBnlKU4R/view)  

### Lab 1: Rewrite the program to find the sum of first N natural numbers utilizing ABI function calls

C Program: 1to9_custom.c
```
#include <stdio.h>

extern int load(int x, int y); 

int main() {
	int result = 0;
       	int count = 100;
    	result = load(0x0, count+1);
    	printf("Sum of number from 1 to %d is %d\n", count, result); 
}
```
<br>

Assembly program: load.s
```
.section .text
.global load
.type load, @function

load:
	add 	a4, a0, zero //Initialize sum register a4 with 0x0
	add 	a2, a0, a1   // store count of 10 in register a2. Register a1 is loaded with 0xa
                             // (decimal 10) from main program
	add	a3, a0, zero // initialize intermediate sum register a3 by 0
loop:	add 	a4, a3, a4   // Incremental addition
	addi 	a3, a3, 1    // Increment intermediate register by 1	
	blt 	a3, a2, loop // If a3 is less than a2, branch to label named <loop>
	add	a0, a4, zero // Store final result to register a0 so that it can be read by
                             // main program
	ret
```
<br>

The program can be compiled using the gcc and simulated using Spike as follows:
![D6_1to9_custom_ABI](/docs/images/D6_1to9_custom_ABI.png)
<br>

Disassembly of object code of above progam:
![D6_ABI_Disassembly](/docs/images/D6_ABI_Disassembly.png)
![D6_ABI_load_loop_subroutines](/docs/images/D6_ABI_load_loop_subroutines.png)
<br>

### Lab 2: Run the above C program on a RISC-V CPU
For this exercise, we will use the design files from the following GitHub repository: [https://github.com/kunalg123/riscv_workshop_collaterals.git](https://github.com/kunalg123/riscv_workshop_collaterals.git)  
Execute the following file from shell:  

rv32im.sh:
```
riscv64-unknown-elf-gcc -c -mabi=ilp32 -march=rv32im -o 1to9_custom.o 1to9_custom.c 
riscv64-unknown-elf-gcc -c -mabi=ilp32 -march=rv32im -o load.o load.S

riscv64-unknown-elf-gcc -c -mabi=ilp32 -march=rv32im -o syscalls.o syscalls.c
riscv64-unknown-elf-gcc -mabi=ilp32 -march=rv32im -Wl,--gc-sections -o firmware.elf load.o 1to9_custom.o syscalls.o -T riscv.ld -lstdc++
chmod -x firmware.elf
riscv64-unknown-elf-gcc -mabi=ilp32 -march=rv32im -nostdlib -o start.elf start.S -T start.ld -lstdc++
chmod -x start.elf
riscv64-unknown-elf-objcopy -O verilog start.elf start.tmp
riscv64-unknown-elf-objcopy -O verilog firmware.elf firmware.tmp
cat start.tmp firmware.tmp > firmware.hex
python3 hex8tohex32.py firmware.hex > firmware32.hex
rm -f start.tmp firmware.tmp
iverilog -o testbench.vvp testbench.v picorv32.v
chmod -x testbench.vvp
vvp -N testbench.vvp
```

Basically what we are doing here is:
  * Our objective is to use run the program as a testbench on the PicoRV32 RISC-V CPU processor design coded in the picorv32.v verilog file.
  * For this, all the source files used are compiled into object code using gcc with rv32im as the target RISC-V ISA. Source file(s) include:
    * File(s) to perform the required CPU initialization
    * File(s) that define the various system calls used
    * File(s) containing the actual user program 
  * Then, the various object files are linked together into an ELF file using gcc
  * The ELF file is then converted into a hex verilog memory file, ```firmware.hex``` using riscv64-unknown-elf-objcopy
  * These 8-bit hex files are converted into 32-bit format using a python script, ```hex8tohex32.py```
  * Finally, a functional simulation is launched using iverilog, where the testbench loads the firmware.hex into the PicoRV32 CPU core for execution

![D6_Lab_firmware_iverilog_tb_simulation](/docs/images/D6_Lab_firmware_iverilog_tb_simulation.png)
<br>

_________________________________________________________________________________________________________  
<br>

## Day 7
### Digital Logic with TL-Verilog and Makerchip
  
**TL-Verilog**  
Transaction-Level Verilog (TL-Verilog) is an extension to SystemVerilog that supports a new design methodology, called transaction-level design. A transaction, in this methodology, is an entity that moves through structures like pipelines, arbiters, and queues. A transaction might be a machine instruction, a flit of a packet, or a memory read/write. Transaction logic, like packet header decode or instruction execution, that operates on the transaction can be placed anywhere along the transaction’s flow. Tools produce the logic to carry signals through their flows to stitch the transaction logic.  
<br>

**Makerchip Platform**  
Makerchip is a free online environment provided by Redwood EDA for developing integrated circuits. The online platform can be used to code, compile, simulate and debug Verilog designs from a web browser. In addition to Verilog and synthesizable SystemVerilog, the platform provides support for Transaction-Level Verilog (TL-Verilog).  

The Makerchip IDE also provides various tutorials and examples (inside Learn menu in the main window) to help learn the new concepts and constructs in TL-Verilog quickly.  

_References:_
  1) [https://www.redwoodeda.com/tl-verilog](https://www.redwoodeda.com/tl-verilog)
  2) [https://www.tl-x.org](https://www.tl-x.org/)
  3) [Top-Down Transaction-Level Design with TL-Verilog](https://arxiv.org/pdf/1811.01780.pdf)
  4) [Makerchip IDE](https://makerchip.com/)
  5) [Makerchip IDE Documentation](https://github.com/RISCV-MYTH-WORKSHOP/RISC-V-CPU-Core-using-TL-Verilog/tree/master/Documentation/Makerchip_IDE)

In this session, we will learn the concepts and syntax of TL-Verilog by implementing basic combinational and sequential logic using the same in Makerchip.
  1) Combinational logic
  2) Sequential logic
  3) Pipelined logic
  4) Validity
  
#### Combinational Logic
Implemented basic combinational logic elements and circuits like gates, muxes, vector adder, combinational calculator etc. using TL-Verilog in Makerchip.  
  1) AND2 Gate
     |![D7_AND2_Gate](/docs/images/D7_AND2_Gate.png)|
     |-|
  2) Vector Mux
     |![D7_VectorMux](/docs/images/D7_VectorMux.png)|
     |-|
  3) Adder
     |![D7_Vector_Addition](/docs/images/D7_Vector_Addition.png)|
     |-|
  4) Combinational Calculator
     |![D7_Combinational_Calculator](/docs/images/D7_Combinational_Calculator.png)|
     |-|

#### Sequential Logic
  1) Fibonacci Series
     |![D7_Fibonacci_Series](/docs/images/D7_Fibonacci_Series.png)|
     |-|
  2) Free-running Counter (starts from 1 and increments by 1 every cycle)
     |![D7_FR_Counter](/docs/images/D7_FR_Counter.png)|
     |-|
  3) Sequential Calculator
     |![D7_CombinationalCalculator](/docs/images/D7_CombinationalCalculator.png)|
     |-|
     |![D7_Sequential_Calculator](/docs/images/D7_Sequential_Calculator.png)|

#### Pipelined Logic
  1) Pythagorus Theorem with 3-stage pipeline
     |![D7_Pipelined_Pythagorus](/docs/images/D7_Pipelined_Pythagorus.png)|
     |-|
  2) Example showing the ease of pipelining/ retiming in TL-Verilog
     |![D7_Errors_in_comp_pipe](/docs/images/D7_Errors_in_comp_pipe.png)|
     |-|
  3) Sequential Calculator with counter
     |![D7_Seq_Calculator_with_Counter](/docs/images/D7_Seq_Calculator_with_Counter.png)|
     |-|
  4) 2-Cycle Sequential Calculator
     |![D7_2-Cycle_Calculator_BlockDiagram](/docs/images/D7_2-Cycle_Calculator_BlockDiagram.png)|
     |-|
     |![D7_2-Cycle_Calculator](/docs/images/D7_2-Cycle_Calculator.png)|

#### Validity
Using validity makes the design cleaner. Debugging and error checking also becomes easier.    
  1) 2-Cycle Calculator with Validity
     |![D7_2-Cycle_Calculator_with_Validity_Diagram](/docs/images/D7_2-Cycle_Calculator_with_Validity_Diagram.png)|
     |-|
     |![D7_2-Cycle_Calculator_with_Validity](/docs/images/D7_2-Cycle_Calculator_with_Validity.png)|
  2) Calculator with Single-value Memory
     |![D7_Calculator_with_SingleValue_Memory_Diagram](/docs/images/D7_Calculator_with_SingleValue_Memory_Diagram.png)|
     |-|
     |![D7_Calculator_with_SingleValue_Memory](/docs/images/D7_Calculator_with_SingleValue_Memory.png)|
_________________________________________________________________________________________________________  
<br>

## Day 8
### Basic RISC-V CPU Microarchitecture
Our objective is to implement a basic RISC-V CPU core (RV32I Base Instruction set except the instructions - FENCE, ECALL & EBREAK).  
The following diagrams show the general block diagram of the CPU and the initial implementation pipeline diagram using TL-Verilog:  
|**CPU Block Diagram**<br>  ![D8_CPU_BlockDiagram](/docs/images/D8_CPU_BlockDiagram.png)|
|-|  
|**TL-Verilog based implementation pipeline/ flow diagram**<br>  ![D8_Basic_CPU_Implementation](/docs/images/D8_Basic_CPU_Implementation.png)|
<br>

The implementation is done stage-by-stage verifying the functionality at each step in the Makerchip IDE. The following logic blocks are implemented and verified:  
  * Program Counter (PC)
  * Instruction Fetch from Instruction Memory (IMEM Read)
  * Instruction Decoder
    * Instruction Type Decode (I, R, S, B, U, J)
    * Instruction Immediate Value Decoding
    * Instruction Field Decoding
    * Complete Instruction Decoding
  * Register File Read
  * Arithmetic & Logic Unit (ALU)
  * Register File Write
  * Branch Instructions
    * (Modifying PC logic and adding additional logic to handle the Branch instructions)

|**Program Counter + Intruction Fetch**<br> ![D8_Instruction_Fetch](/docs/images/D8_Instruction_Fetch.png)|
|-|
|![D8_PC_+_InstrFetch](/docs/images/D8_PC_+_InstrFetch.png)|

|**Instruction Decoder**<br>  ![D8_InstrDecoder](/docs/images/D8_InstrDecoder.png)|
|-|
|RISC-V Opcode Map <br>  ![D8_RISC-V_OpcodeMap](/docs/images/D8_RISC-V_OpcodeMap.png)  <br>  
RISC-V Instruction Format <br>  ![D8_RISCV_ISA_Encoding](/docs/images/D8_RISCV_ISA_Encoding.png)  <br>  
RV32I ISA Encoding <br>  ![D8_RISCV_RV32I_ISA_Encoding](/docs/images/D8_RISCV_RV32I_ISA_Encoding.png)  <br>  
Instruction Type Decoding <br>  ![D8_RV32I_InstructionType_Decode](/docs/images/D8_RV32I_InstructionType_Decode.png)  <br>  
Immediate Value Decoding <br>  ![D8_ImmediateValue_Decoding](/docs/images/D8_ImmediateValue_Decoding.png)  <br>|

|**Register File Read**<br>  ![D8_RF_Read](/docs/images/D8_RF_Read.png)|
|-|
|Register File module interface <br>  ![D8_RF_Interface](/docs/images/D8_RF_Interface.png)  <br>|

|**ALU (only ADD, ADDI implemented for now)**  <br>  ![D8_ALU](/docs/images/D8_ALU.png)|
|-|

|**Register File Write**<br>  ![D8_RF_Write](/docs/images/D8_RF_Write.png)|
|-|

|**Branch Instruction Logic added**<br>  ![D8_Basic_RISC-V_CPU_Unpipelined](/docs/images/D8_Basic_RISC-V_CPU_Unpipelined.png)|
|-|
_________________________________________________________________________________________________________  
<br>

## Day 9
### Complete Pipelined RISC-V CPU Microarchitecture
Our RISC-V core from the previous day is still incomplete w.r.t the instructions implemented, and additionally we need to do pipelining and handling of the pipeline hazards.  
We need to do the following to complete the CPU Design:
  1) Pipeline the CPU, taking care of the data dependency & control flow hazards
  2) Complete the implementation of the remaining ALU instructions
  3) Implement DMEM & Load, Store instructions
  4) Implement the Unconditional Jump (JAL, JALR) instructions

|**Pipelining the RISC-V CPU Core ![D9_RISCV_Pipelined](/docs/images/D9_RISCV_Pipelined.png)|
|-|
<br>

#### Pipelining the CPU: Using 3-Cycle $valid signal
First, we will implement with a simplified 3-stage pipeline with using a 3-Cycle valid signal, the various stages being:  
  * PC
  * Instruction Fetch + Decode
  * RF Read, ALU
  * RF Write, Branch Instrn. logic
<br>

This implementation would have an IPC of only ~1/3 as the valid signal is active once every 3 cycles (HLLHLL...) indicating only one valid instruction in the pipe at any point. We do this step to partition the core (or logic) into the respective pipeline stages first without having to worry about handling the pipeline hazards.   

|**Waterfall Logic Diagram with 3-Cycle Valid**<br>  ![D9_Pipelining_with_3Cycle_Valid](/docs/images/D9_Pipelining_with_3Cycle_Valid.png)|
|-|
|**TL-V Logic Implementation Diagram**<br>  ![D9_3Cycle_Valid_Diagram](/docs/images/D9_3Cycle_Valid_Diagram.png)|

|**Makerchip-generated Block Diagram for 3-Cycle Valid design**<br>  ![D9_3Cycle_Valid_Makerchip](/docs/images/D9_3Cycle_Valid_Makerchip.png)|
|-|
<br>

#### Pipelining the CPU: Solving the data & control hazards
  1) Data Hazard: Read-After-Write (RAW) in the Refister File
      * There is a 2-cycle delay (by design) between RF Read and Write operations.
      * Hence we have a Read-After-Write (RAW) data hazard if the current instruction in the pipe is trying to read from the Register File (RF) when the previous instruction had written to the same RF index.
      * To solve this, we need to add a Register File Bypass Mux at the input of the ALU and select the previous ALU output if the previous instruction was writing to the RF index accessed in the current instruction.

  |**Register File Bypass Waterfall Logic Diagram**<br>  ![D9_RF_Bypass_Logic_Diagram](/docs/images/D9_RF_Bypass_Logic_Diagram.png)|
  |-|
  |**Register File Bypass TL-V Implementation**<br>  ![D9_RF_Bypass_TLV_Diagram](/docs/images/D9_RF_Bypass_TLV_Diagram.png)|

  2) Control Hazard: Branch Instructions
      * We have control flow hazards when a branch is taken.
      * The PC logic is updated to handle the case when a branch is taken or not.
  
  |**Branch Instruction Control Hazard**<br>  ![D9_Branch_Hazard](/docs/images/D9_Branch_Hazard.png)|
  |-|

#### Complete the ALU
The Instruction Decoder is updated to decode all the instructions and the complete ALU is implemented.
Note: All load instructions are treated as the same as the LW instruction. 

#### DMEM & Load, Store Instructions
The DMEM is a single-port R/W memory with 16 entries, 32-bit wide.  
The DMEM is placed in the 4th pipeline stage.  
|**DMEM**<br>  ![D9_DMEM](/docs/images/D9_DMEM.png)|
|-|

**LOAD (LW, LH, LB, LHU, LBU) Instructions**  
LOAD rd, imm(rs1)  
Loads the data from the DMEM address given by (rs1 + imm) to destination register provided by rd.  
i.e., rd <= DMEM(rs1 + imm)  
<br>

**STORE (SW, SH, LB) Instructions**  
STORE rs2, imm(rs1)  
Stores the data from rs2 to the DMEM address given by (rs1 + imm).  
i.e., rd <= DMEM(rs1 + imm)  
<br>

The $dmem_addr[3:0] is generated by the ALU by treating the load and store instructions to be equivalent to the ADDI instruction.  
```
i.e., The ALU performs the following:
LOAD/ STORE : ($is_load || $is_s_instr) ? ($src1_value + $imm) 
ADDI        :                 $is_addi  ? ($src1_value + $imm) :

Since the DMEM is 32-bit wide and not byte or half-addressable:
$dmem_addr[3:0] = $result[5:2];
```

Muxes need to be placed at the inputs of RF write index ($rf_wr_index) and RF write data ($rf_wr_data) ports to select the appropriate values depending on the validity of the load instruction.  
|**DMEM Load/ Store**<br>  ![D9_LoadStore_TLV_Logic_Diagram2](/docs/images/D9_LoadStore_TLV_Logic_Diagram2.png)|
|-|

Additionally, the Program Counter logic has to be updated for load redirects.

#### Unconditional Jump (JAL, JALR) Instructions
  * JAL : Jump to (PC + IMM), equivalent to an unconditional branch w.r.t the calculation of the target address.
  * JALR: Jump to (SRC1 + IMM)

The logic to calculate the branch target for JALR needs to be implemented.  
The Program Counter logic also needs to be modified to handle the jumps.  

#### Complete Pipelined RISC-V CPU Core Implementation in Makerchip
![D9_Complete_Pipelined_RISCV_Core](/docs/images/D9_Complete_Pipelined_RISCV_Core.png)

_________________________________________________________________________________________________________  
<br>

## Day 10
### GLS of the implemented RISC-V CPU Core

  * The functional verification of the design has already been completed successfully in the Makerchip IDE itself.
  * To perform GLS of the implementation, we need to first convert the TL-Verilog code into synthesizable verilog and then perform the synthesis using Yosys.


#### Sandpiper-Saas: Conversion of TLV code to Verilog
SandPiper TL-Verilog compiler, developed by Redwood EDA can be used to convert TL-Verilog code to Verilog or SystemVerilog code. SandPiper-SaaS provides a command-line interface to run the SandPiper TL-Verilog compiler as a microservice in the cloud. 
  * Install Sandpiper-SaaS by following the steps in the following link: [https://pypi.org/project/sandpiper-saas/](https://pypi.org/project/sandpiper-saas/)
  * To convert tlv file to verilog: ```sandpiper-saas -i <input_tlv_file.tlv> -o <output_file.v> --outdir <output_dir> --inlineGen --iArgs```
  * Please note that for conversion to verilog, edit the **File Format Line** (i.e., usually the first line) in the tlv source file to add an additional option: ```-p verilog```<br>  
    For example: Change ```\m4_TLV_version 1d: tl-x.org``` to ```\m4_TLV_version 1d -p verilog: tl-x.org```<br>  
    Additionally, the following arguments may also be added:
    * ```--noline : Disable `line directive in SV output.```
    * ```--bestsv : Optimize the readability of the generated SV code.```
<br>

**Using Sandpiper-SaaS with Edalize, Fusesoc**
   * Sandpiper-SaaS supports the Flow API and thus allowing sandpiper-saas to be used as a "frontend" to convert TL-Verilog to SystemVerilog/Verilog for any flow.
   * An example of how to use sandpiper-saas with Edalize or Fusesoc in various contexts - viz. standalone tool, frontend to Vivado, in a Custom flow) is available here:<br>
     [edalize_sandpiper_example](https://github.com/shariethernet/edalize_sandpiper_example)  

Additional Reference Links:  
  1) [Edalize](https://github.com/olofk/edalize.git)
  2) [Fusesoc](https://fusesoc.readthedocs.io/en/stable/user/installation.html)

<br>

**Update on GLS**
  * The TL-Verilog code of the RISC-V CPU core implementation was successfully converted to Verilog using Sandpiper-SaaS.  
  * To ensure that the flow is clean, I first tried GLS for a simple counter circuit:
     1) TL-V code of counter was verified in Makerchip IDE
     2) Convert to Verilog using Sandpiper-SaaS
     3) Verify functionality using iverilog
     4) Perform synthesis using Ysosys
     5) Verify correctness by performing GLS using the synthesis output in iverilog

All steps until (iv) are verified to be working fine, however, the GLS using the synthesis tool generated netlist is failing.

_________________________________________________________________________________________________________  
<br>

## Day 11
### Advanced Synthesis and STA with DC
#### Clock Modelling
#### IO Delays
#### generated_clk
#### vclk, max_latency, rise_fall IO Delays
**Update**: Constraint generation is in progress.  
-->
