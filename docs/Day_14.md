[Back to TOC](../README.md)  
[Prev: Day 13](Day_13.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 15](Day_15.md)  
_________________________________________________________________________________________________________  
# Days 14-18: Circuit Design using SKY130 PDK

# Day 14: CMOS Fundamentals

## 14.1 What is SPICE and Why do we need SPICE simulations ?
SPICE (Simulation Program with Integrated Circuit Emphasis) was originally developed in the 1970s at University of California, Berkeley. It solves the nonlinear differential equations describing components such as transistors, resistors, capacitors, and voltage sources.  

Based on the original SPICE, there are many SPICE versions available - both free (like Ngspice, Xyce, LTSpice, TINA-TI) as well as commercial (HSPICE, PSPICE). All versions of SPICE read an input file and generate an output  with results, warnings, and error messages. The input file is often called a _**SPICE deck**_ and each line is called a _**card**_ because it was once provided to a mainframe as a deck of punch cards.  

The input file contains a netlist consisting of components and nodes. It also contains simulation options, analysis commands, and device models. The netlist can be entered by hand or extracted from a circuit schematic or layout in a CAD program.

In Digital VLSI Design, the characterization of the various Standard Cells and macros to generate the various models for timing, power and noise analyses all rely on SPICE.  

| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Weste_Harris_1](/docs/images/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Weste_Harris_1.png) |
|:---:|

## 14.2 NMOS Transistor

<br>

_________________________________________________________________________________________________________  
[Prev: Day 13](Day_13.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 15](Day_15.md)  

