[Back to TOC](../README.md)  
[Prev: TOC](../README.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day1](Day1.md)  
_________________________________________________________________________________________________________  
# Day 0: GitHub repo creation, System/ Tools Environment Setup

## 0.1 System Setup
The program uses Open Source EDA tools and thus a linux OS environment is preferred.
<br />  
__Virtual Machine Requirements:__
  - OS: Ubuntu 18.04+
  - RAM: 6GB or above
  - HDD: 50GB or above
  - CPU cores: 4 vCPUs or more
  
## 0.2 Tools Setup
### 0.2.1 yosys – Yosys Open SYnthesis Suite
We will be building Yosys from the source using gcc, the instructions for which are available in the official README for yosys in its GitHub repo.
[Build Yosys from source](https://github.com/YosysHQ/yosys#building-from-source)
<br />
   - Clone source code from git repository:
     ```shell
     git clone https://github.com/YosysHQ/yosys.git
     ```
    
  - Install the build system prerequsites/ dependencies:
    ```shell
    sudo apt-get install build-essential clang bison flex \
        libreadline-dev gawk tcl-dev libffi-dev git \
        graphviz xdot pkg-config python3 libboost-system-dev \
        libboost-python-dev libboost-filesystem-dev zlib1g-dev
    ```
    
  - Build (using gcc) and install Yosys:
    ```shell
    make config-gcc
    make
    sudo make install
    ```
    
  - Invoke from shell:  
    ![D0_yosys](/docs/images/D0_yosys.png)
  
### 0.2.2 iverilog - Icarus Verilog
   - Install from official Ubuntu repository:
     ```shell
     sudo apt-get install iverilog
     ```
     
   - Invoke from shell:  
     ![D0_iverilog](/docs/images/D0_iverilog.png)
  
### 0.2.3 GTKWave
   - Install from official Ubuntu repository:
     ```shell
     sudo apt-get install gtkwave
     ```
     
   - Invoke from shell:  
     ![D0_gtkwave](/docs/images/D0_gtkwave.png)  

_________________________________________________________________________________________________________  

[Prev: TOC](../README.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day1](Day1.md)  

