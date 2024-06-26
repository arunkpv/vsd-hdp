[Back to TOC](../README.md)  
[Prev: Day 14](Day_14.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 16](Day_16.md)  
_________________________________________________________________________________________________________  
# Day 15: Velocity Saturation and CMOS Inverter VTC

## 15.1 Velocity Saturation
  - The behavior of transistors with very short channel lengths (called short-channel devices) deviates considerably from the resistive and saturated models.
  - The main reason for this deviation is the _**velocity saturation effect**_.
  - We had seen previously that the drift velocity is modelled by:  
    Drift velocity, $v = -\mu \dfrac{dV}{dx}$
      - i.e., the velocity of the carriers is proportional to the electrical field, independent of
the value of that field. In other words, the carrier mobility is a constant.
  - However, at high electric field strengths, the carriers fail to follow this linear model.
  - When the electrical field along the channel reaches a critical value $E_c$, the velocity of the carriers tends to saturate due to scattering effects (collisions suffered by the carriers).

| ![CircuitDesignWorkshop_D2_VelocitySaturation_Rabaey](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_VelocitySaturation_Rabaey.png) |
|:---|

  - For p-type silicon:
    - the critical field at which electron saturation occurs is around $1.5 \times 10^6 V/m ~ (or~1.5 V/\mu m)$, and
    - the saturation velocity $v_{sat}$ approximately equals $10^5 m/s$
  - This means that in an NMOS device with a channel length of $1~\mu m$, only a couple of volts of $V_{DS}$ is needed to reach the electron velocity saturation point. This condition is easily met in current short-channel devices.
  - Holes in a n-type silicon saturate at the same velocity, although a higher electrical field is needed to achieve saturation. Velocity-saturation effects are hence less pronounced in PMOS transistors.
  - The drift velocity can be roughly approximated as a piece-wise linear function of the electrical field as follows:  
    - $v = \dfrac{\mu E}{1+(E/E_c)}~~~~~,for~ E \le E_c$  
      $~~~=v_{sat}~~~~~~~~~~~~~~~~~~~~,for~E > E_c$  
  - For continuity at $E=E_c$, we get: $E_c = \dfrac{2v_{sat}}{\mu}$

### 15.1.1 Drain Current in Resistive/ Linear Region
**Now the drain current equation in the resistive region can be re-evaluated using:**  
<br>

$I_D = -v_n(x) * Q_i(x) * W$  
$I_D = -v_n(x) * -C_{ox} [V_{GS} - V(x) -V_{TH}] * W$  
$v_n = \dfrac{\mu_n E}{1+(E/E_c)}$  

Now, $E = \dfrac{dV}{dx}$  

$\therefore v_n = \dfrac{\mu_n (dV/dx)}{1+(1/E_c)(dV/dx)}$  


$\therefore I_D = \dfrac{\mu_n (dV/dx)}{1+(1/E_c)(dV/dx)} * C_{ox} [V_{GS} - V(x) - V_{TH}] * W$  

$i.e., I_D \left[ 1+\dfrac{1}{E_c}\dfrac{dV}{dx}\right] = \mu_n \dfrac{dV}{dx} * C_{ox} [V_{GS} - V(x) - V_{TH}] * W$  

Integrating w.r.t $x$ from $x=0 ~~ (where ~~ V=0)$ to $x=L ~~ (where ~~ V=V_{DS})$, we get:  

$I_D \left[ L+(V_{DS}/E_c)\right] = \mu_n C_{ox} [(V_{GS} - V_{TH})V_{DS} - \dfrac{V_{DS}^2}{2} ] * W$  

Re-arranging:  
$I_D = \left[\dfrac{1}{L+(V_{DS}/E_c)}\right] \mu_n * C_{ox} [(V_{GS} - V_{TH})V_{DS} - \dfrac{V_{DS}^2}{2} ] * W$  

$i.e., I_D = \left[\dfrac{1}{1+(V_{DS}/E_c L)}\right] \mu_n * C_{ox} [(V_{GS} - V_{TH})V_{DS} - \dfrac{V_{DS}^2}{2} ] * \dfrac{W}{L}$  

$i.e., \boxed{I_D = \left[\dfrac{1}{1+(V_{DS}/E_c L)}\right]~\mu_n C_{ox} \dfrac{W}{L} [(V_{GS} - V_{TH})V_{DS} - \dfrac{V_{DS}^2}{2} ]}$  

$~~~~~~~~~~~~\boxed{I_D = \kappa(V_{DS}) \mu_n C_{ox} \dfrac{W}{L}\left[(V_{GS}-V_{TH})V_{DS} - \dfrac{{V_{DS}^2}}{2} \right]}$  

$~~~~~~~~~~~~where, ~~~~ \kappa(V_{DS}) = \dfrac{1}{1+(V_{DS}/E_c L)}$  

  - $\kappa$ is a measure of the velocity saturation since $V_{DS}/L$ is the average field in the channel.
  - In the case of long-channel devices (where $L$ is large), or when the value of $V_{DS}$ is small, $\kappa$ approaches 1 and the above equation simplifies to the traditional equation we had derived first using the constant mobility model.
  - For short-channel devices, $\kappa$ is smaller than 1, implying the delivered current is smaller than what would be normally expected.

### 15.1.2 Drain Current in Saturation Region
**Coming to the Drain current in saturation region:**  
<br>

$I_D = -v_n(x) * -C_{ox} [V_{GS} - V(x) -V_{TH}] * W ~~~~~~~~ |with ~~ v_n(x)=v_{sat} ~~ and ~~ V(x)=V_{DSAT}$  
$i.e., \boxed{I_{DSAT} = v_{sat} C_{ox} W [(V_{GS} - V_{TH}) - V_{DSAT}]}$  

$I_{DSAT}$ can also be evaluated by replacing $V_{DS}=V_{DSAT}$ in the linear region equation derived in the previous section.  

$\therefore ~~~~ \boxed{I_{DSAT} = \kappa(V_{DSAT}) \mu_n C_{ox} \dfrac{W}{L}\left[(V_{GS}-V_{TH})V_{DSAT} - \dfrac{{V_{DSAT}^2}}{2} \right]}$


Equating these two expressions for $I_{DSAT}$ to solve for $V_{DSAT}$, we get:  
$I_{DSAT} = v_{sat} C_{ox} W [(V_{GS} - V_{TH}) - V_{DSAT}]~= \kappa(V_{DSAT}) \mu_n C_{ox} \dfrac{W}{L}\left[(V_{GS}-V_{TH})V_{DSAT} - \dfrac{{V_{DSAT}^2}}{2} \right]$

$i.e.,$  
$\dfrac{\mu_n E_c}{2} C_{ox} W [(V_{GS} - V_{TH}) - V_{DSAT}] = \kappa(V_{DSAT}) \mu_n C_{ox} \dfrac{W}{L}\left[(V_{GS}-V_{TH})V_{DSAT} - \dfrac{{V_{DSAT}^2}}{2} \right]$

$E_c L [(V_{GS} - V_{TH}) - V_{DSAT}] = \kappa(V_{DSAT}) \left[2(V_{GS}-V_{TH})V_{DSAT} - {V_{DSAT}^2} \right]$

This can be further simplified to the below:  
$~~~~~~~~ \boxed{V_{DSAT} = \kappa(V_{GT}) ~ V_{GT}} ~~~~ , where ~ V_{GT} = (V_{GS} - V_{TH})$  

<br>

**This has the following implications:**

  1)  The saturation current $I_{DSAT}$ displays a linear dependence with respect to the Gate-to-Source voltage $V_{GS}$, which is in contrast with the squared dependence in the long-channel devices. This reduces the amount of current a transistor can deliver for a given control voltage.

  2) For a short-channel device and for large enough values of $V_{GT}$, $\kappa(V_{GT})$ is substantially smaller than 1, hence $V_{DSAT} < V_{GT}$. The device enters saturation before $V_{DS}$
reaches $(V_{GS} - V_{TH})$. Short-channel devices therefore experience an extended saturation region and tend to operate more often in saturation region compared to long-channel devices.


| ![CircuitDesignWorkshop_D2_VelocitySaturation_Rabaey_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_VelocitySaturation_Rabaey_2.png) |
|:---|

| ![CircuitDesignWorkshop_D2_Velocity_Saturation_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_1.png) |
|:---:|
| ![CircuitDesignWorkshop_D2_Velocity_Saturation_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_2.png) |
| ![CircuitDesignWorkshop_D2_Velocity_Saturation_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_3.png) |
| ![CircuitDesignWorkshop_D2_Velocity_Saturation_4](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_4.png) |
| ![CircuitDesignWorkshop_D2_Velocity_Saturation_5](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_5.png) |

### 15.1.3 Unified MOS Model for Manual Analysis

  - It is desrirable to have a mathematical model that abstracts the behavior of the MOS transistor into a simple and tangible analytical model that does not lead to hopelessly complex equations, yet captures the essentials of the device.
  - This is required so that the designer is able to have an intuitive insight into the behaviour of a circuit and how the design parameters affect its operation.
<br>

  - The first-order expressions derived earlier can be combined into a single unified model that presents the transistor as a single current source the value as defined below:
    - The model employs the voltages at the four terminals of the transistor, along with a set of five parameters: $V_{TO}, ~ \gamma, ~ V_{DSAT}, ~ k^{\prime}, ~ and ~ \lambda$.

| ![CircuitDesignWorkshop_D2_Unified_MOS_Model](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Unified_MOS_Model.png) |
|:---:|


**The following slides show how the unified model works in the different Regions of Operation of the MOS transistor:**  
| ![CircuitDesignWorkshop_D2_Velocity_Saturation_6](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_6.png) |
|:---:|
| ![CircuitDesignWorkshop_D2_Velocity_Saturation_7](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_7.png) |
| ![CircuitDesignWorkshop_D2_Velocity_Saturation_8](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_8.png) |
| ![CircuitDesignWorkshop_D2_Velocity_Saturation_9](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_9.png) |

### 15.1.4 Lab: Velocity Saturation - ID vs. VDS - tsmc 0.25um
<details> <summary> SPICE File: nmos_chara_W1.8u_L1.2u.spice </summary>

```
*** Netlist Description ***
M1 vdd n1 0 0 nmos W=1.8u L=1.2u
R1 in n1 55
Vdd vdd 0 2.5
Vin in 0 2.5

*** .include model ***
.lib "tsmc_025um_model.mod" cmos_models

*** Simulation Commands ***
.op
.dc Vdd 0 2.5 0.1 Vin 0 2.5 0.5

.control
run
display
setplot dc1
plot -vdd#branch
.endc

.end
```
</details>

<details> <summary> SPICE File: nmos_chara_W0.375u_L0.25u.spice </summary>

```
*** Netlist Description ***
M1 vdd n1 0 0 nmos W=0.375u L=0.25u
R1 in n1 55
Vdd vdd 0 2.5
Vin in 0 2.5

*** .include model ***
.lib "tsmc_025um_model.mod" cmos_models

*** Simulation Commands ***
.op
.dc Vdd 0 2.5 0.1 Vin 0 2.5 0.5

.control
run
display
setplot dc1
plot -vdd#branch
.endc

.end
```
</details>

| **Output:** ![CircuitDesignWorkshop_D2_Velocity_Saturation_Id_vs_Vds_tsmc_0.25u](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_Id_vs_Vds_tsmc_0.25u.png) |
|:---|

### 15.1.5 Lab: Velocity Saturation - sky130 (W=0.39um, L=0.15um)
<details> <summary> SPICE File: day2_nfet_idvds_L015_W039.spice </summary>

```
*** Model Description ***
.param temp=27

*** Including sky130 library files ***
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

*** Netlist Description ***

XM1 Vdd n1 0 0 sky130_fd_pr__nfet_01v8 w=0.39 l=0.15
R1 n1 in 55
Vdd vdd 0 1.8V
Vin in 0 1.8V

*** Simulation commands ***
.op
.dc Vdd 0 1.8 0.1 Vin 0 1.8 0.2

.control
run
display
setplot dc1
.endc

.end
```
</details>

| **Output:** ![CircuitDesignWorkshop_D2_Velocity_Saturation_Id_vs_Vds_sky130_Short_Channel](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_Id_vs_Vds_sky130_Short_Channel.png) |
|:---|

### 15.1.6 Lab: Velocity Saturation - ID$ vs. VGS - sky130 NMOS (5u/2u vs. 0.39u/0.15u)
<details> <summary> SPICE File: day2_nfet_idvgs_L015_W039.spice </summary>

```
*** Model Description ***
.param temp=27

*** Including sky130 library files ***
.lib "sky130_fd_pr/models/sky130.lib.spice" tt

**** Netlist Description ***
XM1 Vdd n1 0 0 sky130_fd_pr__nfet_01v8 w=0.39 l=0.15
R1 n1 in 55
Vdd vdd 0 1.8V
Vin in 0 1.8V

*** Simulation Commands ***
.op
.dc Vin 0 1.8 0.1 Vdd 1.8 1.8 0.2 

.control
run
display
setplot dc1
.endc

.end
```
</details>

| **Output:** ![CircuitDesignWorkshop_D2_Velocity_Saturation_Id_vs_Vgs_sky130_LongvsShortChannel](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_Velocity_Saturation_Id_vs_Vgs_sky130_LongvsShortChannel.png) |
|:---|

## 15.2 CMOS Inverter VTC
  - The Voltage-Transfer Characteristic (VTC) can be graphically derived by superimposing the current characteristics of the NMOS and the PMOS devices -- i.e., their respective _**load-line plots**_.
  - It requires that the I-V curves of the NMOS and PMOS devices are transformed onto a common coordinate set.


  - To plot the VTC or the Input-Output transfer characteristics ($V_{out}$ vs. $V_{in}$) of the CMOS Inverter, let us choose the input voltage $V_{in}, the output voltage $V_{out}$ and the NMOS drain current $I_{DSn}$ as the independent variables.

| ![CircuitDesignWorkshop_D2_CMOS_Inverter_VTC_Rabaey_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_CMOS_Inverter_VTC_Rabaey_1.png) |
|:---|

  - The PMOS I-V relations can be translated into this variable space by the following relations:

  | KCL, KVL Constraints |
  |:---|
  | $I_{DSp} = -I_{DSn}$ |
  | $V_{GSn} = V_{in}; ~~~~~~~~ V_{GSp} = V_{in}-V_{DD}$ |
  | $V_{DSn} = V_{out}; ~~~~~~~ V_{DSp} = V_{out}-V_{DD}$ |

  - Now the input voltage, $V_{in}$ needs to be swept from 0 to $V_{DD}$ and find out the corresponding values of $V_{out}$.
  - The following transformations adjust the original PMOS I-V curves to the chosen common coordinate set {$V_{in}$, $V_{out}$ and $I_{Dsn}$}.

  | Transform | Comments |
  |:---|:---|
  | $I_{DSp} ~ \longrightarrow ~ I_{DSn}$ | Reflection about x-axis of $I_{DSp} ~ vs. ~ V_{DSp}$ curve.<br>  where, $I_{DSn} = -I_{DSp}$ |
  | $V_{GSp} ~ \longrightarrow ~ V_{in}$ | Variable change from $V_{GSp}$ to $V_{in}$.<br>  where, $V_{in} = V_{GSp}+V_{DD}$ |
  | $V_{DSp} ~ \longrightarrow ~ V_{out}$ | Translation along the x-axis.<br>  $V_{out} = V_{DSp}+V_{DD}$ |

| ![CircuitDesignWorkshop_D2_CMOS_Inverter_VTC_Rabaey_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_CMOS_Inverter_VTC_Rabaey_2.png) |
|:---|

  - Now, the PMOS and NMOS load lines are overlaid on top of each other.
  - For a DC operating points to be valid, the currents through the NMOS and PMOS devices must be equal. Graphically, this means that the DC operating points must be located at the intersection of corresponding load lines.
  - Find the set of all $(V_{in}, V_{out})$ pairs corresponding to the points of intersection and plot them to generate the VTC of the CMOS Inverter circuit.

| ![CircuitDesignWorkshop_D2_CMOS_Inverter_VTC_Rabaey_3](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_CMOS_Inverter_VTC_Rabaey_3.png) | ![CircuitDesignWorkshop_D2_CMOS_Inverter_VTC_Weste_Harris_1](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_CMOS_Inverter_VTC_Weste_Harris_1.png) |
|:---|:---|

**Relationships between voltages for the three regions of operation of PMOS, NMOS in a CMOS inverter:**  
| | Cutoff | Linear | Saturation |
|:---|:---|:---|:---|
| **NMOS** | $V_{GSn} < V_{Tn}$ <br>  $V_{in} < V_{Tn}$ <br>  <br>  <br>  <br>  | $V_{GSn} > V_{Tn}$ <br>  $V_{in} > V_{Tn}$ <br>  <br>  $V_{DSn} < (V_{GSn}-V_{Tn})$ <br>  $V_{out} < (V_{in}-V_{Tn})$ | $V_{GSn} > V_{Tn}$ <br>  $V_{in} > V_{Tn}$ <br>  <br>  $V_{DSn} > (V_{GSn}-V_{Tn})$ <br>  $V_{out} > (V_{in}-V_{Tn})$ |
| **PMOS** | $V_{GSp} > V_{Tp}$ <br>  $V_{in} > V_{DD} - \mid V_{Tp} \mid$ <br>  <br>  <br>  <br>  | $V_{GSp} < V_{Tp}$ <br>  $V_{in} < V_{DD}-\mid V_{Tp} \mid$ <br>  <br>  $V_{DSp} > (V_{GSp}-V_{Tp})$ <br>  $V_{out} > (V_{in}+\mid V_{Tp} \mid)$ | $V_{GSp} < V_{Tp}$ <br>  $V_{in} < V_{DD}-\mid V_{Tp} \mid$ <br>  <br>  $V_{DSp} < (V_{GSp}-V_{Tp})$ <br>  $V_{out} < (V_{in}+\mid V_{Tp} \mid)$ |

_**Note:**_ $V_{Tp}$ is negative.  


  - The operation of the CMOS inverter can be divided into five regions - A, B, C, D, E - indicated in the above figure.
   - For simplicity, let us assume $V_{Tp} = –V_{Tn}$ and that the PMOS transistor is ~2–3 times as wide as the NMOS transistor so that $k_n = k_p$.

| Region| Condition | PMOS | NMOS | Output |
|:---:|:---|:---|:---|:---|
| A | $0 \le V_{in} < V_{Tn}$ | Linear | Cutoff | $V_{out} = V_{DD}$ |
| B | $V_{Tn} \le V_{in} < (V_{DD}/2)$ | Linear | Saturation | $V_{out} > V_{DD}/2$ |
| C | $Vin = V_{DD}/2$ | Saturation | Saturation | $V_{out}$ drops sharply |
| D | $(V_{DD}/2) < V_{in} \le V_{DD}-\mid V_{Tp} \mid$ | Saturation | Linear | $V_{out} < V_{DD}/2$ |
| E | $V_{in} > V_{DD}-\mid V_{Tp} \mid$ | Cutoff | Linear | $V_{out} = 0$ |

  - Almost all the operating points are located either at the high or low output levels. The VTC of the inverter hence exhibits a _**very narrow transition zone**_ (resulting from the high gain during the switching transient).

<br>

_________________________________________________________________________________________________________  
[Prev: Day 14](Day_14.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 16](Day_16.md)  

