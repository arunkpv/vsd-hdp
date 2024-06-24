[Back to TOC](../README.md)  
[Prev: Day5](Day5.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day7](Day7.md)  
_________________________________________________________________________________________________________  
# Day 6: Introduction to ABI and basic verification flow
In computer software, an application binary interface (ABI) is an interface between two binary program modules. Often, one of these modules is a library or operating system facility, and the other is a program that is being run by a user.
An ABI defines how data structures or computational routines are accessed in machine code, which is a low-level, hardware-dependent format.  
_Reference:_ [Application binary interface](https://en.wikipedia.org/wiki/Application_binary_interface)  
<br>

RISC-V CPU architecture has 32 registers. Application programmer, can access each of these 32 registers through its ABI name; for example, if we need to move the stack pointer, the command ```addi sp, sp, -16``` will decrement the SP by 0x10, where "sp" is the ABI name of stack pointer. The following table shows the ABI Integer register calling convention :  
![RV64I_IntegerRegisterConvention](/docs/images/D6_RV64I_IntegerRegisterConvention.png)
<br>

For more detailed information, refer to the [RISC-V ABI Specification v1.0](https://drive.google.com/file/d/1Ja_Tpp_5Me583CGVD-BIZMlgGBnlKU4R/view)  

## 6.1 Lab: Rewrite the program to find the sum of first N natural numbers utilizing ABI function calls

**C Program:** 1to9_custom.c
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

**Assembly program:** load.s
```asm
.section .text
.global load
.type load, @function

load:
    add 	a4, a0, zero //Initialize sum register a4 with 0x0
    add 	a2, a0, a1   // store count of 10 in register a2. Register a1 is loaded with 0xa
                       // (decimal 10) from main program
    add	a3, a0, zero   // initialize intermediate sum register a3 by 0
loop:
    add 	a4, a3, a4   // Incremental addition
    addi 	a3, a3, 1    // Increment intermediate register by 1	
    blt 	a3, a2, loop // If a3 is less than a2, branch to label named <loop>
    add	a0, a4, zero   // Store final result to register a0 so that it can be read by
                       // main program
    ret
```
<br>

The program can be compiled using the gcc and simulated using Spike as follows:
| ![D6_1to9_custom_ABI](/docs/images/D6_1to9_custom_ABI.png) |
|:---:|
<br>

Disassembly of object code of above progam:
| ![D6_ABI_Disassembly](/docs/images/D6_ABI_Disassembly.png) |
|:---:|
| ![D6_ABI_load_loop_subroutines](/docs/images/D6_ABI_load_loop_subroutines.png) |
<br>

## 6.2 Lab: Simulate the above C program on a RISC-V CPU
For this exercise, we will use the design files from the following GitHub repository: [https://github.com/kunalg123/riscv_workshop_collaterals.git](https://github.com/kunalg123/riscv_workshop_collaterals.git)  

The following figure shows the Hardware + Firmware verification flow:
| ![D6_Basic_Verification_Flow](/docs/images/D6_Basic_Verification_Flow.png) |
|:---:|

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

To run the flow, execute the following file from shell:  

**rv32im.sh:**
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

| ![D6_Lab_firmware_iverilog_tb_simulation](/docs/images/D6_Lab_firmware_iverilog_tb_simulation.png) |
|:---:|
<br>

______________________________________________________________________________________________________

### **Addendum: To view the waves in Gktwave**  
To dump the VCD file from the simulation using iverilog and further view the waves in Gktwave:
  * In `testbench.v`, comment out the undef line for WRITE_VCD and add a define for the same:
    ```
    //`undef WRITE_VCD
    define WRITE_VCD
    ```
  * Additionally, in `picorv32.v`, add the following define to enable the debug wires to view the internal Register File:
    ```
    `define DEBUGREGS
    ```

  * Modified source files:  
    _**1to9_custom.c**_
    ```c
    #include <stdio.h>
    
    extern int load(int x, int y); 
    
    int main() {
      int result = 0;
      int count = 10;
      result = load(0x0, count+1);
      printf("Sum of number from 1 to %d is %d\n", count, result); 
    }
    ```

    _**load.S**_
    ```assembly
    .section .text
    .global load
    .type load, @function
    
    load:
        add 	a4, a0, zero  // Initialize sum register a4 with 0x0
        add 	a2, a0, a1    // storecount of 10 in register a2. Register a1 is loaded with 0xa (decimal 10) from main program
        add	a3, a0, zero    // Initialize intermediate sum register a3 by 0
    loop:
        add 	a4, a3, a4    // Incremental addition
        addi 	a3, a3, 1     // Increment intermediate register by 1	
        blt 	a3, a2, loop  // If a3 is less than a2, branch to label named <loop>
        add a0, a4, zero    // Store final result to register a0 so that it can be read by main program
        ret
    ```
  
  **Output:**
  | ![D6_picorv32_waves_1](/docs/images/D6_picorv32_waves_1.png) |
  |:---:|
  | ![D6_picorv32_waves_2](/docs/images/D6_picorv32_waves_2.png) |

_________________________________________________________________________________________________________  
[Prev: Day5](Day5.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day7](Day7.md)  
