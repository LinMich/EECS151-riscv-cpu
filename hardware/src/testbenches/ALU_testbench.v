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
    reg[4*8:0] type;
    
    task checkOutput;
    input reg[4*8:0] type;
        if (result == result_REF)
            $display("PASS %s: \tA: 0x%h, B: 0x%h, result: 0x%h, result_REF: 0x%h", type, A, B, result, result_REF);
        else begin
            $display("FAIL %s: \tA: 0x%h, B: 0x%h, result: 0x%h, result_REF: 0x%h", type, A, B, result, result_REF);
            $finish();
        end
    endtask
    initial begin
        // reset all parts
        ina = 32'b0;
        inb = 32'b0;
        fnc3 = 3'b0;
        fnc1 = 1'b0;
        for(i = 0; i < 20; i = i + 1) begin
             $display("Round %d", i);
            #1;
            // Make both A and B negative to check signed operations
            rand_31 = {$random} & 31'h7FFFFFFF;
            rand_15 = {$random} & 15'h7FFF;
            A = {1'b1, rand_31};
            // Hard-wire 16 1's in front of B for sign extension
            B = {16'hFFFF, 1'b1, rand_15};
            ina = A;
            inb = B;  
                      
            //Test ADD:
            type = "ADD";
            fnc3 = `FNC_ADD_SUB;
            fnc1 = `FNC2_ADD;
            result_REF = A + B;
            #1
            checkOutput(type);
            //Test SUB:
            type = "SUB";
            fnc1 = `FNC2_SUB;
            result_REF = A - B;
            #1         
            checkOutput(type);
            //Test SLL:
            type = "SLL";
            fnc3 = `FNC_SLL;
            result_REF = A << B[4:0];
            #1         
            checkOutput(type);
            //Test SLT:
            type = "SLT";
            fnc3 = `FNC_SLT;
            result_REF = $signed(A) < $signed(B);  
            #1         
            checkOutput(type);
            //Test SLTU:
            type = "SLTU";
            fnc3 = `FNC_SLTU;
            result_REF = A < B;
            #1         
            checkOutput(type);
            //Test XOR:
            type = "XOR";
            fnc3 = `FNC_XOR;
            result_REF = A ^ B;
            #1         
            checkOutput(type);
            //Test OR:
            type = "OR";
            fnc3 = `FNC_OR;
            result_REF = A | B;
            #1         
            checkOutput(type);
            //Test AND:
            type = "AND";
            fnc3 = `FNC_AND;
            result_REF = A & B;
            #1         
            checkOutput(type);
            //Test SRL:
            type = "SRL";
            fnc3 = `FNC_SRL_SRA;
            fnc1 = `FNC2_SRL;
            result_REF = A >> B[4:0];
            #1         
            checkOutput(type);
            //Test SRA:
            type = "SRA";
            fnc1 = `FNC2_SRA;
            result_REF = ($signed(A) >>> B[4:0]);                      
            #1         
            checkOutput(type);    
        end
        $finish();
    end
endmodule 