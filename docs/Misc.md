[Back to TOC](../README.md)  
_________________________________________________________________________________________________________  
# Miscellaneous

## 1. Tools/ SW
### 1.1 WaveDrom
  - Generate timing diagrams programmatically from a textual description using this tool(Free and Open-Source).
  - It has an online editor as well as an offline executable version.
  - Links:
    - [WaveDrom](https://wavedrom.com/)
    - [WaveDrom Tutorial](https://wavedrom.com/tutorial.html)

### 1.2 nanoHUB
  - Strictly speaking nanoHUB is not a single software/ tool, rather it is an open and free online platform that makes available modeling and simulation tools for computational education, research, and collaboration in nanotechnology, materials science, and related fields.
  - For more information, see: [About NanoHub](https://nanohub.org/about)
  - Some tools of interest:
    1) [a TCAD lab: An Assembly of TCAD tools for circuit, device, and process simulation](https://nanohub.org/tools/atcadlab)
    2) [MOSCap](https://nanohub.org/resources/moscap)
    3) [MOSFet](https://nanohub.org/resources/mosfet)
    4) [MOSFET Simulation](https://nanohub.org/resources/mosfetsat)

### 1.3 netlistsvg
  - An npm package that helps to draw the schematic from the netlist
  - Link: [netlistsvg](https://github.com/nturley/netlistsvg)
  - How To:
  ```
    - Installation instructions are present in the readme
    - It works similar to what the Yosys show command would do.
    - To draw the schematic using this tool, we need Yosys to output the netlist as a json file:
      `write_json <netlist_filename.json>`
    - Then, from terminal:
      `netlistsvg input_json_file [-o output_svg_file]`
  ```

  - **Cons:**
    - Doesn't have any interactive hover highlighting of nets/ cells that the Yosys show command provides
    - Not sure if it supports colored nets/ elements like Yosys show
  - **Pros:**
    - Output is more of a schematic than the logical circuit diagram that Yosys show provides

| ![Yosys_show](/docs/images/Yosys_show.png) |
|:---|
| ![netlistsvg](/docs/images/netlistsvg.png) |

### 1.4 rvcodecjs
  - A RISC-V instruction encoder/ decoder: https://luplab.gitlab.io/rvcodecjs/
  - Works both ways:
    - provide the hex encoded value and it will provide the mnemonic
    - provide the mnemonic and it will provide the hex encoded value

### 1.5 GitHub - VSCode Web
  - In case you are managing GitHub repo from the web browser, pressing the "." (period key) with the GitHub repo opened in the browser tab will open up the Web-version of VS-Code !

| ![VSCode_Web](/docs/images/VSCode_Web.png) |
|:---:|

### 1.6 GitHub Codespaces
  - If you want to quickly run something that is not too resource intensive without having to set up a VirtualMachine locally, try out Codespaces.
  - Here is the entire OpenLane automated flow being run for my RISC-V CPU core in Codespace:

| ![GitHub_Codespace_running_OpenLane.png](/docs/images/GitHub_Codespace_running_OpenLane.png) |
|:---:|

## 2. Notes
### 2.1 Oracle VirtualBox VirtualMachine Snapshots
  - In case you're working inside a VirtualMachine environment and not a native Linux installation for this course project, I recommend that you should take a snapshot of the VM, just in case something gets screwed up.
  - It is better to take one snapshot after the installation of all the required tools and software completed and verified so that it kind of mimics a fresh install to always go back to.
  - Take any other snapshot(s), if required depending on which stage of the project you are at .

| ![VirtualBox_Snapshot](/docs/images/VirtualBox_Snapshot.png) |
|:---:|

### 2.2 Yosys preserving signals during Optimization
  - If you want any module, wire or reg from getting optimized out during synthesis by Yosys or abc, add a `(* keep *)` attribute to their respective declarations.
  - This will prevent Yosys & abc from removing them even if they are unused.
    - An example use-case is when using a hardcoded test program with a sequence of instruction memory entries to verify a CPU core.

### 2.3 Courses and Lecture series by Prof. Adam Teman
  - [Digital VLSI Design (RTL to GDS) course at Bar-Ilan University by Prof. Adam Teman](https://www.youtube.com/watch?v=GIPhBfenqMc&list=PLZU5hLL_713x0_AV_rVbay0pWmED7992G)
  - [Digital-on-top Physical Verification (Fullchip LVS/DRC)](https://www.youtube.com/watch?v=Hq6QD8aX2Q0&list=PLZU5hLL_713xp5sDexQMVdOM86l_wP5w8&index=1)
  - [Advanced Process Technologies](https://www.youtube.com/watch?v=5FEmD8ARF1g&list=PLZU5hLL_713x06MZ4OwMwnYGEeszuckZK)

### 2.4 Generate timing lib files for your design using OpenSTA
  - OpenSTA supports generating the timing lib file for your design using the command: `write_timing_model`

### 2.5 diychip.org: Browse the sky130 PDK standard cells
  - [https://diychip.org/sky130/sky130_fd_sc_hd/](https://diychip.org/sky130/sky130_fd_sc_hd/)

 

<br>

_________________________________________________________________________________________________________  
[Prev: Day 00](Day_00.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 00](Day_00.md)  

