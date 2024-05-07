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

_**Ref:**_ CMOS VLSI Design - A Circuits and Systems Perspective - Weste & Harris

| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Ngspice_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Ngspice_1.png) | ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Ngspice_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Ngspice_2.png) |
|:---:|:---:|

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
| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Weste_Harris_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_Weste_Harris_3.png) |
|:---:|
| ![CircuitDesignWorkshop_D1_Basic_Spice_Setup](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Setup.png) |
| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_1.png) |
| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_2.png) |
| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_3.png) |
| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_4](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_4.png) |
| ![CircuitDesignWorkshop_D1_Basic_Spice_Syntax_5](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Syntax_5.png) |
| ![CircuitDesignWorkshop_D1_Basic_Spice_Simulation_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_Basic_Spice_Simulation_1.png) |


### 14.1.2 Why SPICE in VLSI Design ?
In Digital VLSI Design, the timing, power, process variation, noise and signal integrity analyses **all ultimately rely on SPICE** for accurate modelling and characterization of the various Standard Cells and macros used in the design. 

## 14.2 NMOS Transistor
### 14.2.1 (Planar) NMOS Transistor Structure
| ![CircuitDesignWorkshop_D1_NMOS](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_NMOS.png) |
|:---:|

| ![Physical_structure_of_MOSFET_Cross_Section](/docs/images/CircuitDesignWorkshop/Physical_structure_of_MOSFET_Cross_Section.png) | ![Physical_structure_of_MOSFET_Perspective_View](/docs/images/CircuitDesignWorkshop/Physical_structure_of_MOSFET_Perspective_View.png) |
|:---:|:---:|

### 14.2.2 Transistor Operation: Cut-off Region, Surface Inversion & Threshold Voltage

  - Without the application of a Gate potential, the transistor is said to be in **Cut-off region** as there is no conducting path between the Source and Drain terminals. 
  - On the application a sufficiently high Gate-to-Source voltage, a conductive channel starts to form underneath the Gate composed of minority carriers (electrons in an NMOS) and at a certain voltage called the _**Threshold voltage**_,  _**surface inversion**_ occurs when the concentration of minority carriers in the channel becomes equal to the concentration of majority carriers in the bulk.
  - When VGS is increased further by several $\Phi_t (=thermal voltage, \dfrac{k_B T}{q}) $, the transistor moves into the _**strong inversion region**_. Here, the minority carrier concentration in the channel is a strong function of the applied gate potential. 

_**The below images depict the same for an NMOS transistor:**_
| ![CircuitDesignWorkshop_D1_VTH_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_VTH_1.png) |
|:---:|
| ![CircuitDesignWorkshop_D1_VTH_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_VTH_2.png) |
| ![CircuitDesignWorkshop_D1_VTH_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_VTH_3.png) |
| ![CircuitDesignWorkshop_D1_VTH_4](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_VTH_4.png) |
| ![CircuitDesignWorkshop_D1_VTH_5](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_VTH_5.png) |
| ![CircuitDesignWorkshop_D1_VTH_6](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_VTH_6.png) |

### 14.2.3 Effect of Subtrate/ Body Bias on Threshold Voltage

  - The Source-to-Substrate amd Drain-to-Substrate pn junctions must always be reverse biased for the "normal operation" of the MOS transistor, so $V_{SB}, V_{DB}$ must always be greater than or equal to zero for an NMOS transistor.
  - If $V_{SB} = 0$, then surface inversion is achieved at a Gate-to-Source voltage equal to **VT0**
  - However, when $V_{SB} > 0$, the electrons from the channel can move laterally and flow out of the source terminal resulting in a reduced carrier concentration in the channel.
  - Thus, with when $V_{SB} > 0$, a higher Gate-to-Source voltage is required to achieve surface inversion.
  - In other words, the threshold voltage of an NMOS increases when $V_{SB} > 0$.

| ![CircuitDesignWorkshop_D1_VTH_with_VSB_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_VTH_with_VSB_1.png) |
|:---:|
| ![CircuitDesignWorkshop_D1_VTH_with_VSB_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_VTH_with_VSB_2.png) |
| ![CircuitDesignWorkshop_D1_VTH_with_VSB_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_VTH_with_VSB_3.png) |
| ![CircuitDesignWorkshop_D1_VTH_with_VSB_4](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_VTH_with_VSB_4.png) |

<br>

| **Threshold Voltage Equation considering Body Bias:** <br>  <br>  ![CircuitDesignWorkshop_D1_VTH_with_VSB_5](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_VTH_with_VSB_5.png) |
|:---|


### 14.2.4 Resistive/ Linear Region of Operation

#### 14.2.4.1 Derivation of Drain Current, $I_D$
Let us analyse the condition when we apply a Gate-Source potential, $V_{GS} >= V_{TH}$ and a small value of $V_{DS}$ is applied across the channel from Drain-to-Source.

| ![CircuitDesignWorkshop_D1_NMOS_ResistiveRegion_Small_VDS](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_NMOS_ResistiveRegion_Small_VDS.png) |
|:---|

Using a simple first-order analysis, let us try to derive an equation for the Drain Current, $I_D$ that results due to the $V_{GS}$ and $V_{DS}$ values applied. The mechanism for the Drain current, $I_D$ is  **carrier drift** under the lateral electric field due to $V_{DS}$.

| ![CircuitDesignWorkshop_D1_DriftCurrent_Theory_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_DriftCurrent_Theory_1.png) |
|:---|
| ![CircuitDesignWorkshop_D1_DriftCurrent_Theory_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_DriftCurrent_Theory_2.png) |
| ![CircuitDesignWorkshop_D1_DriftCurrent_Theory_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_DriftCurrent_Theory_3.png) |
| ![CircuitDesignWorkshop_D1_DriftCurrent_Theory_4](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_DriftCurrent_Theory_4.png) |
| ![CircuitDesignWorkshop_D1_LinearRegion_Id_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_LinearRegion_Id_1.png) |
| ![CircuitDesignWorkshop_D1_LinearRegion_Id_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_LinearRegion_Id_2.png) |
| ![CircuitDesignWorkshop_D1_LinearRegion_Id_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_LinearRegion_Id_3.png) |
| ![CircuitDesignWorkshop_D1_LinearRegion_Id_4](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D1_LinearRegion_Id_4.png) |

#### 14.2.4.2 
#### 14.2.4.3 Drain current model for linear region of operation

### 14.2.5 Saturation/ Pinch-Off Region of Operation
#### 14.2.5.1 Pinch-off Region Condition
#### 14.2.5.2 Drain current model for saturation region of operation

<br>

_________________________________________________________________________________________________________  
[Prev: Day 13](Day_13.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 15](Day_15.md)  

