# Day 10
## GLS of the implemented RISC-V CPU Core

  * The functional verification of the design has already been completed successfully in the Makerchip IDE itself.
  * To perform GLS of the implementation, we need to first convert the TL-Verilog code into synthesizable verilog and then perform the synthesis using Yosys.


### Sandpiper-Saas: Conversion of TLV code to Verilog
SandPiper TL-Verilog compiler, developed by Redwood EDA can be used to convert TL-Verilog code to Verilog or SystemVerilog code. SandPiper-SaaS provides a command-line interface to run the SandPiper TL-Verilog compiler as a microservice in the cloud. 
  * Install Sandpiper-SaaS by following the steps in the following link: [https://pypi.org/project/sandpiper-saas/](https://pypi.org/project/sandpiper-saas/)
  * To convert tlv file to verilog: ```sandpiper-saas -i <input_tlv_file.tlv> -o <output_file.v> --outdir <output_dir> --inlineGen --iArgs```
  * Please note that for conversion to verilog, edit the **File Format Line** (i.e., usually the first line) in the tlv source file to add an additional option: ```-p verilog```<br>  
    For example: Change ```\m4_TLV_version 1d: tl-x.org``` to ```\m4_TLV_version 1d -p verilog: tl-x.org```<br>  
    Additionally, the following arguments may also be added:
    * ```--noline : Disable `line directive in SV output.```
    * ```--bestsv : Optimize the readability of the generated SV code.```
<br>

**Using Sandpiper-SaaS with Edalize, Fusesoc**
   * Sandpiper-SaaS supports the Flow API and thus allowing sandpiper-saas to be used as a "frontend" to convert TL-Verilog to SystemVerilog/Verilog for any flow.
   * An example of how to use sandpiper-saas with Edalize or Fusesoc in various contexts - viz. standalone tool, frontend to Vivado, in a Custom flow) is available here:<br>
     [edalize_sandpiper_example](https://github.com/shariethernet/edalize_sandpiper_example)  

Additional Reference Links:  
  1) [Edalize](https://github.com/olofk/edalize.git)
  2) [Fusesoc](https://fusesoc.readthedocs.io/en/stable/user/installation.html)

<br>

**Update on GLS**
  * The TL-Verilog code of the RISC-V CPU core implementation was successfully converted to Verilog using Sandpiper-SaaS.  
  * To ensure that the flow is clean, I first tried GLS for a simple counter circuit:
     1) TL-V code of counter was verified in Makerchip IDE
     2) Convert to Verilog using Sandpiper-SaaS
     3) Verify functionality using iverilog
     4) Perform synthesis using Ysosys
     5) Verify correctness by performing GLS using the synthesis output in iverilog

All steps until (iv) are verified to be working fine, however, the GLS using the synthesis tool generated netlist is failing.

_________________________________________________________________________________________________________  
<br>
