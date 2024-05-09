[Back to TOC](../README.md)  
[Prev: Day 14](Day_14.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 16](Day_16.md)  
_________________________________________________________________________________________________________  
# Day 15: Velocity Saturation and CMOS Inverter VTC

  - The behavior of transistors with very short channel lengths (called short-channel devices) deviates considerably from the resistive and saturated models.
  - The main reason for this deviation is the _**velocity saturation effect**_.
  - We had seen previously that the drift velocity is modelled by:  
    Drift velocity, $v = -\mu \dfrac{dV}{dx}$
      - i.e., the velocity of the carriers is proportional to the electrical field, independent of
the value of that field. In other words, the carrier mobility is a constant.
  - However, at high electric field strengths, the carriers fail to follow this linear model.
  - When the electrical field along the channel reaches a critical value $\xi_c$, the velocity of the carriers tends to saturate due to scattering effects (collisions suffered by the carriers).

| ![CircuitDesignWorkshop_D2_VelocitySaturation_Rabaey](/docs/images/CircuitDesignWorkshop/CircuitDesignWorkshop_D2_VelocitySaturation_Rabaey.png) |
|:---|

  - For p-type silicon:
    - the critical field at which electron saturation occurs is around $1.5 \times 10^6 V/m ~ (or~1.5 V/\mu m)$, and
    - the saturation velocity $v_{sat}$ approximately equals $10^5 m/s$
  - This means that in an NMOS device with a channel length of $1~\mu m$, only a couple of volts of $V_{DS}$ is needed to reach the electron velocity saturation point. This condition is easily met in current short-channel devices.
  - Holes in a n-type silicon saturate at the same velocity, although a higher electrical field is needed to achieve saturation. Velocity-saturation effects are hence less pronounced in PMOS transistors.

  - The drift velocity can be roughly approximated as a piece-wise linear function of the electrical field as follows:  
    - $v = \dfrac{\mu_n\xi}{1+\left(\dfrac{\xi}{\xi_c}\right)}~~~~~~~~,for~ \xi \le \xi_c$  
      $~~~=v_{sat}~~~~~~~~~~~~~~~~~~~~,for~\xi > \xi_c$  
  - For continuity at $\xi=\xi_c$, we get: $\xi_c = \dfrac{2v_{sat}}{\mu_n}$

Now the drain current equation in the resistive region can be re-evaluated as:  
$\boxed{I_D = \kappa(V_{DS}) \mu_n C_{ox} \dfrac{W}{L}\left[(V_{GS}-V_{TH})V_{DS} - \dfrac{{V_{DS}^2}}{2} \right]}$  
$ where, ~~~~ \kappa(V_{DS}) = \dfrac{1}{1+(V_{DS}/\xi_c L)}$  

  - $\kappa$ is a measure of the velocity saturation since $V_{DS}/L$ is the average field in the channel.
  - In the case of long-channel devices (where $L$ is large), or when the value of $V_{DS}$ is small, $\kappa$ approaches 1 and the above equation simplifies to the traditional equation we had derived first using the constant mobility model.
  - For short-channel devices, $\kappa$ is smaller than 1, implying the delivered current is smaller than what would be normally expected.

<br>

_________________________________________________________________________________________________________  
[Prev: Day 14](Day_14.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 16](Day_16.md)  

