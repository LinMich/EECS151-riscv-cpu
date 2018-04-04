`timescale 1ns / 1ps

`include "Opcode.vh"

module reg_file_testbench();
    parameter period = 20; // 20ns period for 50MHz clk
    
    reg clk;
    
    // generate clock signals
    initial clk = 0;
    always #(period/2) clk = ~clk;
    
    // registers and wires to test reg_file
    reg we;
    reg [4:0] ra1, ra2, wa;
    reg [31:0] wd;
    reg [31:0] rd1, rd2;
    
    // instantiate reg_file module
    
    reg_file RF(
        .clk(clk),
        .ra1(ra1),
        .ra2(ra2),
        .wa(wa),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2));
    
    
    
    
    
    
    
    
    
    
    
    
    
    