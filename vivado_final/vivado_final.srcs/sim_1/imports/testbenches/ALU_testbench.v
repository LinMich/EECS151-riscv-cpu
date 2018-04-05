`include "Opcode.vh"

`timescale 1ns / 1ps

module ALU_testbench();
    parameter period = 20; // 20ns period for 50MHz clk
    
    reg clk;
    
    // generate clock signals
    initial clk = 0;
    always #(period/2) clk = ~clk;
    
    // registers and wires to test ALU
    reg [31:0] ina;
    reg [31:0] inb;
    
    reg [2:0] fnc3;
    reg fnc1;
    
    wire [31:0] result;
    
    reg [31:0] result_REF;
    // instantiate ALU module
    ALU alu(
        .ina(ina),
        .inb(inb),
        .fnc3(fnc3),
        .fnc1(fnc1),
        .result(result));

    integer i;
    
    reg [30:0] rand_31;
    reg [14:0] rand_15;
    reg [31:0] A, B;
    
    task checkOutput;
        if (result == result_REF)
            $display("PASS: \tA: 0x%h, B: 0x%h, result: 0x%h, result_REF: 0x%h", A, B, result, result_REF);
        else
            $display("FAIL: \tA: 0x%h, B: 0x%h, result: 0x%h, result_REF: 0x%h", A, B, result, result_REF);
    endtask
    initial begin
        // reset all parts
        ina = 32'b0;
        inb = 32'b0;
        fnc3 = 3'b0;
        fnc1 = 1'b0;
        for(i = 0; i < 20; i = i + 1) begin
            #1;
            // Make both A and B negative to check signed operations
            rand_31 = {$random} & 31'h7FFFFFFF;
            rand_15 = {$random} & 15'h7FFF;
            A = {1'b1, rand_31};
            // Hard-wire 16 1's in front of B for sign extension
            B = {16'hFFFF, 1'b1, rand_15};
            
            //Test add:
            ina = A;
            inb = B;
            fnc3 = `FNC_ADD_SUB;
            fnc1 = `FNC2_ADD;
            result_REF = A + B;
            #1
            checkOutput();
            //Test sub:
            
            
            
        end
        $finish();
    end
endmodule 