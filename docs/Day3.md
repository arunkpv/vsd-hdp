[Back to TOC](../README.md)  
[Prev: Day2](Day2.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day4](Day4.md)  
_________________________________________________________________________________________________________  
# Day 3: Logic Optimization
Logic optimization is a process of finding an equivalent representation of the specified logic circuit under one or more specified constraints. The goal of logic optimization of a given circuit is to obtain the smallest logic circuit that evaluates to the same values as the original one.

In terms of Boolean algebra, the optimization of a complex Boolean expression is a process of finding a simpler one, which would upon evaluation ultimately produce the same results as the original one.

## 3.1 Combinational Logic Optimizations  
The combinational logic is simplified to the most optimized form which is efficient in terms of area & power savings.

### 3.1.1 Constant Propagation
This is a direct optimization method wherein the Boolean expression of the synthesized logic is simplified if any of the inputs are "a constant" and subsequently some of the logic gate outputs also propagate a constant value always.  

### 3.1.2 Boolean Logic Optimization
The various Boolean expression optimization techniques like K-maps (graphical), Quine-McLusky, reduction to standard SOP/ POS forms best suited for the cell library/ technology etc.  

**Note:**  
  - The command to perform logic optimization in Yosys is `opt_clean`.  
  - Additionally, for a hierarchical design involving multiple sub-modules, the design must be flattened by running the `flatten` command before executing the `opt_clean` command.

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

### 3.1.3 Lab 1: opt_check.v
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
![D3_opt_check](/docs/images/D3_opt_check.png)  
<br>
_________________________________________________________________________________________________________  

### 3.1.3 Lab 2: opt_check2.v
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
![D3_opt_check2](/docs/images/D3_opt_check2.png)  
<br>
_________________________________________________________________________________________________________  

### 3.1.3 Lab 3: opt_check3.v
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
![D3_opt_check3](/docs/images/D3_opt_check3.png)  
<br>
_________________________________________________________________________________________________________  

### 3.1.3 Lab 4: opt_check4.v
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
![D3_opt_check4](/docs/images/D3_opt_check4.png)  
<br>
_________________________________________________________________________________________________________  

### 3.1.3 Lab 5: multiple_module_opt.v
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
![D3_multiple_module_opt](/docs/images/D3_multiple_module_opt.png)  
<br>
_________________________________________________________________________________________________________  

### 3.1.3 Lab 6: multiple_module_opt2.v
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
![D3_multiple_module_opt2](/docs/images/D3_multiple_module_opt2.png)  
<br>

_________________________________________________________________________________________________________  

## 3.2 Sequential Logic Optimizations

### 3.2.1 Constant Propagation
Optimization technique used when a constant value is propagated through a flip-flop -- i.e., irrespective of the state of the triggering signals (CLK, Reset, Set), there are no transitions in the flip-flop output.  
<br>

***[Other Advanced optimization methods not covered by examples in detail:]***  

### 3.2.2 State optimization
Unused states in the sequential design are optimized and/or the total states needed in the FSM are minimized.  

### 3.2.3 Cloning
This is a physically-aware (PnR-aware) optimization method where some of the flops in the design are cloned/ duplicated so that the timing can be met post-PnR for the timing arcs involved (provided there is already some minimum positive slack available).  

### 3.2.4. Retming
The pipelining flops in the design are placed optimally so that the combinational delay at each pipeline stage is more or less equalized so that the maximum clock frequency can be increased.  
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

### 3.2.5 Lab 1: dff_const1.v
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

| Behavioral Simulation | ![D3_dff_const1_waves](/docs/images/D3_dff_const1_waves.png)  |
|-----------------------|------------------|
| **Synthesis Result** | ![D3_dff_const1](/docs/images/D3_dff_const1.png) |  
<br>

_________________________________________________________________________________________________________

### 3.2.5 Lab 2: dff_const2.v
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

| Behavioral Simulation | ![D3_dff_const2_waves](/docs/images/D3_dff_const2_waves.png) |
|-----------------------|------------------|
| **Synthesis Result** | ![D3_dff_const2](/docs/images/D3_dff_const2.png) |
<br>

_________________________________________________________________________________________________________  

### 3.2.5 Lab 3: dff_const3.v
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

| Behavioral Simulation | ![D3_dff_const3_waves](/docs/images/D3_dff_const3_waves.png) |
|-----------------------|------------------|
| **Synthesis Result** | ![D3_dff_const3](/docs/images/D3_dff_const3.png) |
<br>

_________________________________________________________________________________________________________  

### 3.2.5 Lab 4: dff_const4.v
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

| Behavioral Simulation | ![D3_dff_const4_waves](/docs/images/D3_dff_const4_waves.png) |
|-----------------------|------------------|
| **Synthesis Result** | ![D3_dff_const4](/docs/images/D3_dff_const4.png) |
<br>

_________________________________________________________________________________________________________  

### 3.2.5 Lab 5: dff_const5.v
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

| Behavioral Simulation | ![D3_dff_const5_waves](/docs/images/D3_dff_const5_waves.png) |
|-----------------------|------------------|
| **Synthesis Result** | ![D3_dff_const5](/docs/images/D3_dff_const5.png) |
<br>

_________________________________________________________________________________________________________  

### 3.2.5 Lab 6: counter_opt.v
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

| Behavioral Simulation | ![D3_counter_opt_waves](/docs/images/D3_counter_opt_waves.png) |
|-----------------------|------------------|
| **Synthesis Result w/o opt_clean switch** | ![D3_counter_opt_without_optimization](/docs/images/D3_counter_opt_without_optimization.png) |
| **Synthesis Result with opt_clean switch** | ![D3_counter_opt](/docs/images/D3_counter_opt.png) |

<br>

_________________________________________________________________________________________________________  

### 3.2.5 Lab 7: counter_opt2.v
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

| Behavioral Simulation | ![D3_counter_opt2_waves](/docs/images/D3_counter_opt2_waves.png) |
|-----------------------|------------------|
| **Synthesis Result** | ![D3_counter_opt2_with_optimizations](/docs/images/D3_counter_opt2_with_optimizations.png) |
<br>

_________________________________________________________________________________________________________  

[Prev: Day2](Day2.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day4](Day4.md)  
