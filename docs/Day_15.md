[Back to TOC](../README.md)  
[Prev: Day 14](Day_14.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 16](Day_16.md)  
_________________________________________________________________________________________________________  
# Day 15 - Post-placement STA analysis of your Design (RISC-V Myth Core)
## 15.1 OpenLANE Installation
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
## 15.2 Usage Help
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
  * **<ins>Note:</ins>** The <design_name> must match the top-level module name of your design exactly. Otherwise, OpenLane will throw an error
  * This will create the following directory structure:
    ```
    designs/<design_name>
    ├── config.json (or config.tcl)
    ```
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
  

    

<br>

_________________________________________________________________________________________________________  
[Prev: Day 14](Day_14.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 16](Day_16.md)  

