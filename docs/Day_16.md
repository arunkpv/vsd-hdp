[Back to TOC](../README.md)  
[Prev: Day 15](Day_15.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 17](Day_17.md)  
_________________________________________________________________________________________________________  
# Day 16: CMOS Switching Threshold and Dynamic Simulations

## 16.1 CMOS Inverter VTC (contd.)
### 16.1.1 Lab: CMOS Inverter VTC - sky130 (Wp/Wn = 0.84u/0.36u, L=0.15u)

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



### 16.1.2 Lab: CMOS Inverter Transition time - sky130 (Wp/Wn = 0.84u/0.36u, L=0.15u)
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

## 16.2 Evaluating the Robustness of the CMOS Inverter
### 16.2.1  Static Behaviour Robustness: (1) Switching Threshold, VM
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
$\boxed{(W/L)\_p = (W/L)\_n * \dfrac{{k_n}^\prime V_{DSATn}}{{k_p}^\prime V_{DSATp}}}$  

  - To move the $V_M$ upwards, a larger value of $r$ is needed, which in other words is to make the PMOS wider.
  - On the other hand, to move the $V_M$ downwards, the NMOS must be made wider.
  - If a target design value for $V_M$ is desired, we can derive the required ratio of PMOS vs. NMOS transistor sizes in a similar manner:

$~~~~~~~~ \boxed{\dfrac{(W/L)\_p}{(W/L)\_n} = \dfrac{k_n^\prime V_{DSATn} \left[ V_M - V_{THn} - \dfrac{V_{DSATn}}{2} \right]}{k_p^\prime V_{DSATp} \left[ V_{DD} - V_M + V_{THp} + \dfrac{V_{DSATp}}{2}\right]}}$  
$~~~~~~~~ Note:$ _Make sure that the assumption that both devices are velocity-saturated still holds for the chosen operation point._


**<ins>Case 2:</ins> Velocity Saturation does not occur - $V_{DSAT}>(V_M-V_{TH})$**  
  - This case is applicable for long-channel devices or when the supply voltages are low, that the devices are not velocity saturated.
  - Using a similar analysis done in Case 1 above, we derive the switching threshold, $V_M$ to be:

$~~~~~~~~ \boxed{V_M = \dfrac{V_{THn} + r(V_{DD} + V_{THp})}{1+r}}, ~~~~ where ~ r = \sqrt{\dfrac{-k_p}{k_n}}$  

  - The switching threshold, $V_M$ **is relatively insensitive to variations in the device ratio**.
    - Small variations of the ratio (e.g., 3 or 2.5) do not disturb the transfer characteristic that much.

| ![CircuitDesignWorkshop_D3_CMOS_Inverter_Robustness_SwitchingThreshold_4](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D3_CMOS_Inverter_Robustness_SwitchingThreshold_4.png) |
|:---:|

### 16.2.2 Lab: CMOS Inverter Switching Threshold - sky130 (Wp/Wn ratio sweep, L=0.15u)
<details> <summary> SPICE File: day3_inv_vm.spice </summary>

```
*** Model Description ***
.param temp=27
.param Wp=0.84
.param Wn=0.36

*** Including sky130 library files ***
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*** Netlist Description ***
XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w={Wp} l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w={Wn}l=0.15
Cload out 0 50fF
Vdd vdd 0 1.8V
Vin in 0 1.8V

*** Simulation Commands ***
.dc Vin 0 1.8 0.01

.control
let idx=1
let loops=40
let Wp_incr=0.84
let Wn_incr=0.36
let Wp_start=0.84
let Wn_start=0.36*20
set c = " "
let vector_Vm = vector(loops)
let vector_Wp_Wn_ratio = vector(loops)

dowhile idx <= loops
    if (idx <= 20)
        let new_Wn = Wn_start - ((idx-1) * Wn_incr)
        let new_Wp = 0.84
    end
    if (idx >= 21)
        let new_Wn = 0.36
        let new_Wp = Wp_start + ((idx-20) * Wp_incr)
    end

    alterparam Wp=$&new_Wp
    alterparam Wn=$&new_Wn
    reset
    run
    meas dc Vm find V(out) when V(out)=V(in)
    let vector_Vm[idx-1] = Vm
    let vector_Wp_Wn_ratio[idx-1] = ($&new_Wp/ $&new_Wn)
    print ($&new_Wp/ $&new_Wn)
    set c = ( $c dc{$&idx}.V(out) )
    let idx = idx + 1
end

set nolegend
plot $c xlabel 'Vin' ylabel 'Vout'
plot vector_Vm vs vector_Wp_Wn_ratio xlabel 'Wp/Wn' ylabel 'Vm (V)'
*+ xlimit vector_Wp_Wn_ratio[0] vector_Wp_Wn_ratio[39] ylimit vector_Vm[0] vector_Vm[39]
.endc

.end
```
</details>

| **Output:** <br>  ![CircuitDesignWorkshop_D3_sky130_CMOS_Inv_WpWnRatio_Sweep](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D3_sky130_CMOS_Inv_WpWnRatio_Sweep.png) |
|:---|

### 16.2.3 Lab: CMOS Inverter t_pd - sky130 (Wp/Wn ratio sweep, L=0.15u)
<details> <summary> SPICE File: day3_inv_vm_tran.spice </summary>

```
*** Model Description ***
.param temp=27
.param Wp=0.84
.param Wn=0.36

*** Including sky130 library files ***
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*** Netlist Description ***
XM1 out in vdd vdd sky130_fd_pr__pfet_01v8 w={Wp} l=0.15
XM2 out in 0 0 sky130_fd_pr__nfet_01v8 w={Wn}l=0.15
Cload out 0 50fF
Vdd vdd 0 1.8V
Vin in 0 PULSE(0V 1.8V 0 0.1ns 0.1ns 2ns 4ns)

*** Simulation Commands ***
.tran 1n 10n

.control
let idx=1
let loops=40
let Wp_incr=0.84
let Wn_incr=0.36
let Wp_start=0.84
let Wn_start=0.36*20

let vector_trise = vector(loops)
let vector_tfall = vector(loops)
let vector_tpLH  = vector(loops)
let vector_tpHL  = vector(loops)
let vector_Wp_Wn_ratio = vector(loops)

let vdd=1.8
let slew_low_rise_thr=0.2*vdd
let slew_high_rise_thr=0.8*vdd
let slew_high_fall_thr=0.8*vdd
let slew_low_fall_thr=0.2*vdd
let tp_thr=0.5*vdd

dowhile idx <= loops
    if (idx <= 20)
        let new_Wn = Wn_start - ((idx-1) * Wn_incr)
        let new_Wp = 0.84
    end
    if (idx >= 21)
        let new_Wn = 0.36
        let new_Wp = Wp_start + ((idx-20) * Wp_incr)
    end

    alterparam Wp=$&new_Wp
    alterparam Wn=$&new_Wn
    reset
    run
    
    meas tran t_rise TRIG v(out) VAL=slew_low_rise_thr RISE=1 TARG v(out) VAL=slew_high_rise_thr RISE=1
    meas tran t_fall TRIG v(out) VAL=slew_high_fall_thr FALL=1 TARG v(out) VAL=slew_low_fall_thr FALL=1
    meas tran t_pLH TRIG v(in) VAL=tp_thr FALL=2 TARG v(out) VAL=tp_thr RISE=2
    meas tran t_pHL TRIG v(in) VAL=tp_thr RISE=2 TARG v(out) VAL=tp_thr FALL=2
    
    let vector_trise[idx-1] = t_rise
    let vector_tfall[idx-1] = t_fall
    let vector_tpLH[idx-1] = t_pLH
    let vector_tpHL[idx-1] = t_pHL
    
    let vector_Wp_Wn_ratio[idx-1] = ($&new_Wp/ $&new_Wn)
    print ($&new_Wp/ $&new_Wn)
    let idx = idx + 1
end

plot vector_trise vector_tfall vs vector_Wp_Wn_ratio xlabel 'Wp/Wn' ylabel 't_r, t_f'
plot vector_tpLH vector_tpHL vs vector_Wp_Wn_ratio xlabel 'Wp/Wn' ylabel 't_pLH, t_pHL'
.endc

.end
```
</details>

| **Output:** <br>  ![CircuitDesignWorkshop_D3_sky130_CMOS_Inv_WpWnRatio_Sweep_tpd](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D3_sky130_CMOS_Inv_WpWnRatio_Sweep_tpd.png) |
|:---|

<br>

_________________________________________________________________________________________________________  
[Prev: Day 15](Day_15.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 17](Day_17.md)  

