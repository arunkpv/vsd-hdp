[Back to TOC](../README.md)  
[Prev: Day 12](Day_12.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 14](Day_14.md)  
_________________________________________________________________________________________________________  
# Day 13: STA using OpenSTA
## 13.1 OpenSTA installation
The instructions to build and instal OpenSTA from source is provided in the following GitHub ReadMe:  
[https://github.com/parallaxsw/OpenSTA](https://github.com/parallaxsw/OpenSTA)  

Install all the build dependencies and the external library dependencies first and then follow the installation steps below:  
(For newer builds, `libeigen3-dev` is a required external library, which can be installed using apt or other package managers)  
```
git clone https://github.com/parallaxsw/OpenSTA.git
cd OpenSTA
mkdir build
cd build
cmake .. -DUSE_TCL_READLINE=ON
make
sudo make install
```



<br>

_________________________________________________________________________________________________________  
[Prev: Day 12](Day_12.md)$~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~$[Next: Day 14](Day_14.md)  

