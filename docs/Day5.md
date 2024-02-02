[Back to TOC](../README.md)  
[Prev: Day4](Day4.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day6](Day6.md)  
_________________________________________________________________________________________________________  
# Day 5
## Introduction to RISC-V ISA and GNU Compiler Toolchain

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
[Prev: Day4](Day4.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day6](Day6.md)  
