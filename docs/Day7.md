[Back to TOC](../README.md)  
[Prev: Day6](Day6.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day8](Day8.md)  
_________________________________________________________________________________________________________  
# Day 7
## Digital Logic with TL-Verilog and Makerchip
  
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
  
### Combinational Logic
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

### Sequential Logic
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

### Pipelined Logic
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

### Validity
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
[Prev: Day6](Day6.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day8](Day8.md)  
