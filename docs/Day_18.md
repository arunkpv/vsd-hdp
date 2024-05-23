[Back to TOC](../README.md)  
[Prev: Day 17](Day_17.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 19](Day_19.md)  
_________________________________________________________________________________________________________  
# Day 18: Evaluating the Robustness of the CMOS Inverter (Contd.)
## 18.1 Static Behaviour Robustness: (3) Power Supply Variations/ Scaling

Here, we take a look at the effect of power supply scaling on the static behaviour of the CMOS Inverter.

### 18.1.1 Lab - Supply Scaling - sky130 Inverter (Wp/Wn=1u/0.36u, L=0.15u)
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

## 18.2 Static Behaviour Robustness: (4) Device Variations

While we design a gate for nominal operation conditions and typical device parameters, the actual operating temperatures might very over a large range, and the device parameters after fabrication will deviate from the nominal values used in the design process.

The DC characteristics of the static CMOS inverter turn out to be rather insensitive to these variations, and the gate remains functional over a wide range of operating conditions.

### 18.2.1 Sources of Variation
**1) Etching Process Variations**
| ![CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_DeviceVariations_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_DeviceVariations_1.png) | ![CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_DeviceVariations_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_DeviceVariations_2.png) |
|:---|:---|


**2) Oxide Thickness Variation**
| ![CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_DeviceVariations_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_DeviceVariations_3.png) | ![CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_DeviceVariations_4](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_DeviceVariations_4.png) |
|:---|:---|


### 18.2.2 Lab - Device Variations - sky130 Inverter - (Wp:7u --> 0.42u, Wn:0.36u --> 7u, L=0.15u)

In this exercise, we try to capture the CMOS Inverter's robustness in the case of a ridiculously extreme case of device width variation.

| ![CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_DeviceVariations_5](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D5_CMOS_Inverter_Robustness_DeviceVariations_5.png) |
|:---|

<details> <summary> SPICE File: day5_inv_devicevariation_wp7_wn042.spice </summary>

```
*** Model Description **
.param temp=27
.param Wp=0.84
.param Wn=0.42

*** Including sky130 library files ***
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*** Netlist Description ***
XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w={Wp} l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w={Wn} l=0.15
Cload out 0 50fF
Vdd vdd 0 1.8V
Vin in 0 1.8V

*** Simulation Commands ***
.dc Vin 0 1.8 0.01

.control
alterparam Wp=0.84
alterparam Wn=0.42
reset
run

alterparam Wp=0.42
alterparam Wn=7
reset
run

alterparam Wp=7
alterparam Wn=0.36
reset
run

plot dc1.V(out) dc2.V(out) dc3.V(out) vs in 
+ xlabel 'Input Voltage(V)' ylabel 'Output Voltage(V)' title 'Inverter VTC for Extreme Device Variations'
.endc
.end
```
</details>


**From the simulation results:**
  1) The shift in $V_M$ for such a large change in device variations is relatively very small.
  2) The variation in the $NM_H$ and $NM_L$ is also very small.

| **Output:** <br>  ![CircuitDesignWorkshop_D5_sky130_CMOS_Inv_DeviceVariations](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D5_sky130_CMOS_Inv_DeviceVariations.png) |
|:---|

<br>

_________________________________________________________________________________________________________  
[Prev: Day 17](Day_17.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 19](Day_19.md)  

