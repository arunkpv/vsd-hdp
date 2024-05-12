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

This has the following implications:  

  - For a short-channel device and for large enough values of $V_{GT}$, $\kappa(V_{GT})$ is substantially smaller than 1, hence $V_{DSAT} < V_{GT}$. The device enters saturation before $V_{DS}$
reaches $(V_{GS} - V_{TH})$. Short-channel devices therefore experience an extended saturation region and tend to operate more often in saturation region compared to long-channel devices.
  -  The saturation current $I_{DSAT}$ displays a linear dependence with respect to the Gate-to-Source voltage $V_{GS}, which is in contrast with the squared dependence in the long-channel devices. This reduces the amount of current a transistor can deliver for a given control voltage.

| ![CircuitDesignWorkshop_D2_VelocitySaturation_Rabaey_2](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_VelocitySaturation_Rabaey_2.png) |
|:---|



<br>

_________________________________________________________________________________________________________  
[Prev: Day 14](Day_14.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 16](Day_16.md)  

