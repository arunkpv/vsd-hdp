[Back to TOC](../README.md)  
[Prev: Day 14](Day_14.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 16](Day_16.md)  
_________________________________________________________________________________________________________  
# Day 15 - Post-placement STA analysis of your Design (RISC-V Myth CPU Core)
## 15.1 OpenLANE Installation (latest stable version)
For ease of installation, OpenLane uses Docker images, that include all the required applications, binaries and the flow scripts.  
The [OpenLane Installation Documentation](https://openlane.readthedocs.io/en/latest/getting_started/installation/installation_ubuntu.html) page explains in detail the step to setup OpenLANE. A short summary of the necessary steps is given below:  
  * Install the required dependencies:
    ```
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt install -y build-essential python3 python3-venv make git
    ```
  * [Docker Installation](https://docs.docker.com/engine/install/ubuntu/)
    1) Run the following command to uninstall all conflicting packages:
       ```
       for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
       ```
    2) Set up Docker's apt repository
       ```
       # Add Docker's official GPG key:
       sudo apt-get update
       sudo apt-get install ca-certificates curl
       sudo install -m 0755 -d /etc/apt/keyrings
       sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
       sudo chmod a+r /etc/apt/keyrings/docker.asc
       
       # Add the repository to Apt sources:
       echo \
         "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
         $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
         sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
       sudo apt-get update
       ```
    3) Install the Docker packages:
       ```
       sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
       ```
    4) Verify that the Docker Engine installation is successful by running:
       ```
       sudo docker run hello-world
       ```  
       To make Docker available without root:  
       ```
       sudo groupadd docker
       sudo usermod -aG docker $USER
       sudo reboot # REBOOT!
       
       # After reboot
       docker run hello-world
       ```
  * Download OpenLane from GitHub:
    ```
    git clone --depth 1 https://github.com/The-OpenROAD-Project/OpenLane.git
    cd OpenLane/
    make
    make test
    ```
    * These steps will download and build **OpenLane and sky130 PDK**.
    * Finally, it will run a ~5 minute test that verifies that the flow and the PDK were properly installed. Successful test will output the following line:
    ```
    Basic test passed
    ```
## 15.2 Basic Usage
### 15.2.1 Invoking the OpenLane Docker session:
```
cd to the OpenLane folder

# Start the Docker session:
make mount

# Leave the Docker
exit
```

### 15.2.2 [Adding Your Designs](https://openlane.readthedocs.io/en/latest/usage/designs.html)
  * To add a new design, the following command creates a configuration file for your design:
    ```
    # JSON Configuration File
    ./flow.tcl -design <design_name> -init_design_config -add_to_designs
    
    # Tcl Configuration File
    ./flow.tcl -design <design_name> -init_design_config -add_to_designs -config_file config.tcl
    ```
    This will create the following directory structure:
    ```
    designs/<design_name>
    ├── config.json (or config.tcl)
    ```
    * **NOTE:** The <design_name> must match the top-level module name of your design _**exactly**_. Otherwise, OpenLane will throw an error (at least by the `run_synthesis` stage).
  * It is recommended to place the verilog files of the design in a src directory inside the folder of the design as following:
    ```
    designs/<design_name>
    ├── config.tcl
    ├── src
    │   ├── design.v
    ```

### 15.2.3 Running the flow for the design:
  * To run the automated flow:
    ```
    ./flow.tcl -design <design_name>
    ```
  * To run the flow interactively ([Interactive Mode](https://openlane.readthedocs.io/en/latest/reference/interactive_mode.html)):
    ```
    ./flow.tcl -interactive
    ```
    A tcl shell will be opened where the openlane package is to be sourced
    ```
    package require openlane 0.9
    ```
    Now, the following main commands run the various major steps of the Physical design flow:
    ```
    0. Any valid Tcl code
    1. prep -design <design> [-tag TAG] [-config CONFIG] [-init_design_config] [-overwrite]
    2. run_synthesis
    3.run_floorplan
    4.run_placement
    5.run_cts
    6.run_routing
    7.a write_powered_verilog 
    7.b set_netlist $::env(routing_logs)/$::env(DESIGN_NAME).powered.v
    8. run_magic
    9. run_magic_spice_export
    10. run_magic_drc
    11. run_lvs
    12. run_antenna_check
    ```

### 15.2.4 Some FYI Notes:
  * [Command-Line Arguments that can be passed to flow.tcl](https://openlane.readthedocs.io/en/latest/reference/cli.html)

  | Argument | Description |
  |:---|:---|
  | `-tag <name>` <br>  (Optional) | Specifies a “name” for a specific run. If the tag is not specified, a timestamp is generated for identification of that run. |
  | `-overwrite` <br>  (Optional) | Flag to overwrite an existing run with the same tag |
  | `-synth_explore` | If enabled, synthesis exploration will be run (only synthesis exploration), which will try out the available synthesis strategies against the input design. |
  | `-verbose <level>` <br>  (Optional) | 0: Outputs only high-level messages <br>  1: Also ouputs some of the inner workings of the flow scripts <br>  >=2: Forwards outputs from all tools |
  
  * [Design configuration files: config.json (or config.tcl)](https://openlane.readthedocs.io/en/latest/reference/configuration_files.html)  
    Each OpenLane-compatible design must come with a configuration file written in either JSON or Tcl.
  * [Flow Configuration variables](https://openlane.readthedocs.io/en/latest/reference/configuration.html)
  * [PDK Configuration variables](https://openlane.readthedocs.io/en/latest/reference/pdk_configuration.html)
  * [Tcl commands available in OpenLane](https://openlane.readthedocs.io/en/latest/reference/openlane_commands.html)
    * When running the flow in interactive mode, use the `-verbose <level>` flag with the `prep -design <design_name>` command to set the verbose output level (2 and greater outputs everything including tool outputs).
      Example: `prep -design riscv_core -tag run1 -overwrite -verbose 2`

## 15.3 Synthesis Results
  * Some synthesis settings modified:
    ```
    set ::env(SYNTH_STRATEGY) "DELAY 0"
    set ::env(SYNTH_BUFFERING) 1
    set ::env(SYNTH_SIZING) 1
    set ::env(SYNTH_SPLITNETS) 0
    set ::env(SYNTH_MAX_FANOUT) 6
    ```
  * In addition, the `Openlane/scripts/yosys/synth.tcl` file was modified, with the sequence of yosys/ abc synthesis commands being modified in accordance with [this comment from Yosys issue #4266](https://github.com/YosysHQ/yosys/issues/4266#issuecomment-2019126857).
  * **<details><summary>Synthesis cell usage statistics:</summary>**
    ```
    === riscv_core ===
    
       Number of wires:               8458
       Number of wire bits:          11999
       Number of public wires:         176
       Number of public wire bits:    3717
       Number of memories:               0
       Number of memory bits:            0
       Number of processes:              0
       Number of cells:              11997
         sky130_fd_sc_hd__a2111o_2      10
         sky130_fd_sc_hd__a2111oi_2      2
         sky130_fd_sc_hd__a211o_2      132
         sky130_fd_sc_hd__a211oi_2      38
         sky130_fd_sc_hd__a21bo_2        3
         sky130_fd_sc_hd__a21boi_2       6
         sky130_fd_sc_hd__a21o_2        41
         sky130_fd_sc_hd__a21oi_2      894
         sky130_fd_sc_hd__a221o_2      442
         sky130_fd_sc_hd__a221oi_2       3
         sky130_fd_sc_hd__a22o_2       318
         sky130_fd_sc_hd__a22oi_2        5
         sky130_fd_sc_hd__a2bb2o_2       4
         sky130_fd_sc_hd__a311o_2       54
         sky130_fd_sc_hd__a311oi_2       2
         sky130_fd_sc_hd__a31o_2        72
         sky130_fd_sc_hd__a31oi_2       41
         sky130_fd_sc_hd__a32o_2       216
         sky130_fd_sc_hd__a32oi_2        2
         sky130_fd_sc_hd__a41o_2         6
         sky130_fd_sc_hd__a41oi_2        1
         sky130_fd_sc_hd__and2_2        40
         sky130_fd_sc_hd__and2b_2       24
         sky130_fd_sc_hd__and3_2       104
         sky130_fd_sc_hd__and3b_2        7
         sky130_fd_sc_hd__and4_2        32
         sky130_fd_sc_hd__and4b_2       23
         sky130_fd_sc_hd__and4bb_2      28
         sky130_fd_sc_hd__buf_1       2242
         sky130_fd_sc_hd__buf_2        940
         sky130_fd_sc_hd__conb_1       775
         sky130_fd_sc_hd__dfxtp_2     1907
         sky130_fd_sc_hd__inv_2         80
         sky130_fd_sc_hd__mux2_2        78
         sky130_fd_sc_hd__nand2_2      105
         sky130_fd_sc_hd__nand3_2       17
         sky130_fd_sc_hd__nand3b_2       2
         sky130_fd_sc_hd__nand4_2        1
         sky130_fd_sc_hd__nand4b_2       1
         sky130_fd_sc_hd__nor2_2       118
         sky130_fd_sc_hd__nor3_2         1
         sky130_fd_sc_hd__nor3b_2        5
         sky130_fd_sc_hd__nor4_2        12
         sky130_fd_sc_hd__nor4b_2        5
         sky130_fd_sc_hd__o2111ai_2      3
         sky130_fd_sc_hd__o211a_2       77
         sky130_fd_sc_hd__o211ai_2      31
         sky130_fd_sc_hd__o21a_2       944
         sky130_fd_sc_hd__o21ai_2       74
         sky130_fd_sc_hd__o21ba_2      516
         sky130_fd_sc_hd__o21bai_2      32
         sky130_fd_sc_hd__o221a_2       31
         sky130_fd_sc_hd__o221ai_2       4
         sky130_fd_sc_hd__o22a_2         5
         sky130_fd_sc_hd__o22ai_2        2
         sky130_fd_sc_hd__o2bb2a_2      10
         sky130_fd_sc_hd__o2bb2ai_2      4
         sky130_fd_sc_hd__o311a_2       19
         sky130_fd_sc_hd__o311ai_2       1
         sky130_fd_sc_hd__o31a_2       935
         sky130_fd_sc_hd__o31ai_2        1
         sky130_fd_sc_hd__o32a_2        12
         sky130_fd_sc_hd__o41a_2        45
         sky130_fd_sc_hd__or2_2         75
         sky130_fd_sc_hd__or2b_2        37
         sky130_fd_sc_hd__or3_2         63
         sky130_fd_sc_hd__or3b_2        18
         sky130_fd_sc_hd__or4_2        133
         sky130_fd_sc_hd__or4b_2        22
         sky130_fd_sc_hd__or4bb_2        4
         sky130_fd_sc_hd__xnor2_2       27
         sky130_fd_sc_hd__xor2_2        33
    ```
    </details>

  * **Chip area for module** `'\riscv_core': 115293.075200`

## 15.4 Placement (Pre-CTS)
  * **Placement optimizations:**
    ```
    Inserted 233 buffers in 70 nets.
    Resized 9498 instances.
    Inserted 513 tie sky130_fd_sc_hd__conb_1 instances.
    Inserted 262 tie sky130_fd_sc_hd__conb_1 instances.
    ```
  * **Design area**: `119232 u^2 36% utilization`

## 15.5 STA Comparison: Post-synthesis vs. Post-Placement (Pre-CTS)
| Post-Synthesis | Post-Placement (Pre-CTS) |
|:---:|:---:|
| ![D15_riscv_core_post-synthesis_STA](/docs/images/D15_riscv_core_post-synthesis_STA.png) | ![D15_riscv_core_post-placement_STA](/docs/images/D15_riscv_core_post-placement_STA.png) |

<br>

|   |  
|:---:|
| ![D15_riscv_core_synthesis_vs_post-placement_STA_wns_with_legend](/docs/images/D15_riscv_core_synthesis_vs_post-placement_STA_wns_with_legend.png) |
| ![D15_riscv_core_synthesis_vs_post-placement_STA_tns_with_legend](/docs/images/D15_riscv_core_synthesis_vs_post-placement_STA_tns_with_legend.png) |
| ![D15_riscv_core_synthesis_vs_post-placement_STA_setup_slack_with_legend](/docs/images/D15_riscv_core_synthesis_vs_post-placement_STA_setup_slack_with_legend.png) |
| ![D15_riscv_core_synthesis_vs_post-placement_STA_hold_slack_with_legend](/docs/images/D15_riscv_core_synthesis_vs_post-placement_STA_hold_slack_with_legend.png) |

<br>

_________________________________________________________________________________________________________  
[Prev: Day 14](Day_14.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 16](Day_16.md)  

