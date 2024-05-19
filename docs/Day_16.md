[Back to TOC](../README.md)  
[Prev: Day 15](Day_15.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 17](Day_17.md)  
_________________________________________________________________________________________________________  
# Day 16: CMOS Switching Threshold and Dynamic Simulations

## 16.1 CMOS Inverter VTC (contd.)
### 16.1.1 Lab: CMOS Inverter VTC - sky130 $(W_P/W_N = 0.84u/0.36u, L=0.15u)$

<details> <summary> SPICE File: day3_inv_vtc_Wp084_Wn036.spice </summary>

```
*** Model Description ***
.param temp=27

*** Including sky130 library files **
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*** Netlist Description **
XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w=0.84 l=0.15
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
meas dc Vm find V(out) when V(out)=V(in)
.endc

.end
```
</details>

| **Output:** <br>  ![CircuitDesignWorkshop_D3_sky130_CMOS_Inv_VTC](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D3_sky130_CMOS_Inv_VTC.png) |
|:---|



### 16.1.2 Lab: CMOS Inverter Transition time - sky130 $(W_P/W_N = 0.84u/0.36u, L=0.15u)$
<details> <summary> SPICE File: day3_inv_tran_Wp084_Wn036.spice </summary>

```
 *** Model Description ***
.param temp=27

*** Including sky130 library files ***
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*** Netlist Description ***
XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w=0.84 l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w=0.36 l=0.15
Cload out 0 50fF
Vdd vdd 0 1.8V
Vin in 0 PULSE(0V 1.8V 0 0.1ns 0.1ns 2ns 4ns)

*** Simulation Commands ***
.tran 1n 10n

.control
run

let vdd=1.8
let slew_low_rise_thr=0.2*vdd
let slew_high_rise_thr=0.8*vdd
let slew_high_fall_thr=0.8*vdd
let slew_low_fall_thr=0.2*vdd
let tp_thr=0.5*vdd

meas tran t_rise TRIG v(out) VAL=slew_low_rise_thr RISE=1 TARG v(out) VAL=slew_high_rise_thr RISE=1
meas tran t_fall TRIG v(out) VAL=slew_high_fall_thr FALL=1 TARG v(out) VAL=slew_low_fall_thr FALL=1
meas tran t_pLH TRIG v(in) VAL=tp_thr FALL=2 TARG v(out) VAL=tp_thr RISE=2
meas tran t_pHL TRIG v(in) VAL=tp_thr RISE=2 TARG v(out) VAL=tp_thr FALL=2
.endc

.end
```
</details>

| **Output:** <br>  ![CircuitDesignWorkshop_D3_sky130_CMOS_Inv_Prop_Delay](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D3_sky130_CMOS_Inv_Prop_Delay.png) |
|:---|

## 16.2 Evaluating the Robustness of the CMOS Inverter - Static Behaviour
### 16.2.1  Switching Threshold, $V_M$
  - The switching threshold, $V_M$, is defined as the point where $V_{in} = V_{out}$.
  - Graphically it can be found from the intersection of the VTC with the $V_{in} = V_{out}$ line.
  - In the region around $V_M$, both PMOS and NMOS are in saturation, since $V_{DS} = V_{GS}$.
  - An analytical expression for $V_M$ can be obtained by equating the currents through the PMOS and NMOS transistors, $I_{DSn}=I_{DSp}$.
  - Depending on the supply voltage, $V_{DD}$ and the Channel length, $L$, of the devices, there can be two cases:
    1) Devices are Velocity Saturated
    2) Velocity Saturation does not occur

_**Note:**_ For the following derivations, we ignore the effects of Channel Length Modulation for simplicity.  


**<ins>Case 1:</ins> Devices are Velocity-Saturated - $V_{DSAT}<(V_M-V_{TH})$**  
  - This case is applicable to short-channel devices or when the supply voltage is high so that the devices are in velocity saturation.

| ![CircuitDesignWorkshop_D3_CMOS_Inverter_Robustness_SwitchingThreshold_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D3_CMOS_Inverter_Robustness_SwitchingThreshold_1.png) |
|:---:|
| ![CircuitDesignWorkshop_D3_CMOS_Inverter_Robustness_SwitchingThreshold_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D3_CMOS_Inverter_Robustness_SwitchingThreshold_2.png) |
| ![CircuitDesignWorkshop_D3_CMOS_Inverter_Robustness_SwitchingThreshold_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D3_CMOS_Inverter_Robustness_SwitchingThreshold_3.png) |

$I_{DSn} = -I_{DSp}$  
$i.e.,$  
$~~~~ I_{DSn} + I_{DSp} = 0$  

$k_n \left[ (V_M - V_{THn})V_{DSATn} - \dfrac{V_{DSATn}^2}{2} \right] + k_p \left[ (V_M - V_{DD} - V_{THp})V_{DSATp} - \dfrac{V_{DSATp}^2}{2} \right] = 0$

$k_n V_{DSATn} \left[ V_M - V_{THn} - \dfrac{V_{DSATn}}{2} \right] + k_p V_{DSATp} \left[ V_M - V_{DD} - V_{THp} - \dfrac{V_{DSATp}}{2} \right] = 0$

<br>

$Solving for V_M:$  

$\boxed{V_M = \dfrac{\left( V_{THn}+\dfrac{V_{DSATn}}{2} \right) + r \left( V_{DD}+V_{THp}+\dfrac{V_{DSATp}}{2} \right)}{1+r}},$  
  
$where, ~ \boxed{r=\dfrac{k_p V_{DSATp}}{k_n V_{DSATn}} = \dfrac{\upsilon_{satp} W_p}{\upsilon_{satn} W_n}}$ _(assuming for identical oxide thickness for PMOS and NMOS transistors)_  

  - Now, for large values of $V_{DD}$ compared to the threshold voltages $(V_{THp}, V_{THn})$ and saturation voltages $(V_{DSATp}, V_{DSATn})$, the above equation can be approximated to:

$~~~~~~~~~~~~~~~~ \boxed{V_M \approx \dfrac{rV_{DD}}{1+r}}$  

  - The switching threshold is determined by the ratio, $r$ - which is a measure of the relative drive strengths of the PMOS and NMOS transistors.
  - For comparable values for low and high noise margins, $V_M$ is desired to be located around the centre of the available voltage swing (or at $V_{DD}/2$ as CMOS logic has rail-to-rail swing). This implies:  

$~~~~~~~~ r \approx 1$  
$~~~~~~~~ i.e., k_p V_{DSATp} = k_n V_{DSATn}$  

$\boxed{{(W/L)}_p = {(W/L)}_n \times \dfrac{k_n^\prime V_{DSATn}}{k_p^\prime V_{DSATp}}}$  

  - To move the $V_M$ upwards, a larger value of $r$ is needed, which in other words is to make the PMOS wider.
  - On the other hand, to move the $V_M$ downwards, the NMOS must be made wider.

  - If a target design value for $V_M$ is desired, we can derive the required ratio of PMOS vs. NMOS transistor sizes in a similar manner:

$~~~~~~~~ \boxed{\dfrac{(W/L)_p}{(W/L)_n} = \dfrac{k_n^\prime V_{DSATn} \left[ V_M - V_{THn} - \dfrac{V_{DSATn}}{2} \right]}{k_p^\prime V_{DSATp} \left[ V_{DD} - V_M + V_{THp} + \dfrac{V_{DSATp}}{2}\right]}}$  
$~~~~~~~~ Note:$ _Make sure that the assumption that both devices are velocity-saturated still holds for the chosen operation point._


**<ins>Case 2:</ins> Velocity Saturation does not occur - $V_{DSAT}>(V_M-V_{TH})$**  
  - This case is applicable for long-channel devices or when the supply voltages are low, that the devices are not velocity saturated.
  - Using a similar analysis done in Case 1 above, we derive the switching threshold, $V_M$ to be:

$~~~~~~~~ \boxed{V_M = \dfrac{V_{THn} + r(V_{DD} + V_{THp})}{1+r}}, ~~~~ where ~ r = \sqrt{\dfrac{-k_p}{k_n}}$  

  - The switching threshold, $V_M$ **is relatively insensitive to variations in the device ratio**.

| ![CircuitDesignWorkshop_D3_CMOS_Inverter_Robustness_SwitchingThreshold_4](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D3_CMOS_Inverter_Robustness_SwitchingThreshold_4.png) |
|:---:|

<br>

_________________________________________________________________________________________________________  
[Prev: Day 15](Day_15.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 17](Day_17.md)  

