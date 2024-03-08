[Back to TOC](../README.md)  
[Prev: Day 10](Day_10.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 12](Day_12.md)  
_________________________________________________________________________________________________________  
# Day 11

Static Timing Analysis (STA) is a method of validating the timing performance of a design by checking all possible paths for timing violations.
  * The design is broken down into timing paths having start and endpoints, the signal propagation delay along each path is calculated, and checked for violations of timing constraints inside the design and at the input/output interfaces.
  * The STA analysis is the static type - i.e., the timing analysis is carried out statically and does not depend upon the data values being applied at the input pins.  

As the naming suggests, there is another method - Dynamic Timing Analysis (DTA) where the timing behaviour is analyzed by applying a stimulus/ test vector at the input signals, the resulting behaviour of the design is captured in the simulation and functionality is verified using the testbenches.
  * This approach verifies the design meets the timing requirements while simultaneously ensuring the functionality.
  * However, this is a very expensive method in terms of both simuation run time and resources as we cannot verify the entire space of test vectors exhaustively.
  * A trade-off could be to select the test vectors that exercise majority of the circuits, but this is usually not sufficient for sign-off as the coverage/ confidence obtained is only as exhaustive as the test vectors used and no 100% guarantee that the design will work across conditions.
## STA Basics
### Timing Arcs
1. Combinational arcs: Between input and output pin of a combinational block/ cell.
2. Sequential arcs: Between the clock pin and either the input or output
   * Timing check arc: Between the clock pin and the input. (For example, the setup and hold timing arcs between the clock pin and input data pin of a Flip Flop)
   * Delay arc: Between the clock pin and the output.
3. Net arcs: Between the output pin of a cell to the input pin of another cell. (i.e., between the driver pin of a net and the load pin of that net)

### Unateness
Defines how the output changes for different types of transitions on the input.
1. Positive unate: Rising input transition causes rising output transition and falling input transition causes falling output transition.
   * Examples: Buffer, AND Gate, OR Gate
2. Negative unate: Rising input transition causes falling output transition and falling input transition causes rising output transition.
   * Examples: Inverter, NAND Gate, NOR Gate
3. Non-unate: The output transition is determined not only by the direction of an input but also on the state of the other inputs.
   * Examples: XOR Gate

## Advanced Synthesis and STA with DC
### Clock Modelling
### IO Delays
### generated_clk
### vclk, max_latency, rise_fall IO Delays
**Update**: Constraint generation is in progress.  
<br>

_________________________________________________________________________________________________________  
[Prev: Day 10](Day_10.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 12](Day_12.md)  
