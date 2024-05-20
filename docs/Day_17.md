[Back to TOC](../README.md)  
[Prev: Day 16](Day_16.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 18](Day_18.md)  
_________________________________________________________________________________________________________  
# Day 17: Evaluating the Robustness of the CMOS Inverter (Contd.)
## 17.1 Static Behaviour Robustness: Noise Margin
  - $V_{IL}$ and $V_{IH}$ (or to be more precise, $V_{IL_MAX}$ and $V_{IH_MIN}$) are defined to be the operational points of the inverter where $\dfrac{dV_{out}}{dV_{in}} = -1$. Or, from an analog design perspective, these are the points where the gain of the inverting amplifier formed by the inverter is equal to -1.
  - The following images show an ideal, a piece-wise linear and a realistic VTC of a CMOS inverter. 
| ![CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_1.png) | ![CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_2.png) |
|:---|:---|
| ![CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D4_CMOS_Inverter_Robustness_NoiseMargin_VTC_3.png) | |

### 17.1.1 Lab: Noise Margin
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

