[Back to TOC](../README.md)  
[Prev: Day 13](Day_13.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 15](Day_15.md)  
_________________________________________________________________________________________________________  
# Days 14-18: Circuit Design using SKY130 PDK

# Day 14: CMOS Fundamentals

## 14.1 What is SPICE and why do we need SPICE simulations ?
### 14.1.1 What is SPICE ?
Fabricating ICs is very expensive and time-consuming, so designers need simulation tools to explore the design space and verify designs before they are fabricated. Simulation is cheap, but silicon revisions (even a single Metal layer change) are prohibitively expensive.  

Simulators operate at many levels of abstraction, from process through architecture.
  - Process simulators such as SUPREME predict how factors in the process recipe such as time and temperature affect device physical and electrical characteristics.
  - Circuit simulators such as SPICE and Spectre use device models and a circuit netlist to predict circuit voltages and currents, which indicate performance and power consumption.
  - Logic simulators such as VCS and ModelSim are widely used to verify correct logical operation of designs specified in a hardware description language (HDL).
  - Architecture simulators, sometimes offered with a processor’s development toolkit, work at the level of instructions and registers to predict throughput and memory access patterns, which influence design decisions such as pipelining and cache memory organization.

The various levels of abstraction offer trade-offs between degree of detail and the size of the system that can be simulated. VLSI designers are primarily concerned with circuit and logic simulation.

SPICE (Simulation Program with Integrated Circuit Emphasis) was originally developed in the 1970s at University of California, Berkeley. It solves the nonlinear differential equations describing components such as transistors, resistors, capacitors, and voltage sources.  

Based on the original SPICE, there are many SPICE versions available - both free (like Ngspice, Xyce, LTSpice, TINA-TI) as well as commercial (HSPICE, PSPICE). All versions of SPICE read an input file and generate an output  with results, warnings, and error messages. The input file is often called a _**SPICE deck**_ and each line is called a _**card**_ because it was once provided to a mainframe as a deck of punch cards.  

A circuit simulator is provided with an input file that contains:
  - A _**netlist**_ consisting of components and nodes detailing the circuit connectivity.  
    The netlist can be entered by hand or extracted from a circuit schematic or layout in a CAD program.
  - Component behaviour by means of _**device models**_ and _**model parameters**_.
  - The Initial state of the circuit -- _**initial conditions**_ 
  - Inputs to the circuit, called _**stimulus**_
  - _**Simulation options**_ & _**analysis commands**_ that explain the type of simulation to be run.


| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Ngspice_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Ngspice_1.png) | ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Ngspice_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Ngspice_2.png) |
|:---:|:---:|
| | |

**Analysis Types supported by SPICE:**
| Analysis Type | Details |
|:---|:---|
| DC Analysis | Find the DC operating point of the circuit i.e., all voltages and currents |
| AC Small-Signal Analysis | AC analysis is limited to analog nodes and represents the small signal, sinusoidal solution of the analog system described at a particular frequency or set of frequencies.
| Transient Analysis | Transient analysis is an extension of DC analysis to the time domain. In other words, it solves a DC Analysis for each timestep based on initial conditions. |
| Pole-Zero Analysis | Computes the poles and/or zeros in the small-signal ac transfer function. |
| Small-Signal Distortion Analysis | Computes steady-state harmonic and intermodulation products for small input signal magnitudes. |
| Sensitivity Analysis | Calculate either the DC operating-point sensitivity or the AC small-signal sensitivity of an output variable with respect to all circuit variables, including model parameters. |
| Noise Analysis | Measures the device-generated noise for a given circuit. |
<br>

**The following images show how a SPICE deck is written to perform DC analysis of an NMOS transistor:**
| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Weste_Harris_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Weste_Harris_3.png) | ![CircuitDesignWorkshop_D1_Basic_Spice_Setup](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Setup.png) |
|:---:|:---:|
| | |

| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_1.png) |
|:---:|
| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_2.png) |
| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_3.png) |
| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_4](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_4.png) |
| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_5](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_5.png) |
| ![CircuitDesignWorkshop_D1_Basic_Spice_Simulation_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Simulation_1.png) |


### 14.1.2 Why SPICE in VLSI Design ?
In Digital VLSI Design, the timing, power, process variation, noise and signal integrity analyses **all ultimately rely on SPICE** for accurate modelling and characterization of the various Standard Cells and macros used in the design. 

## 14.2 NMOS Transistor

<br>

_________________________________________________________________________________________________________  
[Prev: Day 13](Day_13.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 15](Day_15.md)  

