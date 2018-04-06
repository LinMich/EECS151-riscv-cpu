`timescale 1ns / 1ps


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
    wire [31:0] rd1, rd2;
    
    // instantiate reg_file module
    
    reg_file RF(
        .clk(clk),
        .we(we),
        .ra1(ra1),
        .ra2(ra2),
        .wa(wa),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2));
        
    integer i;
 
    initial begin
        // reset all parts
        we = 1'b0;
        ra1 = 5'b0;
        ra2 = 5'b0;
        wa = 5'b0;
        wd = 32'b0;
        @(posedge clk);
        // Test 1: Register 0 is not writable, i.e. reading from register 0 always returns 0
        $display("Test 1");
        we = 1'b1;
        wd = {32{1'b1}};
        wa = 5'b0;
        ra1 = 5'b0;
        @(posedge clk);
        
        if (rd1 == 0) 
            $display("PASS: rd1 reads %b", rd1);
        else begin
            $display("FAIL: rd1 reads %b", rd1);
            $finish();
        end
     
        // Test 2: Other registers are updated on the same cycle that a write occurs 
        // (i.e. the value read on the cycle following the positive edge of the write should be the new value).
        $display("Test 2");
        we = 1'b1;
        wd = {32{1'b1}};
        wa = 1;
        ra1 = 1;
        #1;

        if (rd1 == {32{1'b1}}) 
            $display("PASS: rd1 reads %b", rd1);
        else 
            $display("FAIL: rd1 reads %b", rd1);     
        
        @(posedge clk);  
        // Test 3: The write enable signal to the register file controls whether a write occurs 
        // (we is active high, meaning you only write when we is high)
        $display("Test 3");
        we = 1'b1;
        wd = {32{1'b1}};
        wa = 31;
        ra1 = 31;
        @(posedge clk);  
        we = 1'b0;
        wd = 32'b0;
        wa = 31;
        ra1 = 31;
        @(posedge clk);
        if (rd1 == {32{1'b1}}) 
            $display("PASS: rd1 reads %b", rd1);
        else 
            $display("FAIL: rd1 reads %b", rd1);
            
        // Test 4: Reads should be asynchronous (the value at the output one simulation timestep (#1) 
        // after feeding in an input address should be the value stored in that register)
        $display("Test 4");
        ra1 = 30;
        #1;
        if (rd1 == 0) 
            $display("PASS: rd1 reads %b", rd1);
        else 
            $display("FAIL: rd1 reads %b", rd1);     
        
        ra1 = 31;
        #1;
        if (rd1 == {32{1'b1}}) 
            $display("PASS: rd1 reads %b", rd1);
        else 
            $display("FAIL: rd1 reads %b", rd1);
        @(posedge clk);    
        // Test 5: Test write and read to registers 1-31:
        $display("Test 5");
        for (i = 1; i < 32; i = i + 1) begin
            we = 1'b1;
            wd = i;
            wa = i;
            ra1 = i;
            ra2 = i;
            @(posedge clk);
            if (rd1 == i) 
                $display("PASS: rd1's reg%d reads %b", i, rd1);
            else 
                $display("FAIL: rd1's reg%d reads %b", i, rd1);
            if (rd2 == i) 
                $display("PASS: rd2's reg%d reads %b", i, rd2);
            else 
                $display("FAIL: rd2's reg%d reads %b", i, rd2);
        end
        $finish();
    end
endmodule 