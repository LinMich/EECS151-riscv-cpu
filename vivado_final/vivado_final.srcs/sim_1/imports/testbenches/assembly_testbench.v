`timescale 1ns/10ps

/* MODIFY THIS LINE WITH THE HIERARCHICAL PATH TO YOUR REGFILE ARRAY INDEXED WITH reg_number */
//`define REGFILE_ARRAY_PATH CPU.dpath.RF.reg_file[reg_number]
`define REGFILE_ARRAY_PATH CPU.reggie.register[reg_number]

module assembly_testbench();
    reg clk, rst;
    parameter CPU_CLOCK_PERIOD = 20;
    parameter CPU_CLOCK_FREQ = 10_000_000;

    initial clk = 0;
    always #(CPU_CLOCK_PERIOD/2) clk <= ~clk;

    Riscv151 # (
        .CPU_CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) CPU(
        .clk(clk),
        .rst(rst),
        .FPGA_SERIAL_RX(),
        .FPGA_SERIAL_TX()
    );

    // A task to check if the value contained in a register equals an expected value
    task check_reg;
        input [4:0] reg_number;
        input [31:0] expected_value;
        input [10:0] test_num;
        if (expected_value !== `REGFILE_ARRAY_PATH) begin
            $display("FAIL - test %d, got: %d, expected: %d for reg %d", test_num, `REGFILE_ARRAY_PATH, expected_value, reg_number);
            $finish();
        end
        else begin
            $display("PASS - test %d, got: %d for reg %d", test_num, expected_value, reg_number);
        end
    endtask

    // A task that runs the simulation until a register contains some value
    task wait_for_reg_to_equal;
        input [4:0] reg_number;
        input [31:0] expected_value;
        while (`REGFILE_ARRAY_PATH !== expected_value) @(posedge clk);
    endtask

    initial begin
        rst = 0;

        // Reset the CPU
        rst = 1;
        repeat (15) @(posedge clk);             // Hold reset for 30 cycles
        rst = 0;

        $display("beginning!");
        // Your processor should begin executing the code in /software/assembly_tests/start.s
        
        
//        // Test U-type: 
//        // Test LUI
//        wait_for_reg_to_equal(16, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd4096, 1);               // Verify that x1 contains 4096      
        
//        // Test AUIPC
//        wait_for_reg_to_equal(17, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'h40001008, 1);               // Verify that x1 contains 2      
//        // NOT SURE WHETHER THIS IS SUPPOSED TO BE PC OF INSTRUCTION OR CURRENT PC VAL.
        
               
               
               
//        // Test J-type: 
//        // Test JAL
//        wait_for_reg_to_equal(18, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd10, 1);               // Verify that x1 contains 2
                
                
                
                
//        // Test I-type: 
//        // Test JALR
//        wait_for_reg_to_equal(19, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(11, 32'd10, 1);               // Verify that x11 contains 10
        
//        // Test LB
//        wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'hC0000001, 1);               // Verify that x1 contains 0xC0000001
        
//        // Test LH
//        wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd4, 1);               // Verify that x1 contains 4
        
//        // Test LW
//        wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd2, 1);               // Verify that x1 contains 2
        
//        // Test LBU
//        wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'hC0000001, 1);               // Verify that x1 contains 0xC0000001
        
//        // Test LHU
//        wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd4, 1);               // Verify that x1 contains 4
        
//        // Test ADDI
//        wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(2, 2048, 1);               // Verify that x1 contains 2048
        
//        // Test SLTI
//        wait_for_reg_to_equal(21, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd1, 1);               // Verify that x1 contains 1
        
//        wait_for_reg_to_equal(22, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd0, 1);               // Verify that x1 contains 0
              
//        // Test SLTIU
//        wait_for_reg_to_equal(23, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd0, 1);               // Verify that x1 contains 0

//        wait_for_reg_to_equal(24, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd1, 1);               // Verify that x1 contains 1
                
//        // Test XORI
//        wait_for_reg_to_equal(25, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd2046, 1);               // Verify that x1 contains 2046
        
//        // Test ANDI
//        wait_for_reg_to_equal(26, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd1, 1);               // Verify that x1 contains 1
        
//        // Test SLLI
//        wait_for_reg_to_equal(27, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd4, 1);               // Verify that x1 contains 4
        
//        // Test SRLI
//        wait_for_reg_to_equal(28, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd2, 1);               // Verify that x1 contains 2
        
//        // Test SRAI
//        wait_for_reg_to_equal(29, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'hC0000000, 1);               // Verify that x1 contains 0xC0000001
        
        
        
                
//        // Test B-type:    
//        // Test BEQ
//        wait_for_reg_to_equal(13, 32'd1);       // Run the simulation until the flag is set to 2
//        check_reg(1, 32'd6, 1);               // Verify that x1 contains 500
        
//        // Test BNE
//        wait_for_reg_to_equal(14, 32'd1);       // Run the simulation until the flag is set to 2
//        check_reg(1, 32'd3, 1);               // Verify that x1 contains 500
        
//        // Test BLT
//        wait_for_reg_to_equal(15, 32'd1);       // Run the simulation until the flag is set to 2
//        check_reg(1, 32'd5, 1);               // Verify that x1 contains 500
        
//        // Test BGE
//        wait_for_reg_to_equal(16, 32'd1);       // Run the simulation until the flag is set to 2
//        check_reg(1, 32'd7, 1);               // Verify that x1 contains 500

//        // Test BLTU
//        wait_for_reg_to_equal(17, 32'd1);       // Run the simulation until the flag is set to 2
//        check_reg(1, 32'd3, 1);               // Verify that x1 contains 500

//        // Test BGEU
//        wait_for_reg_to_equal(18, 32'd1);       // Run the simulation until the flag is set to 2
//        check_reg(1, 32'd5, 1);               // Verify that x1 contains 500


//        // Test S-type:    
//        // Test SB
//        wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd300, 1);               // Verify that x1 contains 300
        
//        // Test SH
//        wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd300, 1);               // Verify that x1 contains 300
        
        // Test SW
        wait_for_reg_to_equal(19, 32'd1);       // Run the simulation until the flag is set to 1
//        check_reg(1, 32'd300, 1);               // Verify that x1 contains 300
        

 




        // Test R-type:    
        // Test ADD
        wait_for_reg_to_equal(30, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'd300, 1);               // Verify that x1 contains 300
        
        // Test SUB
        wait_for_reg_to_equal(31, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'd100, 1);               // Verify that x1 contains 100
        
        //****** Test LW
        wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(16, 32'd200, 1);               // Verify that x1 contains 2
        
        // Test SLL
        wait_for_reg_to_equal(20, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'd4, 1);               // Verify that x1 contains 4
        
        // Test SLT
        wait_for_reg_to_equal(21, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'd1, 1);               // Verify that x1 contains 1
        
        wait_for_reg_to_equal(22, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'd0, 1);               // Verify that x1 contains 0
        
        // Test SLTU
        wait_for_reg_to_equal(23, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'd0, 1);               // Verify that x1 contains 0
        
        wait_for_reg_to_equal(24, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'd1, 1);               // Verify that x1 contains 1
              
        // Test XOR
        wait_for_reg_to_equal(25, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'd6, 1);               // Verify that x1 contains 6
        
        // Test SRL
        wait_for_reg_to_equal(26, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'd2, 1);               // Verify that x1 contains 2
        
        // Test SRA
        wait_for_reg_to_equal(27, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'hC0000000, 1);               // Verify that x1 contains 0xC0000001
        
        // Test OR
        wait_for_reg_to_equal(28, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'd384, 1);               // Verify that x1 contains 384
        
        // Test AND
        wait_for_reg_to_equal(29, 32'd1);       // Run the simulation until the flag is set to 1
        check_reg(1, 32'd2046, 1);               // Verify that x1 contains 2046
        
        












        $display("ALL ASSEMBLY TESTS PASSED");
        $finish();
    end
endmodule
