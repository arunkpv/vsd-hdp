[Back to TOC](../README.md)  
[Prev: Day1](Day1.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day3](Day3.md)  
_________________________________________________________________________________________________________  

# Day 2: Timing libs, Hierarchical vs. Flat Synthesis, Flip-Flop coding styles

## 2.1 Familiarization of the .lib file structure and various timing models (QTMs/ETMs)
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
  
## 2.2 Lab: Hierarchical vs. Flat Synthesis
In this experiment, we will take a look at how the Yosys tool performs the synthesis and generates the netlst for a multi-module design with and without preserving the design hierarchy.  
For this example, we will use the design file, `multiple_modules.v`, which contains some logic implementation using two sub-modules.  

### 2.2.1 Hierarchical Design
In hierarchical synthesis, the design is broken down into multiple hierarchical levels. Each level represents a different abstraction of the design, ranging from high-level functional blocks to detailed logic gates.  
The ASIC or chip gets divided into smaller and simpler modules or blocks, each having its own functionality and interface, and  the top-level module defines the connectivity of the various instantiation(s) of these sub-modules thus realizing the overall functionality/ behavior as well as performance of the chip.

  - **Advantages:**
    - **Modularity & reusability:** Allows designers to manage complexity by breaking down the design into manageable blocks and thus allowing reusability of these blocks.
    - **Ease of Design:** Reduced complexity now that each team is dealing with smaller sub-modules. This facilitates a "Divide and conquer" approach in parallelising the design effort as different teams and/or engineers can work on different modules independently leading to improved productivity. Faster runtimes for synthesis and analysis EDA tools since each team will be working on individual modules which are small compared to the complete chip.
    - **Optimization:** Each block can be synthesized independently, optimizing performance and area at each level.

  - **Applications:**
    - Commonly used in complex designs where the entire circuit cannot be synthesized at once due to size or complexity, like modern SoCs, CPUs, GPUs, DSPs etc.

  - **Disadvantages:**
    - **Hierarchical Partitioning Overhead:** Creating and managing multiple hierarchical levels requires careful planning and overhead in terms of design partitioning and inter-level communication.
    - **Timing Closure Challenges:** Timing closure can be more challenging in hierarchical synthesis due to the interaction between timing constraints at different levels. Ensuring timing requirements are met across all levels can be complex.
    - **Verification Complexity:** Verification tasks become more complex with hierarchical designs, as each level may require separate verification efforts before integration testing can be performed.
    - **Design Consistency:** Maintaining design consistency across different levels of hierarchy (especially with different designers working on different modules) can be a challenge, leading to potential integration issues.

<br>

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
  ![D2_multiple_modules_hier](/docs/images/D2_multiple_modules_hier.png)
  <br />
  <br />

<!--
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

### 2.2.2 Flat Design
Flat design approach considers the entire ASIC/ chip as a single monolithic entity. There is no concept of sub-modules or hierarchy andthe entire design is synthesized as a single unit without hierarchical decomposition, directly into the standard cells, IPs and macros available in the design library.

  - **Advantages:**
    - **Simplicity:** Easier for small designs where breaking into hierarchical levels might not be necessary.
    - **Performance Optimization:** Can potentially optimize performance across the entire design as a whole.

  - **Applications:**
    - Suitable for smaller designs where the overhead of managing hierarchical levels may not be justified.
Often used in simpler digital circuits or where the design size does not necessitate hierarchical partitioning.

  - **Disadvantages:**
    - **Scalability Issues:** Flat synthesis becomes impractical for very large designs due to the sheer size and complexity, making it difficult to handle efficiently within a single synthesis pass.
    - **Limited Modularity:** Lack of hierarchical decomposition reduces modularity, making it harder to reuse or independently optimize different parts of the design.
    - **Complexity in Optimization:** Optimizing a large and complex design as a whole can be challenging, as changes in one part of the design can have unintended consequences elsewhere.
    - **EDA Tool Efficiency:** Synthesis tools may struggle to handle large flat designs efficiently, resulting in longer synthesis times or potential resource constraints.

<br>

  To flatten the hierarchical design in Yosys, the command **flatten** is used following which we can write the netlist, as shown below:  
  ```shell
  flatten
  write_verilog -noattr multiple_modules_flat.v
  show -stretch multiple_modules 
  ```
    
  Synthesis result after flattening:  
  ![D2_multiple_modules_flat](/docs/images/D2_multiple_modules_flat.png)
  <br />
  <br />

<!--
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
  ![D2_multiple_modules_hierarchical_vs_flat](/docs/images/D2_multiple_modules_hierarchical_vs_flat.png)
________________________________________________________________________________________________________________________
  
## 2.3 Lab: Various Flip-Flop Designs
Here, we will take a look at the simulation and synthesis of different flip-flops.  
<br>

### 2.3.1 DFF with Asynchronous Reset
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
    To synthesize flip-flops using Ysosys, we need to provide an additional command `dfflibmap` so as to map the internal flip-flop cells to the flip-flop cells in the technology
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
  | ![D2_dff_asyncres_reset_deassertion](/docs/images/D2_dff_asyncres_reset_deassertion.png) | ![D2_dff_asyncres_reset_asserted](/docs/images/D2_dff_asyncres_reset_asserted.png) |
  
  **Synthesis Result:**
  ![D2_dff_asyncres](/docs/images/D2_dff_asyncres.png)  
  
### 2.3.2 DFF with Synchronous Reset
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
  | ![D2_dff_syncres_reset_deassertion](/docs/images/D2_dff_syncres_reset_deassertion.png) | ![D2_dff_syncres_reset_assertion](/docs/images/D2_dff_syncres_reset_assertion.png) |
    
  **Synthesis Result:**
  ![D2_dff_syncres](/docs/images/D2_dff_syncres.png)  
  
### 2.3.3 DFF with both Asynchronous & Synchronous Reset
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
  ![D2_dff_asyncres_syncres_waves](/docs/images/D2_dff_asyncres_syncres_waves.png)

    
  **Synthesis Result:**
  ![D2_dff_asyncres_syncres](/docs/images/D2_dff_asyncres_syncres.png)
_________________________________________________________________________________________________________  
  
## 2.4: Some interesting synthesis optimizations involving multipliers

Here, we will take a look at the synthesis of two special cases of multipliers where no cells are used at all.  

### 2.4.1 Multiply by 2

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
  ![D2_mult_2](/docs/images/D2_mult_2.png)  

### 2.4.2 Multiply a 3-bit number by 9

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
  module mult9(a, y);
    input [2:0] a;
    wire [2:0] a;
    output [5:0] y;
    wire [5:0] y;
    assign y = { a, a };
  endmodule
  ```


  Synthesis result:  
  ![D2_mult9](/docs/images/D2_mult9.png)  
_________________________________________________________________________________________________________  

[Prev: Day1](Day1.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day3](Day3.md)  
