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

#### 16.2.1.1 **Case 1:** Devices are velocity saturated - $V_{DSAT}<(V_M-V_{TH})$
#### 16.2.1.2 **Case 1:** Devices are velocity saturated - $V_{DSAT}<(V_M-V_{TH})$

<br>

_________________________________________________________________________________________________________  
[Prev: Day 15](Day_15.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 17](Day_17.md)  

