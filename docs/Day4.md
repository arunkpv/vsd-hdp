# Day 4
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
```
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
