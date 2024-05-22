[Back to TOC](../README.md)  
[Prev: Day 17](Day_17.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 19](Day_19.md)  
_________________________________________________________________________________________________________  
# Day 18: Evaluating the Robustness of the CMOS Inverter (Contd.)
## 18.1 Static Behaviour Robustness: (3) Power Supply Scaling

Here, we take a look at the effect of power supply scaling on the static behaviour of the CMOS Inverter.

### 18.1.1 Lab - Supply Scaling - sky130 Inverter (Wp/Lp=)
<details> <summary> SPICE File: day5_inv_supplyvariation_Wp1_Wn036.spice </summary>

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

.control
let powersupply     = 1.8
let powersupply_min = 0.8
let increment_step  = -0.2

dowhile powersupply >= powersupply_min
    dc Vin 0 1.8 0.01
    let powersupply = powersupply + increment_step
    alter Vdd = powersupply
end

plot dc1.V(out) dc2.V(out) dc3.V(out) dc4.V(out) dc5.V(out) dc6.V(out) vs in 
+ xlabel 'Input Voltage(V)' ylabel 'Output Voltage(V)' title 'Inverter VTC for different VDD'

plot deriv(dc1.V(out)) deriv(dc2.V(out)) deriv(dc3.V(out)) deriv(dc4.V(out)) deriv(dc5.V(out)) deriv(dc6.V(out)) vs in 
+ xlabel 'Input Voltage(V)' ylabel 'Gain (dVout/dVin)' title 'Inverter Gain for different VDD'
.endc

.end
```
</details>

| **Output:** <br>  ![CircuitDesignWorkshop_D5_sky130_CMOS_Inv_SupplyVariation](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D5_sky130_CMOS_Inv_SupplyVariation.png) |
|:---|

We can see from the simulations that:
  - The CMOS Inverter continues to work well at even 0.8V (below half the original supply voltage of 1.8V) close to the transistor threshold voltages!
  - Since the transistor ratio, $r$ is fixed, the switching threshold, $V_M$ is approximately proportional to the $V_{DD}$.
  - The gain of the inverter in the transition region increases with a reduction of the supply voltage.
  - The width of the transition region also reduces when the supply voltage is scaled down compared to the original $V_{DD}$.

However, given these improvements in DC characteristics, we cannot choose to operate all our digital circuits at these low supply voltages:
  - Reducing the supply voltage yields a significant reduction in the energy dissipation, but it is absolutely detrimental to the performance of the gate, increasing the transition times greatly.
  - The DC characteristic becomes increasingly sensitive to variations in the device parameters such as the transistor threshold, once supply voltages and intrinsic voltages become comparable.
  - Scaling the supply voltage means reducing the signal swing. While this typically helps to reduce the internal noise in the system (such as caused by crosstalk), it makes the design more sensitive to external noise sources that do not scale.

| ![CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_SupplyVariation](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_SupplyVariation.png) |
|:---|

<br>

_________________________________________________________________________________________________________  
[Prev: Day 17](Day_17.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 19](Day_19.md)  

