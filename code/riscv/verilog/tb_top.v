`timescale 1ns / 1ps
//`include "clk_gate.v"
//`include "primitives.v"
//`include "sky130_fd_sc_hd.v"

module tb_riscv_core;
    // Input(s)
    reg clk;
    reg reset;
    // Output(s)
    wire [9:0] out;
    
    
    riscv_core uut 
            (
        .clk(clk),
        .reset (reset),
        .out(out)
    );
    
    localparam CLK_PERIOD = 20;
    
    always #(CLK_PERIOD/2) clk=~clk;
    
    initial begin
        $dumpfile("presynth_sim.vcd");
        $dumpvars(0, tb_riscv_core);
    end
    
    initial begin
        clk = 1'h0;
        reset = 1'h0;
        #(CLK_PERIOD) reset = 1'h1;
        #(CLK_PERIOD * 3) reset = 1'h0;
        #(CLK_PERIOD * 300) $finish;
    end
endmodule
