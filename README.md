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
  |[Day 16](/docs/Day_16.md)| Post-CTS, Post-Routing STA checks for your design <br>  * on ss,ff,tt corners <br>  * Compare with previous results | ![](https://progress-bar.dev/100/?title=done) |

# Day 0 - Setting up the working environment
## System Setup
The program uses Open Source EDA tools and thus a linux OS environment is preferred.
<br />  
__Virtual Machine Requirements:__
  - OS: Ubuntu 18.04+
  - RAM: 6GB or above
  - HDD: 50GB or above
  - CPU cores: 4 vCPUs or more
  
## Tools Setup
 **1. yosys – Yosys Open SYnthesis Suite**  
We will be building Yosys from the source using gcc, the instructions for which are available in the official README for yosys in its GitHub repo.
[Build Yosys from source](https://github.com/YosysHQ/yosys#building-from-source)
<br />
   - Clone source code from git repository:
     ```shell
     git clone https://github.com/YosysHQ/yosys.git
     ```
    
  - Install the build system prerequsites/ dependencies:
    ```shell
    sudo apt-get install build-essential clang bison flex \
        libreadline-dev gawk tcl-dev libffi-dev git \
        graphviz xdot pkg-config python3 libboost-system-dev \
        libboost-python-dev libboost-filesystem-dev zlib1g-dev
    ```
    
  - Build (using gcc) and install Yosys:
    ```shell
    make config-gcc
    make
    sudo make install
    ```
    
  - Invoke from shell:  
    ![day0_yosys](/docs/images/day0_yosys.png)
  
 **2. iverilog - Icarus Verilog**  
   - Install from official Ubuntu repository:
     ```shell
     sudo apt-get install iverilog
     ```
     
   - Invoke from shell:  
     ![day0_iverilog](/docs/images/day0_iverilog.png)
  
 **3. GTKWave**
   - Install from official Ubuntu repository:
     ```shell
     sudo apt-get install gtkwave
     ```
     
   - Invoke from shell:  
     ![day0_gtkwave](/docs/images/day0_gtkwave.png)
     
_________________________________________________________________________________________________________  
# Day 1 - Introduction to RTL Design and Synthesis
## Labs 1,2: Functional Simulation of RTL design using iverilog and gktwave
In this lab, we clone the gihthub repo - [sky130RTLDesignAndSynthesisWorkshop](https://github.com/kunalg123/sky130RTLDesignAndSynthesisWorkshop) - and use one of the example RTL design sources together with its corresponding testbench to get familiarised with the functional simulation of an RTL design using iverilog and gtkwave.   
<br />
1. Clone the github repo with the RTL design examples and sky130*.lib files
```shell
git clone https://github.com/kunalg123/sky130RTLDesignAndSynthesisWorkshop.git
```

2. We will be performing functional simulation of the module good_mux (defined in good_mux.v), as an example.
```shell
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
## Lab 3: Synthesis of RTL design using Yosys with sky130 library as target
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
```
```verilog
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
_________________________________________________________________________________________________________  

# Day 2 - Timing lib files, Hierarchical vs. Flat Synthesis and Flip-flop coding styles
## Lab 4: Familiarization of the .lib file structure and various timing models (QTMs/ETMs)
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
  
## Lab 5: Hierarchical vs. Flat Synthesis
In this experiment, we will take a look at how the Yosys tool performs the synthesis and generates the netlst for a multi-module design with and without preserving the design hierarchy.  
For this example, we will use the design file, multiple_modules.v, which contains some logic implementation using two sub-modules.  

### 1. Hierarchical
  Perform the hierarchical synthesis from the Yosys shell using the following commands:  
  ```shell
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
<!---
  Corresponding Netlist - multiple_modules_hier.v:  
  ```verilog
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
  
### 2. Flattened
  To flatten the hierarchical design, the command **flatten** is used following which we can write the netlist, as shown below:  
  ```shell
  flatten
  write_verilog -noattr multiple_modules_flat.v
  show -stretch multiple_modules 
  ```
    
  Synthesis result after flattening:  
  ![day2_multiple_modules_flat](/docs/images/day2_multiple_modules_flat.png)
  <br />
  <br />
<!---
  Corresponding Netlist - multiple_modules_flat.v:  
  ```verilog
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

  **Comparing the netlist generated for hierarchical and flat synthesis:**  
  ![multiple_modules_hierarchical_vs_flat](/docs/images/multiple_modules_hierarchical_vs_flat.png)
________________________________________________________________________________________________________________________
  
## Lab 6: Various Flip-Flop Designs
Here, we will take a look at the simulation and synthesis of different flip-flops.  
<br>
### 1. DFF with Asynchronous Reset
  ```verilog
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
  
  ```shell
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
  
### 2. DFF with Synchronous Reset
  ```verilog
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
  
### 3. DFF with both Asynchronous & Synchronous Reset
  ```verilog
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
  
## Lab 7: Some interesting synthesis optimizations involving multipliers  
<br>
Here, we will take a look at the synthesis of two special cases of multipliers where no cells are used at all.  
<br>  
<br>

### 1. Multiply by 2
  The input is an n-bit binary number and the output is twice the input.  
  ```
  i.e., output[n:0] = 2 * input[n-1 : 0]

  This is equivalent to left-shifting the input by 1 bit position with trailing 0 added in the LSB.
  In this case also, we can see that there aren't any cells needed to realize this logic,
  and the input to output interconnections involve just wires.  
  ```
  <br>
  
  Netlist generated by Yosys:
  ```verilog
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

### 2. Multiply a 3-bit number by 9
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
  ```verilog
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

# Day 3 - Combinational and Sequential Optimizations
## Combinational Logic Optimizations  
The combinational logic is simplified to the most optimized form which is efficient in terms of area & power savings.  
**1. Constant Propagation** : This is a direct optimization method wherein the Boolean expression of the synthesized logic is simplified if any of the inputs are "a constant" and subsequently some of the logic gate outputs also propagate a constant value always.  
**2. Boolean Logic Optimization** : The various Boolean expression optimization techniques like K-maps (graphical), Quine-McLusky, reduction to standard SOP/ POS forms best suited for the cell library/ technology etc.  
<br>

**NOTE :** The command to perform logic optimization in Yosys is ```opt_clean```.  
Additionally, for a hierarchical design involving multiple sub-modules, the design must be flattened by running the ```flatten``` command before executing the ```opt_clean``` command.
```shell
USAGE:
After the synth -top <module_name> command is executed, do:
    opt_clean -purge

This command identifies wires and cells that are unused and removes them.
The additional switch, purge also removes the internal nets if they have a public name.
```
```shell
# Example showing the sequence of commands to perform combinational logic optimization using Yosys
# on module opt_check in opt_check.v:
    read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib 
    read_verilog opt_check.v 
    synth -top opt_check 
    opt_clean -purge
    abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib 
    show
```

### Lab 8: Example 1: opt_check.v 
```verilog
module opt_check (input a , input b , output y);
    assign y = a?b:0;
endmodule

// We can see by direct simplification that:
//      y = a*b + a_bar*0 = ab
// i.e, a 2-input AND Gate. 
```
<br>

Synthesis Result:  
![opt_check](/docs/images/opt_check.png)  
<br>
_________________________________________________________________________________________________________  

### Lab 8: Example 2: opt_check2.v
```verilog
module opt_check2 (input a , input b , output y);
    assign y = a?1:b;
endmodule

// Boolean simplification:
//      y = a + a_bar*b
//        = ab + a*b_bar + a_bar*b
//        = (ab + ab) + a*b_bar + a_bar*b
//        = (ab + a*b_bar) + (ab + a_bar*b)
//        = a + b 
// i.e, a 2-input OR Gate. 
```
<br>

Synthesis Result:  
_The cell library already seems to have an OR gate available as the synthesis result is an OR gate itself and not a NAND-realization of the OR to avoid the stacked PMOS as shown in the demo videos_  
![opt_check2](/docs/images/opt_check2.png)  
<br>
_________________________________________________________________________________________________________  

### Lab 8: Example 3: opt_check3.v
```verilog
module opt_check3 (input a , input b, input c , output y);
    assign y = a?(c?b:0):0;
endmodule

// Boolean simplification:
//      y = a* (bc) + a_bar*0
//        = abc
// i.e, a 3-input AND Gate.
```
<br>

Synthesis Result:  
![opt_check3](/docs/images/opt_check3.png)  
<br>
_________________________________________________________________________________________________________  

### Lab 8: Example 4: opt_check4.v
```verilog
module opt_check4 (input a , input b , input c , output y);
    assign y = a?(b?(a & c):c):(!c);
endmodule

// Boolean simplification:
//      y = a*(abc + b_bar*c) + a_bar*c_bar
//        = abc + a*b_bar*c + a_bar*c_bar
//        = abc + a*b_bar*c + (a_bar*b*c_bar + a_bar*b_bar*c_bar)
//        = ac + a_bar*c_bar
//        = 
// i.e, a 2-input XNOR Gate.
```
<br>

Synthesis Result:  
![opt_check4](/docs/images/opt_check4.png)  
<br>
_________________________________________________________________________________________________________  

### Lab 8: Example 5: multiple_module_opt.v
```verilog
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

### Lab 8: Example 6: multiple_module_opt2.v
```verilog
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

## Sequential Logic Optimizations
**1. Constant Propagation** : Optimization technique used when a constant value is propagated through a flip-flop -- i.e., irrespective of the state of the triggering signals (CLK, Reset, Set), there are no transitions in the flip-flop output.  
<br>

***[Other Advanced optimization methods not covered by examples in detail:]***  
**2. State optimization** : Unused states in the sequential design are optimized and/or the total states needed in the FSM are minimized.  
**3. Cloning** : This is a physically-aware (PnR-aware) optimization method where some of the flops in the design are cloned/ duplicated so that the timing can be met post-PnR for the timing arcs involved (provided there is already some minimum positive slack available).  
**4. Retming** : The pipelining flops in the design are placed optimally so that the combinational delay at each pipeline stage is more or less equalized so that the maximum clock frequency can be increased.  
<br>

```shell
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

### Lab 9: Example 1: dff_const1.v
```verilog
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

### Lab 9: Example 2: dff_const2.v
```verilog
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

### Lab 9: Example 3: dff_const3.v
```verilog
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

### Lab 9: Example 4: dff_const4.v
```verilog
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

### Lab 9: Example 5: dff_const5.v
```verilog
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

### Lab 9: Example 6: counter_opt.v
```verilog
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

### Lab 9: Example 7: counter_opt2.v
```verilog
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
# Day 4 - Gate Level Simulation and Pre- & Post-Synthesis Simulation Mismatch
## Gate Level Simulation (GLS)
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
|![Day4_GLS_using_iverilog](/docs/images/Day4_GLS_using_iverilog.png)|
|-|

<br>

The Gate level verilog model(s) need to be provided as shown below to do GLS using iverilog:
```shell
Syntax:
    iverilog <path-to-gate-level-verilog-model(s)> <netlist_file.v> <tb_top.v>

Example using ternary_operator_mux_netlist.v:
    iverilog ../my_lib/verilog_model/primitives.v ../my_lib/verilog_model/sky130_fd_sc_hd.v ternary_operator_mux_netlist.v tb_ternary_operator_mux.v
```
<br>

## Synthesis - Simulation mismatch
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
```verilog
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
```verilog
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
```verilog
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

# Day 5 - Introduction to RISC-V ISA and GNU Compiler Toolchain
## Introduction to RISC-V ISA

RISC-V is an open standard instruction set architecture based on established reduced instruction set computer(RISC) principles. It was first started by Prof. Krste Asanović and graduate students Yunsup Lee and Andrew Waterman in May 2010 as part of the Parallel Computing Laboratory, at UC Berkeley. Unlike most other ISA designs, the RISC-V ISA is provided under open source licenses that do not require fees to use, which provides it a huge edge over other commercially available ISAs. It is a simple, stable, small standard base ISA with extensible ISA support, that has been redefining the flexibility, scalability, extensibility, and modularity of chip designs.  

### ISA base and extensions
RISC-V has a modular design, consisting of alternative base parts, with added optional extensions. The ISA base and its extensions are developed in a collective effort between industry, the research community and educational institutions. The base specifies instructions (and their encoding), control flow, registers (and their sizes), memory and addressing, logic (i.e., integer) manipulation, and ancillaries. The base alone can implement a simplified general-purpose computer, with full software support, including a general-purpose compiler.  

The standard extensions are specified to work with all of the standard bases, and with each other without conflict.  
![D5_RISC-V_ISA_Base_and_Extensions](/docs/images/D5_RISC-V_ISA_Base_and_Extensions.png)  
<br>

The RISC-V ISA is defined as a Base integer ISA, which is the basic necessity for the implemetation of any CPU core. In addition to that it also has optional extensions to the base ISA. The base RISC-V ISA has a little-endian memory system. The standard is maintained by the RISC-V foundation.  

### RISC-V Instruction Formats
![D5_32-bit_RISC-V_instruction_formats](/docs/images/D5_32-bit_RISC-V_instruction_formats.png)  

References:
  1) [https://en.wikipedia.org/wiki/RISC-V](https://en.wikipedia.org/wiki/RISC-V)
  2) [RISC-V Technical Specifications](https://wiki.riscv.org/display/HOME/RISC-V+Technical+Specifications)
  3) [RISC-V MYTH Workshop](https://github.com/RISCV-MYTH-WORKSHOP/RISC-V-CPU-Core-using-TL-Verilog/blob/master/README.md#introduction-to-risc-v-isa)

##  RISC-V GNU Compiler Toolchain
### RISC-V ISA Simulator and Compiler toolchain setup
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

## Labs 1,2: Write a C program to compute the sum of first N natural numbers, compile using RISC-V GCC, simulate using Spike RISC-V ISA Simulator and disassemble to view the assembly code  
**C Program:**
```C
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
```shell
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
```shell
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

## Lab 3: Use the Interactive Debug mode in Spike RISC-V ISA sim to observe the execution of the program with -Ofast flag  
A small example of how to use the debug mode can be found in the following page: [Interactive Debug Mode](https://github.com/riscv-software-src/riscv-isa-sim#interactive-debug-mode)  

To enter the interactive debug mode, launch spike with ```-d``` option:  
```shell
Example:
spike -d pk sum1toN.o
```
<br>

_Snapshot showing usage of Spike Interactive Debug Mode_
![D5_Spike_InteractiveDebugMode](/docs/images/D5_Spike_InteractiveDebugMode.png)
<br>

```shell
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
# Day 6 - Introduction to ABI and basic verification flow
## Introduction to ABI
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
```C
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
```asm
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

## Basic Verification Flow
### Lab 2: Run the above C program on a RISC-V CPU
For this exercise, we will use the design files from the following GitHub repository: [https://github.com/kunalg123/riscv_workshop_collaterals.git](https://github.com/kunalg123/riscv_workshop_collaterals.git)  
Execute the following file from shell:  

rv32im.sh:
```shell
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
# Day 7 - Digital Logic Design with TL-Verilog and Makerchip
  
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
  
## Combinational Logic
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

## Sequential Logic
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

## Pipelined Logic
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

## Validity
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
# Day 8 - Implmentation of a Basic RISC-V CPU Microarchitecture

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
# Day 9 -  Implementation of the complete Pipelined RISC-V CPU Microarchitecture

Our RISC-V core from the previous day is still incomplete w.r.t the instructions implemented, and additionally we need to do pipelining and handling of the pipeline hazards.  
We need to do the following to complete the CPU Design:
  1) Pipeline the CPU, taking care of the data dependency & control flow hazards
  2) Complete the implementation of the remaining ALU instructions
  3) Implement DMEM & Load, Store instructions
  4) Implement the Unconditional Jump (JAL, JALR) instructions

|**Pipelining the RISC-V CPU Core ![D9_RISCV_Pipelined](/docs/images/D9_RISCV_Pipelined.png)|
|-|
<br>

## Pipelining the CPU: Using 3-Cycle $valid signal
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

## Pipelining the CPU: Solving the data & control hazards
### 1) Data Hazard: Read-After-Write (RAW) in the Refister File
  * There is a 2-cycle delay (by design) between RF Read and Write operations.
  * Hence we have a Read-After-Write (RAW) data hazard if the current instruction in the pipe is trying to read from the Register File (RF) when the previous instruction had written to the same RF index.
  * To solve this, we need to add a Register File Bypass Mux at the input of the ALU and select the previous ALU output if the previous instruction was writing to the RF index accessed in the current instruction.

  |**Register File Bypass Waterfall Logic Diagram**<br>  ![D9_RF_Bypass_Logic_Diagram](/docs/images/D9_RF_Bypass_Logic_Diagram.png)|
  |-|
  |**Register File Bypass TL-V Implementation**<br>  ![D9_RF_Bypass_TLV_Diagram](/docs/images/D9_RF_Bypass_TLV_Diagram.png)|

###  2) Control Hazard: Branch Instructions
  * We have control flow hazards when a branch is taken.
  * The PC logic is updated to handle the case when a branch is taken or not.
  
  |**Branch Instruction Control Hazard**<br>  ![D9_Branch_Hazard](/docs/images/D9_Branch_Hazard.png)|
  |-|

## Complete the ALU
The Instruction Decoder is updated to decode all the instructions and the complete ALU is implemented.
Note: All load instructions are treated as the same as the LW instruction. 

## DMEM & Load, Store Instructions
### DMEM
  * The DMEM is a single-port R/W memory with 16 entries, 32-bit wide.  
  * The DMEM is placed in the 4th pipeline stage.
    |**DMEM**<br>  ![D9_DMEM](/docs/images/D9_DMEM.png)|
    |-|

### LOAD (LW, LH, LB, LHU, LBU) Instructions
  * LOAD rd, imm(rs1)  
  * Loads the data from the DMEM address given by (rs1 + imm) to destination register provided by rd.
    i.e., rd <= DMEM(rs1 + imm)
    <br>

### STORE (SW, SH, LB) Instructions
  * STORE rs2, imm(rs1)  
  * Stores the data from rs2 to the DMEM address given by (rs1 + imm).
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

## Unconditional Jump (JAL, JALR) Instructions
  * JAL : Jump to (PC + IMM), equivalent to an unconditional branch w.r.t the calculation of the target address.
  * JALR: Jump to (SRC1 + IMM)

The logic to calculate the branch target for JALR needs to be implemented.  
The Program Counter logic also needs to be modified to handle the jumps.  

## Complete Pipelined RISC-V CPU Core Implementation in Makerchip
<!--[**Link to SVG file of the RISC-V Core Block Diagram**](https://htmlpreview.github.io/?https://raw.githubusercontent.com/arunkpv/vsd-hdp/main/docs/html/riscv.html)  -->
Click on the image below to open up the interactive svg file:  
[![D9_Complete_Pipelined_RISCV_Core](/docs/images/D9_Complete_Pipelined_RISCV_Core.png)](https://htmlpreview.github.io/?https://raw.githubusercontent.com/arunkpv/vsd-hdp/main/docs/html/riscv.html)  

_________________________________________________________________________________________________________  
## Bug with the LW instruction and RF Read Bypass
**Original Code:** [riscv_pipelined_with_LW_Bug.tlv](../code/riscv/verilog/rf_rd_bug/riscv_pipelined_with_LW_Bug.tlv)
In the functional simulation of the RTL code in MakerChip IDE of the RISC-V CPU core that we have designed following the steps in the lecture videos and slides, I noticed [two issues](/docs/videos/D9_Bug_Video.mp4):  

###  1) During the execution of the LW instruction, the DMEM address gets written to destination register in the first cycle.  
**(NOTE: This is a benign issue and not a concern)**  
  - Since LW is an I-type (Immediate-type instruction), the **$rd** (Destination Register) is valid during this phase and thus **$rf_wr_en** (Register File Write Enable).
      ```
      // Immediate
      $is_i_instr = ($instr[6:2] == 5'b00000) ||
                    ($instr[6:2] == 5'b00001) ||
                    ($instr[6:2] == 5'b00100) ||
                    ($instr[6:2] == 5'b00110) ||
                    ($instr[6:2] == 5'b11001);
      ...
      $is_load  = ($opcode == 7'b0000011);
      ...
      $rd_valid = $is_r_instr | $is_i_instr | $is_u_instr | $is_j_instr;
      ...
      $rf_wr_en =  ($rd_valid && $valid && $rd != 5'b0) || >>2$valid_load;
      ```
  - If we take the following example: `m4_asm(LW, r15,  r0, 00100)`.  
    This instruction is supposed to do just: `r15 [31:0] <= DMEM [(r0 + 00100)] [31:0]`  
         
    Due to our design, the DMEM address is generated by the ALU as: **DMEM_addr = (rs1 + imm)**.
    Hence the ALU output (or the DMEM address) gets written to the destination register first and then two cycles later the actual data from the DMEM address gets written to the destination register.
           
  - In our implementation, since it takes two cycles for valid data to be fetched from the DMEM and to be written to the destination register, we are squashing the 2 instructions already in the pipe in the "shadow" of the Load instruction.  
    Hence writing this intermediate value to the destination register is not a concern a.  
    Nevertheless, to avoid this unnecessary RF write for a cleaner implmentation, we can deassert **$rf_wr_en** for these two cycles for a valid load instruction.
    ```
    $rf_wr_en = (!$valid_load && !>>1$valid_load) && ($rd_valid && ($rd != 5'b0) && $valid) || >>2$valid_load;
    ```
  
###  2) The instruction immediately following the LW instruction gets the wrong **$src1_value** and **$src2_value**
**(NOTE: This is an actual BUG and breaks functionality)**  

  - This bug was found while checking if the above issue was causing any RAW hazards if the instruction immediately following the LW instruction accesses the destination register of the LW instruction.
  - This happens because of an incorrect RF Read Bypass in the original implementation:
    ```
    $src1_value[31:0] = (>>1$rf_wr_index == $rf_rd_index1) && >>1$rf_wr_en
                        ? >>1$result : $rf_rd_data1 ;
    
    $src2_value[31:0] = (>>1$rf_wr_index == $rf_rd_index2) && >>1$rf_wr_en
                        ? >>1$result : $rf_rd_data2 ;
    ```
    
      - In this original code, the instruction immediately in the shadow of the LW instruction gets the wrong values for **$src1_value, $src2_value** which are the inputs to the ALU.  
      - This is because, we not accounting for the fact that the data to be written to the RF could come from either the ALU (**$result**) or from the DMEM (**$ld_data**).  
        `$rf_wr_data[31:0] = >>2$valid_load ? >>2$ld_data : $result;`
          
        But we are only considering the ALU output for RF Read during a RAW Hazard.
        
|**RF Read Bypass Bug**<br>  ![D9_Bug_Slide_49_RF_ReadBypass](/docs/images/D9_Bug_Slide_49_RF_ReadBypass.png)|
|-|
<br>
    
  - **FIX 1:** During the initial debugs, I came up with the following solution to the bug based on the simulation waveforms and the VIZ_JS debug prints.
    - [riscv_pipelined_withBugFix_1.tlv](../code/riscv/verilog/rf_rd_bug/riscv_pipelined_withBugFix_1.tlv)  
      This explicitly considers the case of the instruction immediately succeeding LW.
    ```
    // Handling Read-After-Write Hazard
    $src1_value[31:0] = >>3$valid_load && (>>3$rf_wr_index == $rf_rd_index1) ? >>3$ld_data :
                        (>>1$rf_wr_index == $rf_rd_index1) && >>1$rf_wr_en ? >>1$result   :
                        $rf_rd_data1;
    
    $src2_value[31:0] = >>3$valid_load && (>>3$rf_wr_index == $rf_rd_index2) ? >>3$ld_data :
                        (>>1$rf_wr_index == $rf_rd_index2) && >>1$rf_wr_en ? >>1$result   :
                        $rf_rd_data2;
    ```
      
  - **FIX 2:** Talking to Steve H. actually got me a better understanding of the issue, and he suggested the following code change:
    - [riscv_pipelined_withBugFix_2.tlv](../code/riscv/verilog/rf_rd_bug/riscv_pipelined_withBugFix_2.tlv)
    ```
    // Handling Read-After-Write Hazard
    $src1_value[31:0] = (>>1$rf_wr_index == $rf_rd_index1) && >>1$rf_wr_en
                        ? >>1$rf_wr_data : $rf_rd_data1;
    
    $src2_value[31:0] = (>>1$rf_wr_index == $rf_rd_index2) && >>1$rf_wr_en
                        ? >>1$rf_wr_data : $rf_rd_data2;
    ```
_________________________________________________________________________________________________________  
# Day 10 - GLS of the Implemented RISC-V CPU

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

### Issues
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

### Results
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
  
 * **<details><summary>Statistics of synthesis output:</summary>**
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
    </details>

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

### (OLD) Results
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
# Day 11 - STA Basics

Static Timing Analysis (STA) is a method of validating the timing performance of a design by checking all possible paths for timing violations.
  * The design is broken down into timing paths having start and endpoints, the signal propagation delay along each path is calculated, and checked for violations of timing constraints inside the design and at the input/output interfaces.
  * The STA analysis is the static type - i.e., the timing analysis is carried out statically and does not depend upon the data values being applied at the input pins.  

As the naming suggests, there is another method - Dynamic Timing Analysis (DTA) where the timing behaviour is analyzed by applying a stimulus/ test vector at the input signals, the resulting behaviour of the design is captured in the simulation and functionality is verified using the testbenches.
  * This approach verifies the design meets the timing requirements while simultaneously ensuring the functionality.
  * However, this is a very expensive method in terms of both simuation run time and resources as we cannot verify the entire space of test vectors exhaustively.
  * A trade-off could be to select the test vectors that exercise majority of the circuits, but this is usually not sufficient for sign-off as the coverage/ confidence obtained is only as exhaustive as the test vectors used and no 100% guarantee that the design will work across conditions.
## STA Basics
STA can performed at various stages of the ASIC design flow, with the emphasis being on different aspects.

| ![D11_STA_in_Design_Flow_resized](/docs/images/D11_STA_in_Design_Flow_resized.png) |
|:---|

### Timing Arcs
  1. Combinational arcs: Between input and output pin of a combinational block/ cell.
  2. Sequential arcs: Between the clock pin and either the input or output
     * Timing check arc: Between the clock pin and the input. (For example, the setup and hold timing arcs between the clock pin and input data pin of a Flip Flop)
     * Delay arc: Between the clock pin and the output.
  3. Net arcs: Between the output pin of a cell to the input pin of another cell. (i.e., between the driver pin of a net and the load pin of that net)

### Unateness
Defines how the output changes for different types of transitions on the input.
  1. Positive unate: Rising input transition causes rising output transition and falling input transition causes falling output transition.
     * Examples: Buffer, AND Gate, OR Gate
  2. Negative unate: Rising input transition causes falling output transition and falling input transition causes rising output transition.
     * Examples: Inverter, NAND Gate, NOR Gate
  3. Non-unate: The output transition is determined not only by the direction of an input but also on the state of the other inputs.
     * Examples: XOR Gate

## Advanced Synthesis and STA with DC
## To Do: Complete the documentation of the theoretical aspects


## STA of the RISC-V CPU core using OpenSTA
  * [**Design Constraints**](../code/riscv/sdc/riscv_core_synthesis.sdc)
    ```
    set_units -time ns
    
    set period 10.000
    create_clock -name clk -period $period [get_ports {clk}]
    
    set_clock_latency -source -min 1 clk
    set_clock_latency -source -max 4 clk
    
    set clk_uncertainty_factor_setup 0.05
    set clk_uncertainty_setup [expr $period * $clk_uncertainty_factor_setup]
    set clk_uncertainty_factor_hold 0.02
    set clk_uncertainty_hold [expr $period * $clk_uncertainty_factor_hold]
    set_clock_uncertainty -setup $clk_uncertainty_setup [get_clock clk]
    set_clock_uncertainty -hold $clk_uncertainty_hold [get_clock clk]
    
    set min_input_dly_factor 0.1
    set max_input_dly_factor 0.3
    set min_input_dly [expr $period * $min_input_dly_factor]
    set max_input_dly [expr $period * $max_input_dly_factor]
    set_input_delay -clock clk -min $min_input_dly [get_ports reset]
    set_input_delay -clock clk -max $max_input_dly [get_ports reset]
    
    
    set min_tran_factor 0.01
    set max_tran_factor 0.05
    set min_tran [expr $period * $min_tran_factor]
    set max_tran [expr $period * $max_tran_factor]
    set_input_transition -max $min_tran [get_ports reset]
    set_input_transition -min $max_tran [get_ports reset] 
    
    set min_ouput_dly_factor 0.2
    set max_ouput_dly_factor 0.5
    set min_ouput_dly [expr $period * $min_ouput_dly_factor]
    set max_ouput_dly [expr $period * $max_ouput_dly_factor]
    set_output_delay -clock clk -min $min_ouput_dly [get_ports out]
    set_output_delay -clock clk -min $max_ouput_dly [get_ports out]
    ```
  * [**SDC File written from OpenSTA using write_sdc command**](../code/riscv/sdc/riscv_core_sdc.sdc)

  * **OpenSTA shell showing snapshots**
    The following snapshots show the commands to:
      * `read_liberty`: Read the Liberty format library file
      * `read_verilog`: Read the gate level verilog netlist file
      * `link_design`: Link (elaborate, flatten) the the top level cell
      * `read_sdc`: Read SDC commands from the given constraints file
      * `check_setup`: Perform sanity checks on the design
      * `report_checks`: Report paths in the desing based on the additional arguments/ filters provided
    
  | **OpenSTA commands to do STA** <br>  ![D11_OpenSTA_sta_commands](/docs/images/D11_OpenSTA_sta_commands.png) |
  |:---|

  | **(OLD) Min path**<br>  ![D11_OpenSTA_min_delay](/docs/images/D11_OpenSTA_min_delay.png) | (OLD) **Max path**<br>  ![D11_OpenSTA_max_delay](/docs/images/D11_OpenSTA_max_delay.png) |
  |:---:|:---:|


  * As can be seen from the OpenSTA log, the design has 3 unconstrained endpoints.
    ```
    _15766_/D
    _15768_/D
    _15777_/D
    ```
    * On inspecting the gate level netlist, these endpoints are the D input pins of DFF (sky130_fd_sc_hd__dfxtp_1) tied to a constant "0".
    * Yosys should have reduced them to constant drivers but somehow they still remain.
    * A Yosys GitHub issue has been raised to check if there is a way to avoid this.  
      Details of the issue can be read here: [https://github.com/YosysHQ/yosys/issues/4266](https://github.com/YosysHQ/yosys/issues/4266)

  * The design also fails to meet the target timing requirements:
    * Min path: most probably due to the overly conservative/ pessimistic values of the clock source latencies used.
    * Max path: due to the conservative values of clock source latencies used and undefined fanout constraints. (Inverter instance `_10539_` of type **sky130_fd_sc_hd__clkinv_1** is having a fanout of 932)

**<ins>UPDATE:</ins>**
  * The synthesis script was updated based on inputs from [**Yosys issue #4266**](https://github.com/YosysHQ/yosys/issues/4266).
    * The DFF with constant inputs have been taken care of.
    * The STA analysis of the new netlist is given below:

  | **Min path**<br>  ![D11_OpenSTA_min_delay](/docs/images/D11_OpenSTA_min_delay_New.png) | **Max path**<br>  ![D11_OpenSTA_max_delay](/docs/images/D11_OpenSTA_max_delay_New.png) |
  |:---:|:---:|

<br>

_________________________________________________________________________________________________________  
# Day 12 - Advanced SDC Constraints

<br>

_________________________________________________________________________________________________________  
_________________________________________________________________________________________________________  
# Day 13 - STA using OpenSTA

<br>

_________________________________________________________________________________________________________  
# Day 14 - CMOS Fundamentals
## To-Do: Complete documentation of theory

## sky130 Labs
### Lab 1
### Lab 2
### Lab 3


<br>

_________________________________________________________________________________________________________  
# Day 15 - Velocity Saturation and CMOS Inverter VTC
## To-Do: Complete documentation of theory

## sky130 Labs
### Lab 1
### Lab 2
### Lab 3


<br>

_________________________________________________________________________________________________________  
# Day 16 - CMOS Inverter Switching Threshols and Dynamic Simulations 
## To-Do: Complete documentation of theory

## sky130 Labs
### Lab 1
### Lab 2
### Lab 3


<br>

_________________________________________________________________________________________________________  
# Day 17 - CMOS Noise Margin Robustness Evaluation
## To-Do: Complete documentation of theory

## sky130 Labs
### Lab 1
### Lab 2
### Lab 3


<br>

_________________________________________________________________________________________________________  
# Day 18 - CMOS Power Supply and Device Variation Robustness Evaluation
## To-Do: Complete documentation of theory

## sky130 Labs
### Lab 1
### Lab 2
### Lab 3


<br>

_________________________________________________________________________________________________________  

# Day 19 - PVT Corner Analysis of the RISC-V CPU Design
## PVT Corner Analysis
The STA checks are performed across all the corners to confirm the design meets the target timing requirements.
  * The worst max path (Setup-critical) corners in the sub-40nm process nodes are usually: ss_LowTemp_LowVolt, ss_HighTemp_LowVolt (Slowest corners)
  * The worst min path (Hold-critical) corners being: ff_LowTemp_HighVolt,ff_HighTemp_HighVolt (Fastest corners)
  * The below tcl script [**sta_across_pvt.tcl**](../code/riscv/scripts/sta_across_pvt.tcl) can be run to performt the STA across the PVT corners for which the sky130 lib files are available:
    ```
    set list_of_lib_files(1) "sky130_fd_sc_hd__tt_025C_1v80.lib"
    set list_of_lib_files(2) "sky130_fd_sc_hd__ff_100C_1v65.lib"
    set list_of_lib_files(3) "sky130_fd_sc_hd__ff_100C_1v95.lib"
    set list_of_lib_files(4) "sky130_fd_sc_hd__ff_n40C_1v56.lib"
    set list_of_lib_files(5) "sky130_fd_sc_hd__ff_n40C_1v65.lib"
    set list_of_lib_files(6) "sky130_fd_sc_hd__ff_n40C_1v76.lib"
    set list_of_lib_files(7) "sky130_fd_sc_hd__ss_100C_1v40.lib"
    set list_of_lib_files(8) "sky130_fd_sc_hd__ss_100C_1v60.lib"
    set list_of_lib_files(9) "sky130_fd_sc_hd__ss_n40C_1v28.lib"
    set list_of_lib_files(10) "sky130_fd_sc_hd__ss_n40C_1v35.lib"
    set list_of_lib_files(11) "sky130_fd_sc_hd__ss_n40C_1v40.lib"
    set list_of_lib_files(12) "sky130_fd_sc_hd__ss_n40C_1v44.lib"
    set list_of_lib_files(13) "sky130_fd_sc_hd__ss_n40C_1v76.lib"
    
    for {set i 1} {$i <= [array size list_of_lib_files]} {incr i} {
    read_liberty ./timing_libs/$list_of_lib_files($i)
    read_verilog ./riscv_pipelined_Final_netlist.v
    link_design riscv_core
    current_design
    read_sdc riscv_core_synthesis.sdc
    check_setup -verbose
    report_checks -path_delay min_max -fields {nets cap slew input_pins fanout} -digits {4} > ./sta_output/min_max_$list_of_lib_files($i).txt
    
    exec echo "$list_of_lib_files($i)" >> ./sta_output/sta_worst_max_slack.txt
    report_worst_slack -max -digits {4} >> ./sta_output/sta_worst_max_slack.txt
    
    exec echo "$list_of_lib_files($i)" >> ./sta_output/sta_worst_min_slack.txt
    report_worst_slack -min -digits {4} >> ./sta_output/sta_worst_min_slack.txt
    
    exec echo "$list_of_lib_files($i)" >> ./sta_output/sta_tns.txt
    report_tns -digits {4} >> ./sta_output/sta_tns.txt
    
    exec echo "$list_of_lib_files($i)" >> ./sta_output/sta_wns.txt
    report_wns -digits {4} >> ./sta_output/sta_wns.txt
    }
    ```
| ![D13_riscv_core_sta_across_pvt](/docs/images/D13_riscv_core_sta_across_pvt.png)|
|-|
| ![D13_worst_setup_slack](/docs/images/D13_worst_setup_slack.png)|
| ![D13_worst_hold_slack](/docs/images/D13_worst_hold_slack.png)|
| ![D13_wns](/docs/images/D13_wns.png)|
| ![D13_tns](/docs/images/D13_tns.png)|

<br>

_________________________________________________________________________________________________________  
# Day 20 - Advanced Physical Design using OpenLANE/ Sky130

## Day 14.1: Inception of open-source EDA, OpenLANE and Sky130 PDK

  * **IC terminologies**
    * Chip Package
    * Pads & Padring
    * Core, die
    * IPs, Macros

### [**14.1.1 Overview of ASIC Design Flow using OpenLane**](http://ef.content.s3.amazonaws.com/OpenLane-DialUp-MohamedShalan.pdf)
  * ASIC implementation consists of numerous steps involving lots of detailed sub-processes at each step.
  * A **design methodology** is needed for a successful ASIC implementation without any hiccups.
  * The methodology is implemented through a **flow** that pieces together different tools to carry out the different steps of the design process from RTL to GDSII tapeout.

#### 14.1.1.1 Simplified RTL to GDSII ASIC Design Flow
| ![Simplified Flow](/docs/images/D14.1_Simplified_Flow.png) |
|---|

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

#### 14.1.1.2 OpenLANE ASIC Design Flow
Main requirements of Digital ASIC Design:
  * RTL Design
  * EDA Tools
  * PDK

| ![D14.1_OpenSource_ASIC_Design](/docs/images/D14.1_OpenSource_ASIC_Design.png) |
|---|
  
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


#### Lab: Familiarize with OpenLANE flow

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

#### Lab: Run floorplan using OpenLANE and review the layout in Magic
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

#### Lab: Run placement
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

### 14.3.1 16-Mask CMOS Process
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

#### <ins>DRC Lab 1: met3.mag</ins>
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

#### <ins>DRC Lab 2: poly.mag - Exercise to fix poly.9 error in Sky130 tech-file</ins>
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

#### <ins>DRC Lab 3: poly.mag - Exercise to implement poly resistor spacing to diff and tap</ins>
  * The additions we made for the poly.9 DRC rule are still not complete. We can check this by creating two copies of the three resistors (`npolyres, ppolyres and xhrpolyres`)
  * We will add `ndiffussion, pdiffusion, nsubstratendiff & psubstratepdiff` around the two copies of the three poly resistors as shown.
  * Also draw an `nwell` under the pdiffusion and N-tap (nsubstratendiff) to avoid the flagging of any diffusion-related DRC errors since we are not interested in them for this exercise.

  * From the layout, we can see that all the poly resistors except the `npolyres` are showing the DRC spacing violations. The `npolyres` is only flagging the DRC spacing violation to the N-tap.
    This can be fixed by changing the npres spacing rule to consider all diffusion instead of just `nsd`
    
  | Before | After |
  |:---|:---|
  |  <pre>spacing npres *nsd 480 touching_illegal \ <br>   "poly.resistor spacing to N-tap < %d (poly.9)"</pre> | <pre>spacing npres alldiff 480 touching_illegal \ <br>   "poly.resistor spacing to N-tap < %d (poly.9)"</pre> |
  | ![D14.3_sky130_DRC_Lab_poly.9_Diffusion_1](/docs/images/D14.3_sky130_DRC_Lab_poly.9_Diffusion_1.png) | ![D14.3_sky130_DRC_Lab_poly.9_Diffusion_2](/docs/images/D14.3_sky130_DRC_Lab_poly.9_Diffusion_2.png) |

#### <ins>DRC Lab 4: nwell.mag - Challenge exercise to describe DRC error as geometrical construct</ins>
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

#### <ins>DRC Lab 5: nwell.mag - Challenge  to find missing or incorrect rules and fix them</ins>
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
    add_lefs -src $lefs
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

### 14.4.1 Introduction to Delay Tables
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

### 14.4.2 Timing analysis with ideal clocks using openSTA

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

### 14.4.3 Clock Tree Synthesis using TritonCTS and Signal Integrity
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

### 14.4.4 Timing Analysis with real clocks using OpenSTA

#### Setup timing analysis using real clocks

#### Hold timing analysis using real clocks

#### Lab: Steps to analyze timing with real clocks (Post-CTS STA) using OpenSTA
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
_________________________________________________________________________________________________________  

## Day 14.5: Final steps for RTL2GDS using tritonRoute and openSTA
###  14.5.1 Routing and Design Rule Check (DRC)
#### Introduction to Maze Routing - Lee's Algorithm
  * Lee's algorithm is one possible solution for maze routing problems based on breadth-first search.
    * If a path exists between the source and target, this algorithm guarantees finding it.
    * It always finds the shortest path between the source and target.
  * <ins>**Steps**</ins>
    1) The layout area is divided into a Routing grid with keep-off areas for the pre-placed macros and logical blockages for the I/O pad ring.
    2) The next step is to identify the source pin (S) and target pin (T) of the cells in the grid
    3) Now, based on the distance from the grid box "S", adjacent grid boxes (only horizontal and vertical grid boxes are considered adjacent and not the diagonal ones) are labelled as 1. Next, the grid boxes adjacent to those labelled 1 are now labelled as 2. This iterative process progresses until we hit the target pin's, "T" grid box.
    * **Note**: The wave expansion marks only points in the routable area of the chip, not in the blocks or already wired parts.
  * Routes with lower number of bends are preferred.

  | **Lee's Routing Algorithm** <br>  ![D14.5_Lees_Routing_Algorithm_resized](/docs/images/D14.5_Lees_Routing_Algorithm_resized.png) <br>  **The blue route is preferred over the black one due to lower number of bends** |
  |:---|
  
  * This algorithm, however, has a high cost in term of both memory usage and run time.
  * To overcome these short-comings, there are other more advanced algorithms like Line Search algorithm & Steiner tree algorithm.

#### Design Rule Check during routing
  * While performing routing, the router tool needs to follow the DRC rules related to routing provided by the PDK.
  * Basically, the origin of these DRCs come from the manufacturing process used like photolithography or others, that for example, define the minimum wire width that can be manufactured, the minimum spacing between two wire in a metal layer etc.

  | **Typical DRC rules for wires like width, spacing and pitch** <br>  ![D14.5_Routing_DRC_Typical_Rules_about_wire](/docs/images/D14.5_Routing_DRC_Typical_Rules_about_wire.png) |
  |:---|

  * Check out the DRC rules related to the local interconnect and the metal layers for [sky130 PDK DRC](https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html#li).

  | **A Signal short during route** <br>  **Fixing it using other metal layers gives rise to new DRC checks related to VIAs** <br>  ![D14.5_Routing_DRC_Check_Examples_2](/docs/images/D14.5_Routing_DRC_Check_Examples_2.png) |
  |:---|

### 14.5.2 Power Distribution Network and Routing
#### Lab: Steps to build Power Distribution Network
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

  | ![D14.5_Power_Distribution_Network_resized](/docs/images/D14.5_Power_Distribution_Network_resized.png) |
  |:---|
  | _**Source:**_ [Power Distribution Network](https://vlsibyjim.blogspot.com/2015/03/power-planning.html) |

  * Command to generate PDN in openLANE: `run_power_grid_generation`

  | **Layout after PDN generation** <br>  ![D14.5_Layout_after_PDN_Generation](/docs/images/D14.5_Layout_after_PDN_Generation.png) |
  |:---|
  | **Layout zoomed** <br>  ![D14.5_Layout_after_PDN_Generation_Zoomed](/docs/images/D14.5_Layout_after_PDN_Generation_Zoomed.png) |


#### Lab: Steps to perform routing
  * To run the routing in OpenLANE, execute: `run_routing`

  | **No DRC violations after routing** <br> ![D14.5_Detailed_Routing_No_DRC_Viols](/docs/images/D14.5_Detailed_Routing_No_DRC_Viols.png) |
  |:---|
  | **No Timing violations at TYPICAL corner** <br> ![D14.5_STA_for_typical_after_routing](/docs/images/D14.5_STA_for_typical_after_routing.png) |
  | **Layout after routing (KLayout)** <br>  ![D14.5_Layout_after_routing_in_klayout](/docs/images/D14.5_Layout_after_routing_in_klayout.png) |
  | **Layout after routing - Zoomed (Magic)** <br>  ![D14.5_Layout_after_Routing](/docs/images/D14.5_Layout_after_Routing.png) |
  
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
 
#### Basics of global and detail routing
  * Global route using `fast route` and Detailed route using `tritonRoute`
  * Global route provides a routing guide.
  * In Detailed route, algorithms are used to find the best possible connectivity using the routing guides from global route.

#### TritonRoute Features
  * Performs initial detail route
  * Honors the preprocessed route guides (obtained after global route) - i.e., attempts as much as possible to route within route guides.
  * Assumes route guides for each net satisfy inter-guide connectivity.
  * Works on proposed MILP-based panel routing scheme with intra-layer parallel and inter-layer sequential routing framework.

<br>

_________________________________________________________________________________________________________  
# Day 21 - Post-placement STA analysis of your Design (RISC-V Myth CPU Core)
## 15.1 OpenLANE Installation (latest stable version)
For ease of installation, OpenLane uses Docker images, that include all the required applications, binaries and the flow scripts.  
The [OpenLane Installation Documentation](https://openlane.readthedocs.io/en/latest/getting_started/installation/installation_ubuntu.html) page explains in detail the step to setup OpenLANE. A short summary of the necessary steps is given below:  
  * Install the required dependencies:
    ```
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt install -y build-essential python3 python3-venv make git
    ```
  * [Docker Installation](https://docs.docker.com/engine/install/ubuntu/)
    1) Run the following command to uninstall all conflicting packages:
       ```
       for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
       ```
    2) Set up Docker's apt repository
       ```
       # Add Docker's official GPG key:
       sudo apt-get update
       sudo apt-get install ca-certificates curl
       sudo install -m 0755 -d /etc/apt/keyrings
       sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
       sudo chmod a+r /etc/apt/keyrings/docker.asc
       
       # Add the repository to Apt sources:
       echo \
         "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
         $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
         sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
       sudo apt-get update
       ```
    3) Install the Docker packages:
       ```
       sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
       ```
    4) Verify that the Docker Engine installation is successful by running:
       ```
       sudo docker run hello-world
       ```  
       To make Docker available without root:  
       ```
       sudo groupadd docker
       sudo usermod -aG docker $USER
       sudo reboot # REBOOT!
       
       # After reboot
       docker run hello-world
       ```
  * Download OpenLane from GitHub:
    ```
    git clone --depth 1 https://github.com/The-OpenROAD-Project/OpenLane.git
    cd OpenLane/
    make
    make test
    ```
    * These steps will download and build **OpenLane and sky130 PDK**.
    * Finally, it will run a ~5 minute test that verifies that the flow and the PDK were properly installed. Successful test will output the following line:
    ```
    Basic test passed
    ```
## 15.2 Basic Usage
### 15.2.1 Invoking the OpenLane Docker session:
```
cd to the OpenLane folder

# Start the Docker session:
make mount

# Leave the Docker
exit
```

### 15.2.2 [Adding Your Designs](https://openlane.readthedocs.io/en/latest/usage/designs.html)
  * To add a new design, the following command creates a configuration file for your design:
    ```
    # JSON Configuration File
    ./flow.tcl -design <design_name> -init_design_config -add_to_designs
    
    # Tcl Configuration File
    ./flow.tcl -design <design_name> -init_design_config -add_to_designs -config_file config.tcl
    ```
    This will create the following directory structure:
    ```
    designs/<design_name>
    ├── config.json (or config.tcl)
    ```
    * **NOTE:** The <design_name> must match the top-level module name of your design _**exactly**_. Otherwise, OpenLane will throw an error (at least by the `run_synthesis` stage).
  * It is recommended to place the verilog files of the design in a src directory inside the folder of the design as following:
    ```
    designs/<design_name>
    ├── config.tcl
    ├── src
    │   ├── design.v
    ```

### 15.2.3 Running the flow for the design:
  * To run the automated flow:
    ```
    ./flow.tcl -design <design_name>
    ```
  * To run the flow interactively ([Interactive Mode](https://openlane.readthedocs.io/en/latest/reference/interactive_mode.html)):
    ```
    ./flow.tcl -interactive
    ```
    A tcl shell will be opened where the openlane package is to be sourced
    ```
    package require openlane 0.9
    ```
    Now, the following main commands run the various major steps of the Physical design flow:
    ```
    0. Any valid Tcl code
    1. prep -design <design> [-tag TAG] [-config CONFIG] [-init_design_config] [-overwrite]
    2. run_synthesis
    3.run_floorplan
    4.run_placement
    5.run_cts
    6.run_routing
    7.a write_powered_verilog 
    7.b set_netlist $::env(routing_logs)/$::env(DESIGN_NAME).powered.v
    8. run_magic
    9. run_magic_spice_export
    10. run_magic_drc
    11. run_lvs
    12. run_antenna_check
    ```

### 15.2.4 Some FYI Notes:
  * [Command-Line Arguments that can be passed to flow.tcl](https://openlane.readthedocs.io/en/latest/reference/cli.html)

  | Argument | Description |
  |:---|:---|
  | `-tag <name>` <br>  (Optional) | Specifies a “name” for a specific run. If the tag is not specified, a timestamp is generated for identification of that run. |
  | `-overwrite` <br>  (Optional) | Flag to overwrite an existing run with the same tag |
  | `-synth_explore` | If enabled, synthesis exploration will be run (only synthesis exploration), which will try out the available synthesis strategies against the input design. |
  | `-verbose <level>` <br>  (Optional) | 0: Outputs only high-level messages <br>  1: Also ouputs some of the inner workings of the flow scripts <br>  >=2: Forwards outputs from all tools |
  
  * [Design configuration files: config.json (or config.tcl)](https://openlane.readthedocs.io/en/latest/reference/configuration_files.html)  
    Each OpenLane-compatible design must come with a configuration file written in either JSON or Tcl.
  * [Flow Configuration variables](https://openlane.readthedocs.io/en/latest/reference/configuration.html)
  * [PDK Configuration variables](https://openlane.readthedocs.io/en/latest/reference/pdk_configuration.html)
  * [Tcl commands available in OpenLane](https://openlane.readthedocs.io/en/latest/reference/openlane_commands.html)
    * When running the flow in interactive mode, use the `-verbose <level>` flag with the `prep -design <design_name>` command to set the verbose output level (2 and greater outputs everything including tool outputs).
      Example: `prep -design riscv_core -tag run1 -overwrite -verbose 2`

## 15.3 Synthesis Results
  * Some synthesis settings modified:
    ```
    set ::env(SYNTH_STRATEGY) "DELAY 0"
    set ::env(SYNTH_BUFFERING) 1
    set ::env(SYNTH_SIZING) 1
    set ::env(SYNTH_SPLITNETS) 0
    set ::env(SYNTH_MAX_FANOUT) 6
    ```
  * In addition, the `Openlane/scripts/yosys/synth.tcl` file was modified, with the sequence of yosys/ abc synthesis commands being modified in accordance with [this comment from Yosys issue #4266](https://github.com/YosysHQ/yosys/issues/4266#issuecomment-2019126857).
  * **<details><summary>Synthesis cell usage statistics:</summary>**
    ```
    === riscv_core ===
    
       Number of wires:               8458
       Number of wire bits:          11999
       Number of public wires:         176
       Number of public wire bits:    3717
       Number of memories:               0
       Number of memory bits:            0
       Number of processes:              0
       Number of cells:              11997
         sky130_fd_sc_hd__a2111o_2      10
         sky130_fd_sc_hd__a2111oi_2      2
         sky130_fd_sc_hd__a211o_2      132
         sky130_fd_sc_hd__a211oi_2      38
         sky130_fd_sc_hd__a21bo_2        3
         sky130_fd_sc_hd__a21boi_2       6
         sky130_fd_sc_hd__a21o_2        41
         sky130_fd_sc_hd__a21oi_2      894
         sky130_fd_sc_hd__a221o_2      442
         sky130_fd_sc_hd__a221oi_2       3
         sky130_fd_sc_hd__a22o_2       318
         sky130_fd_sc_hd__a22oi_2        5
         sky130_fd_sc_hd__a2bb2o_2       4
         sky130_fd_sc_hd__a311o_2       54
         sky130_fd_sc_hd__a311oi_2       2
         sky130_fd_sc_hd__a31o_2        72
         sky130_fd_sc_hd__a31oi_2       41
         sky130_fd_sc_hd__a32o_2       216
         sky130_fd_sc_hd__a32oi_2        2
         sky130_fd_sc_hd__a41o_2         6
         sky130_fd_sc_hd__a41oi_2        1
         sky130_fd_sc_hd__and2_2        40
         sky130_fd_sc_hd__and2b_2       24
         sky130_fd_sc_hd__and3_2       104
         sky130_fd_sc_hd__and3b_2        7
         sky130_fd_sc_hd__and4_2        32
         sky130_fd_sc_hd__and4b_2       23
         sky130_fd_sc_hd__and4bb_2      28
         sky130_fd_sc_hd__buf_1       2242
         sky130_fd_sc_hd__buf_2        940
         sky130_fd_sc_hd__conb_1       775
         sky130_fd_sc_hd__dfxtp_2     1907
         sky130_fd_sc_hd__inv_2         80
         sky130_fd_sc_hd__mux2_2        78
         sky130_fd_sc_hd__nand2_2      105
         sky130_fd_sc_hd__nand3_2       17
         sky130_fd_sc_hd__nand3b_2       2
         sky130_fd_sc_hd__nand4_2        1
         sky130_fd_sc_hd__nand4b_2       1
         sky130_fd_sc_hd__nor2_2       118
         sky130_fd_sc_hd__nor3_2         1
         sky130_fd_sc_hd__nor3b_2        5
         sky130_fd_sc_hd__nor4_2        12
         sky130_fd_sc_hd__nor4b_2        5
         sky130_fd_sc_hd__o2111ai_2      3
         sky130_fd_sc_hd__o211a_2       77
         sky130_fd_sc_hd__o211ai_2      31
         sky130_fd_sc_hd__o21a_2       944
         sky130_fd_sc_hd__o21ai_2       74
         sky130_fd_sc_hd__o21ba_2      516
         sky130_fd_sc_hd__o21bai_2      32
         sky130_fd_sc_hd__o221a_2       31
         sky130_fd_sc_hd__o221ai_2       4
         sky130_fd_sc_hd__o22a_2         5
         sky130_fd_sc_hd__o22ai_2        2
         sky130_fd_sc_hd__o2bb2a_2      10
         sky130_fd_sc_hd__o2bb2ai_2      4
         sky130_fd_sc_hd__o311a_2       19
         sky130_fd_sc_hd__o311ai_2       1
         sky130_fd_sc_hd__o31a_2       935
         sky130_fd_sc_hd__o31ai_2        1
         sky130_fd_sc_hd__o32a_2        12
         sky130_fd_sc_hd__o41a_2        45
         sky130_fd_sc_hd__or2_2         75
         sky130_fd_sc_hd__or2b_2        37
         sky130_fd_sc_hd__or3_2         63
         sky130_fd_sc_hd__or3b_2        18
         sky130_fd_sc_hd__or4_2        133
         sky130_fd_sc_hd__or4b_2        22
         sky130_fd_sc_hd__or4bb_2        4
         sky130_fd_sc_hd__xnor2_2       27
         sky130_fd_sc_hd__xor2_2        33
    ```
    </details>

  * **Chip area for module** `'\riscv_core': 115293.075200`

## 15.4 Placement (Pre-CTS)
  * **Placement optimizations:**
    ```
    Reading design constraints file at '/openlane/designs/riscv_core/src/riscv_base_post_cts.sdc'…
    [INFO]: Setting output delay to: 4.0
    [INFO]: Setting input delay to: 4.0
    [INFO]: Setting load to: 0.01765
    [INFO]: Setting clock uncertainty to: 0.25
    [INFO]: Setting clock transition to: 0.15
    [INFO]: Setting timing derate to: 5.0 %
    [INFO]: Setting RC values...
    [INFO RSZ-0027] Inserted 1 input buffers.
    [INFO RSZ-0028] Inserted 10 output buffers.
    [INFO RSZ-0058] Using max wire length 8182um.
    [INFO RSZ-0034] Found 80 slew violations.
    [INFO RSZ-0035] Found 14 fanout violations.
    [INFO RSZ-0036] Found 11 capacitance violations.
    [INFO RSZ-0038] Inserted 303 buffers in 94 nets.
    [INFO RSZ-0039] Resized 9488 instances.
    [INFO RSZ-0042] Inserted 513 tie sky130_fd_sc_hd__conb_1 instances.
    [INFO RSZ-0042] Inserted 262 tie sky130_fd_sc_hd__conb_1 instances.
    ```
  * **Design area**: `124358 u^2 33% utilization`

## 15.5 STA Comparison: Post-synthesis vs. Post-Placement (Pre-CTS)
| Post-Synthesis | Post-Placement (Pre-CTS) |
|:---:|:---:|
| ![D15_riscv_core_post-synthesis_STA](/docs/images/D15_riscv_core_post-synthesis_STA.png) | ![D15_riscv_core_post-placement_STA](/docs/images/D15_riscv_core_post-placement_STA.png) |

<br>

|   |  
|:---:|
| ![D15_riscv_core_synthesis_vs_post-placement_STA_wns](/docs/images/D15_riscv_core_synthesis_vs_post-placement_STA_wns.png) |
| ![D15_riscv_core_synthesis_vs_post-placement_STA_tns](/docs/images/D15_riscv_core_synthesis_vs_post-placement_STA_tns.png) |
| ![D15_riscv_core_synthesis_vs_post-placement_STA_worst_setup_slack](/docs/images/D15_riscv_core_synthesis_vs_post-placement_STA_worst_setup_slack.png) |
| ![D15_riscv_core_synthesis_vs_post-placement_STA_worst_hold_slack](/docs/images/D15_riscv_core_synthesis_vs_post-placement_STA_worst_hold_slack.png) |

<br>

_________________________________________________________________________________________________________  
# Day 22 - Post-CTS, Post-Routing STA analysis of your Design

## 16.1 STA Comparison
**OpenLane Configuration:**
  * [config.tcl](/code/openlane/designs/riscv_core/config.tcl)
  * [sky130A_sky130_fd_sc_hd_config.tcl](/code/openlane/designs/riscv_core/sky130A_sky130_fd_sc_hd_config.tcl)
  * [Pre-CTS SDC File](/code/openlane/designs/riscv_core/src/riscv_base_pre_cts.sdc)
  * [Post-CTS SDC File](/code/openlane/designs/riscv_core/src/riscv_base_post_cts.sdc)

**Design Area**
  * **Synthesis**: `115293.075200`
  * **Placement**: `124358 u^2 33% utilization`
  * **CTS**: `129960 u^2 34% utilization`

| **Post-Synthesis** <br>  ![D16_riscv_core_post-synthesis_STA](/docs/images/D16_riscv_core_post-synthesis_STA.png) | **Post-Placement (Pre-CTS)** <br>  ![D16_riscv_core_post-placement_STA](/docs/images/D16_riscv_core_post-placement_STA.png) |
|:---:|:---:|
| **Post-Routing** <br>  ![D16_riscv_core_post-Route_STA](/docs/images/D16_riscv_core_post-Route_STA.png) | **Post-CTS** <br>  ![D16_riscv_core_post-CTS_STA](/docs/images/D16_riscv_core_post-CTS_STA.png) |

|   |  
|:---:|
| ![D16_riscv_core_PostCTS_PostRoute_STA_wns](/docs/images/D16_riscv_core_PostCTS_PostRoute_STA_wns.png) |
| ![D16_riscv_core_PostCTS_PostRoute_STA_tns](/docs/images/D16_riscv_core_PostCTS_PostRoute_STA_tns.png) |
| ![D16_riscv_core_PostCTS_PostRoute_STA_worst_setup_slack](/docs/images/D16_riscv_core_PostCTS_PostRoute_STA_worst_setup_slack.png) |
| ![D16_riscv_core_PostCTS_PostRoute_STA_worst_hold_slack](/docs/images/D16_riscv_core_PostCTS_PostRoute_STA_worst_hold_slack.png) |

**NOTE:** Writing powered verilog netlist
  ```
  write_powered_verilog -output_def riscv_core_powered_verilog.def -output_nl $::env(routing_logs)/$::env(DESIGN_NAME).nl.v -output_pnl $::env(routing_logs)/$::env(DESIGN_NAME).powered.v
  set_netlist $::env(routing_logs)/$::env(DESIGN_NAME).powered.v
  ```

<!--
  | **Post-Synthesis** <br>  ![D16_riscv_core_post-synthesis_STA2](/docs/images/D16_riscv_core_post-synthesis_STA2.png) | **Post-Placement (Pre-CTS)** <br>  ![D16_riscv_core_post-placement_STA2](/docs/images/D16_riscv_core_post-placement_STA2.png) |
  |:---:|:---:|
  | **Post-Routing** <br>  ![D16_riscv_core_post-Route_STA2](/docs/images/D16_riscv_core_post-Route_STA2.png) | **Post-CTS** <br>  ![D16_riscv_core_post-CTS_STA2](/docs/images/D16_riscv_core_post-CTS_STA2.png) |
-->


<br>

_________________________________________________________________________________________________________  

