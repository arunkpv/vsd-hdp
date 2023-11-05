# VSD-HDP
This GitHub repository is created as part of attending the VLSI Hardware Development Program ([VSD-HDP](https://www.vlsisystemdesign.com/hdp/), Cohort: 21 October, 2023 – 29 December, 2023).
<br />
<br />
 **Progress Status**
 | Day # | Topic(s) Covered |
 |---|---|
 |[Day 0](#day-0) | GitHub repo creation, System/ Tools Setup |
 |[Day 1](#day-1) | Introduction to Verilog RTL design and Synthesis |
 |[Day 2](#day-2) | <ol><li>Familiarization of .lib file structure and various timing models (QTMs/ETMs)</li><li>Hierarchical vs. Flat synthesis</li><li>Various Flip-Flop designs</li></ol> |
 |[Day 3](#day-3) | Logic Synthesis Optimizations<ol><li>Combinational</li><li>Sequential</li></ol> |
 |[Day 4](#day-4) | <ol><li>Gate Level Simulation</li><li>Verilog Blocking vs. Non-blocking assignment</li><li>Synthesis-Simulation mismatch</li></ol> |


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
    ![day0_yosys](https://github.com/arunkpv/vsd-hdp/assets/79094513/08e41e35-5f95-4416-95af-011c6fb81ff8)
  
 **2. iverilog - Icarus Verilog**  
   - Install from official Ubuntu repository:
     ```
     sudo apt-get install iverilog
     ```
     
   - Invoke from shell:  
     ![day0_iverilog](https://github.com/arunkpv/vsd-hdp/assets/79094513/5edb8420-274d-4309-8d23-ff3176a21094)
  
 **3. GTKWave**
   - Install from official Ubuntu repository:
     ```
     sudo apt-get install gtkwave
     ```
     
   - Invoke from shell:  
     ![day0_gtkwave](https://github.com/arunkpv/vsd-hdp/assets/79094513/4a58eb72-04c6-41fb-9d1f-6f2f7dfd1c10)  
  
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
![day1_lab1_2input_mux_iverilog_gktwave](https://github.com/arunkpv/vsd-hdp/assets/79094513/f877ae83-789d-4f2c-b8d1-5ff33b641f32)
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
![day1_lab3_2input_mux_synth_logical_diagram](https://github.com/arunkpv/vsd-hdp/assets/79094513/7658d852-9881-4e5b-970f-a9bfc376a2fd)
  
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
  ![day2_multiple_modules_hier](https://github.com/arunkpv/vsd-hdp/assets/79094513/a2087ca8-0b43-4549-b642-23d5faecb35f)
  <br />
  <br />
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
________________________________________________________________________________________________________________________
  
  **2. Flattened**  
  To flatten the hierarchical design, the command **flatten** is used following which we can write the netlist, as shown below:  
  ```
  flatten
  write_verilog -noattr multiple_modules_flat.v
  show -stretch multiple_modules 
  ```
    
  Synthesis result after flattening:  
  ![day2_multiple_modules_flat](https://github.com/arunkpv/vsd-hdp/assets/79094513/7e77fe42-0cda-4a56-a3b2-eff054840783)
  <br />
  <br />
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
  | ![dff_asyncres_reset_deassertion](https://github.com/arunkpv/vsd-hdp/assets/79094513/d655f107-3caa-4978-8baa-b14951a2dcc7) | ![dff_asyncres_reset_asserted](https://github.com/arunkpv/vsd-hdp/assets/79094513/0e160a39-e4c6-41d5-b38c-fdead597bc7b) |
  
  **Synthesis Result:**
  ![dff_asyncres](https://github.com/arunkpv/vsd-hdp/assets/79094513/9540a5af-44a2-400d-9f97-9080f0386b5a)  
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
  | ![dff_syncres_reset_deassertion](https://github.com/arunkpv/vsd-hdp/assets/79094513/0f85bc8b-f8d0-4456-8343-b492b95b7982) | ![dff_syncres_reset_assertion](https://github.com/arunkpv/vsd-hdp/assets/79094513/63d9e906-9e74-4810-8a17-956bca82ca78) |
    
  **Synthesis Result:**
  ![dff_syncres](https://github.com/arunkpv/vsd-hdp/assets/79094513/8c7466ee-ceae-4703-9b93-9138ecc63522)  
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
  ![dff_asyncres_syncres_waves](https://github.com/arunkpv/vsd-hdp/assets/79094513/f93df1c2-7123-4fd5-b66c-086726891405)

    
  **Synthesis Result:**
  ![dff_asyncres_syncres](https://github.com/arunkpv/vsd-hdp/assets/79094513/aa337785-ae19-4872-b253-229b74e7fded)
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
  ![mult_2](https://github.com/arunkpv/vsd-hdp/assets/79094513/fb455910-b896-4b2b-ae6d-b84609577dba)  
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
_________________________________________________________________________________________________________  

<br>

## Day 3
### Combinational Logic Optimizations  
The combinational logic is simplified to the most optimized form which is efficient in terms of area & power savings.  
**1. Constant Propagation** : This is a direct optimization method wherein the Boolean expression of the synthesized logic is simplified if any of the inputs are "a constant" and subsequently some of the logic gate outputs also propagate a constant value always.  
**2. Boolean Logic Optimization** : The various Boolean expression optimization techniques like K-maps (graphical), Quine-McLusky, reduction to standard SOP/ POS forms best suited for the cell library/ technology etc.  
<br>

**NOTE :** The command to perform combinational logic optimization in Yosys is ```opt_clean```.  
Additionally, for a hierarchical design involving multiple sub-modules, the design must be flattened by running the ```flatten``` command before executing the ```opt_clean``` command.
```
USAGE:
After the synth -top <module_name> command is executed, do:
opt_clean -purge

This command identifies wires and cells that are unused and removes them.
The additional switch, purge also removes the internal nets if they have a public name
```

#### Lab 6: Example 1: opt_check.v 
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
![opt_check](https://github.com/arunkpv/vsd-hdp/assets/79094513/3a580389-a7cb-4310-82cb-d5d431c12deb)  
<br>
_________________________________________________________________________________________________________  

#### Lab 6: Example 2: opt_check2.v
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
![opt_check2](https://github.com/arunkpv/vsd-hdp/assets/79094513/651d0599-ed95-443e-93fe-b796a1a75771)  
<br>
_________________________________________________________________________________________________________  

#### Lab 6: Example 3: opt_check3.v
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
![opt_check3](https://github.com/arunkpv/vsd-hdp/assets/79094513/ac7e0e36-3b22-4a43-9ee5-51a36a2cf088)  
<br>
_________________________________________________________________________________________________________  

#### Lab 6: Example 4: opt_check4.v
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
![opt_check4](https://github.com/arunkpv/vsd-hdp/assets/79094513/9da67324-e6c9-474e-a3f3-d246f111e5ab)  
<br>
_________________________________________________________________________________________________________  

#### Lab 6: Example 5: multiple_module_opt.v
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
![multiple_module_opt](https://github.com/arunkpv/vsd-hdp/assets/79094513/35158a89-6788-45a2-b405-301ec891c6c5)  
<br>
_________________________________________________________________________________________________________  

#### Lab 6: Example 6: multiple_module_opt2.v
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
![multiple_module_opt2](https://github.com/arunkpv/vsd-hdp/assets/79094513/38459afd-1cdf-43f3-ba93-a11364fbc6fc)  
<br>
_________________________________________________________________________________________________________  

### Sequential Logic Optimizations
**1. Constant Propagation** : Optimization technique used when a constant value is propagated through a flip-flop -- i.e., irrespective of the state of the triggering signals (CLK, Reset, Set), there are no transitions in the flip-flop output.  
<br>

***[Other Advanced optimization methods not covered by examples in detail:]***  
**2. State optimization** : Unused states in the sequential design are optimized and/or the total states needed in the FSM are minimized.  
**3. Cloning** : This is a physically-aware (PnR-aware) optimization method where some of the flops in the design are cloned/ duplicated so that the timing can be met post-PnR for the timing arcs involved (provided there is already some minimum positive slack available).  
**4. Retming** : The pipelining flops in the design are placed optimally so that the combinational delay at each pipeline stage is more or less equalized so that the maximum clock frequency can be increased.  
