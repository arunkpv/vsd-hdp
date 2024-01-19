[Back to TOC](../README.md)  
[Prev: Day7](Day7.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day9](Day9.md)  
_________________________________________________________________________________________________________  
# Day 8
## Basic RISC-V CPU Microarchitecture
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
[Prev: Day7](Day7.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day9](Day9.md)  
