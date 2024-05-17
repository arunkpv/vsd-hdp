[Back to TOC](../README.md)  
[Prev: Day 15](Day_15.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 17](Day_17.md)  
_________________________________________________________________________________________________________  
# Day 16: CMOS Switching Threshold and Dynamic Simulations

## 16.1 CMOS Inverter VTC contd.
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
.endc

.end
```
</details>

<br>

_________________________________________________________________________________________________________  
[Prev: Day 15](Day_15.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 17](Day_17.md)  

