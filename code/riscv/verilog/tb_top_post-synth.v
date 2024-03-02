`timescale 1ns / 1ps
`include "./lib/verilog_model/primitives.v"
`include "./lib/verilog_model/sky130_fd_sc_hd.v"

module tb_riscv_core;
    // Input(s)
    reg clk;
    reg reset;
    // Output(s)
    wire [9:0] out;
    
    supply0 vgnd;
    supply1 vpwr;
    
    riscv_core uut 
            (
        `ifdef USE_POWER_PINS
            .VGND(vgnd),
            .VPWR(vpwr),
        `endif
        .clk(clk),
        .reset (reset),
        .out(out)
    );
    
    localparam CLK_PERIOD = 20;
    
    always #(CLK_PERIOD/2) clk=~clk;
    
    initial begin
        $dumpfile("postsynth_sim.vcd");
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
