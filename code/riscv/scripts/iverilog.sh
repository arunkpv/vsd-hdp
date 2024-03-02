#!/bin/bash

echo "=== Running Pre-synth functional simulation ==="
iverilog -I ./include riscv_pipelined_Final.v tb_top.v
./a.out
gtkwave presynth_sim.vcd &

echo "=== Running Post-synth functional simulation ==="
iverilog -DFUNCTIONAL -DUNIT_DELAY=#1 ./lib/verilog_model/primitives.v ./lib/verilog_model/sky130_fd_sc_hd.v riscv_pipelined_Final_netlist.v tb_top_post-synth.v
./a.out
gtkwave postsynth_sim.vcd &
