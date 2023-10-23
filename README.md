# VSD-HDP
This GitHub repository is created as part of attending the VLSI Hardware Development Program ([VSD-HDP](https://www.vlsisystemdesign.com/hdp/), Cohort: 21 October, 2023 – 29 December, 2023).
<br />
<br />
 **Progress Status**
 | Day # | Topic(s) Covered |
 |---|---|
 |[Day 0](#day-0) | GitHub repo creation, System/ Tools Setup |
 |[Day 1](#day-2) | Introduction to Verilog RTL design and Synthesis |


## Day 0
### System Setup
The program uses Open Source EDA tools and thus a linux OS environment is preferred.
<br />  
__Virtual Machine Requirements:__
  - OS: Ubuntu 18.04+
  - RAM: 6GB or above
  - HDD: 50GB or above
  - CPU cores: 4 vCPUs or more
  
### Tools Setup
 **1. yosys – Yosys Open SYnthesis Suite**  
We will be building Yosys from the source using gcc, the instructions for which are available in the official README for yosys in its GitHub repo.
[Build Yosys from source](https://github.com/YosysHQ/yosys#building-from-source)
<br />
   - Clone source code from git repository:
     ```
     git clone https://github.com/YosysHQ/yosys.git
     ```
    
  - Install the build system prerequsites/ dependencies:
    ```
    sudo apt-get install build-essential clang bison flex \
	libreadline-dev gawk tcl-dev libffi-dev git \
	graphviz xdot pkg-config python3 libboost-system-dev \
	libboost-python-dev libboost-filesystem-dev zlib1g-dev
    ```
    
  - Build (using gcc) and install Yosys:
    ```
    make config-gcc
    make
    sudo make install
    ```
  - ![day0_yosys](https://github.com/arunkpv/vsd-hdp/assets/79094513/08e41e35-5f95-4416-95af-011c6fb81ff8)
    
 **2. iverilog - Icarus Verilog**  
   - Install from official Ubuntu repository:
     ```
     sudo apt-get install iverilog
     ```
   - ![day0_iverilog](https://github.com/arunkpv/vsd-hdp/assets/79094513/5edb8420-274d-4309-8d23-ff3176a21094)
    
 **3. GTKWave**
   - Install from official Ubuntu repository:
     ```
     sudo apt-get install gtkwave
     ```

   - ![day0_gtkwave](https://github.com/arunkpv/vsd-hdp/assets/79094513/4a58eb72-04c6-41fb-9d1f-6f2f7dfd1c10)  


## Day 1
