[Back to TOC](../README.md)  
[Prev: Day 16](Day_16.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 18](Day_18.md)  
_________________________________________________________________________________________________________  
# Day 17: Evaluating the Robustness of the CMOS Inverter (Contd.)
## 17.1 Static Behaviour Robustness: (2) Noise Margin
  - In digital circuits, if the magnitude of the "noise voltage" at a node is too large, logic errors can be introduced into the system.
  - However, if the noise amplitude is less than a specified value, called the **noise margin**, the noise signal will be attenuated as it passes through the logic gate or circuit, and the logic signals will be transmitted without any errors.
  - i.e., **Noise margin** is the amount of noise that a CMOS circuit could withstand without compromising the operation of circuit.
<br>

  - Noise margin makes sure that:
    - any signal which is **logic 1** with finite noise added to it, is still recognized as **logic 1** and not **logic 0**.
    - similarly, any signal which is **logic 0** with finite noise added to it, is still recognized as **logic 0** and not **logic 1**.

### 17.1.1 Noise Margin Definition
  - Let us consider the case of two CMOS inverters connected back-to-back with one driving the next.
  - The following images show an ideal, a piece-wise linear and a realistic VTC of a CMOS inverter:

| ![CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_1.png) | ![CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_2.png) |
|:---|:---|
| ![CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_3.png) |  |
| ![CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_Definitions_Weste_Harris](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_Definitions_Weste_Harris.png)  | ![CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_1.png) | 

  - $V_{IL}$ and $V_{IH}$ (or to be more precise, $V_{IL-MAX}$ and $V_{IH-MIN}$) are defined to be the operational points of the inverter where $\dfrac{dV_{out}}{dV_{in}} = -1$. Or, from an analog design perspective, these are the points where the gain of the inverting amplifier formed by the inverter is equal to -1.
    - Any input voltage level between 0 and $V_{IL}$ will be treated as **logic 0**
    - Any input voltage level between $V_{IH}$ and $V_{DD}$ will be treated as **logic 1**
    - The point $V_{IL}$ occurs when the NMOS is biased in saturation region and the PMOS is biased in the linear region.
    - Similarly, the point $V_{IH}$ occurs when the NMOS is biased in linear region and the PMOS is biased in the saturation region.
    ```
    -----------------------
    Output Characteristics:
    -----------------------
    VOL_Min : Minimum output voltage that the logic gate can drive for a logic "0" output.
    VOL_Max : Maximum output voltage that the logic gate will drive corresponding to a logic "0" output.
    VOH_Min : Minimum output voltage that the logic gate will drive corresponding to a logic "1" output.
    VOH_Max : Maximum output voltage that the logic gate can drive for a logic "1" output.

    ----------------------
    Input Characteristics:
    ----------------------
    VIL_Min : The minimum input voltage to the gate corresponding to logic "0" -- is equal to the VSS
    VIL_Max : The maximum input voltage to the gate that will be recognized as logic "0"
    VIH_Min : The minimum input voltage to the gate that will be recognized as logic "1"
    VIH_Max : The maximum input voltage to the gate corresponding to logic "1" -- is equal to the VDD
    ```
  
  - Obviosuly, for proper operation of the logic gate in the presence of noise:
    - $V_{OL-MAX} < V_{IL-MAX}$
    - $V_{OH-MIN} > V_{IH-MIN}$

  - For $V_{in} \le V_{IL}$ , the inverter gain magnitude is less than unity, and the output change is minimal for a given change in the input voltage in this range.
  - Similarly, for $V_{in} \ge V_{IH}$ , the output change is minimal for a given input voltage in this range, again because of the same reason that the gain magnitude is less than unity.
  - However, when the input voltage is in the range $V_{IL} < V_{in} < V_{IH}$ , the gain magnitude is greater than one, and the output signal amplitude changes drastically.
    - This region is called the **undefined range** (from a digital design standpoint), since if the input voltage is inadvertently pushed into this range by a noise signal, the output may change logic state introducing an error.

  - **The noise margins are defined as thus defined as follows:**  
    - Low-level Noise Margin, $~ NM_L ~ = V_{IL-MAX} - V_{OL-MAX}$  
    - High-level Noise Margin, $NM_H = V_{OH-MIN} - V_{IH-MIN}$  
    - Noise Margin, $NM = Min(NM_L, NM_H)$  

| ![CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_2.png) |
|:---|
| ![CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_3.png) |


### 17.1.2 Noise Margin Robustness against variations in Device Ratio

| ![CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_4](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_4.png) |
|:---|

### 17.1.3 Lab: Noise Margin
<details> <summary> SPICE File: day4_inv_noisemargin_wp1_wn036.spice </summary>

```
*** Model Description ***
.param temp=27

*** Including sky130 library files ***
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*** Netlist Description ***
XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w=1 l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w=0.36 l=0.15
Cload out 0 50fF
Vdd vdd 0 1.8V
Vin in 0 1.8V

*** Simulation Commands ***
.op
.dc Vin 0 1.8 0.01

.control
run
setplot dc1
display
let dVout = deriv(V(out))
meas dc vil find V(in) when dVout=-1 cross=1
meas dc vih find V(in) when dVout=-1 cross=2
meas dc voh find V(out) when dVout=-1 cross=1
meas dc vol find V(out) when dVout=-1 cross=2

let NML = vil - vol
let NMH = voh - vih
print NML
print NMH
.endc

.end
```
</details>

| **Output:** <br>  ![CircuitDesignWorkshop_D4_sky130_CMOS_Inv_NoiseMargin](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_sky130_CMOS_Inv_NoiseMargin.png) |
|:---|

<br>

_________________________________________________________________________________________________________  
[Prev: Day 16](Day_16.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 18](Day_18.md)  

