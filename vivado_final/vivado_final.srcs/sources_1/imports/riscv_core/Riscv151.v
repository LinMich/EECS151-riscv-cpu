module Riscv151 #(
    parameter CPU_CLOCK_FREQ = 50_000_000
)(
    input clk,
    input rst,

    // Ports for UART that go off-chip to UART level shifter
    input FPGA_SERIAL_RX,
    output FPGA_SERIAL_TX
);

    // Instantiate your memories here
    // You should tie the ena, enb inputs of your memories to 1'b1
    // They are just like power switches for your block RAMs

    // Construct your datapath, add as many modules as you want
    ALU alu (
        .ina(),
        .inb(),
        .fnc3(),
        .fnc1(),
        .result() //output
    );
    
    branch_control branch_controller (
        .rs1(),
        .rs2(),
        .fnc(),
        .should_branch() //output
    );
    
    control_unit controller (
        .instruction(), //input
        .should_branch(), //input
        .op1_sel(),
        .op2_sel(),
        .b_jmp_target(),
        .wb_select(),
        .brjmp_jalr(),
        .take_brjmpjalr_inc(),
        .alu_func3(),
        .alu_func1()
    );
    
    instruction_decoder decoder (
        .instruction(), //input
        .j_sext(),
        .b_sext(),
        .s_sext(),
        .u_sext(),
        .i_sext(),
        .rs1(),
        .rs2(),
        .rd()
    );
    
    mem_control memory_controller (
        .opcode(),
        .fnc(),
        .addr(),
        .write_data(),
        .fmt_wr_data(), //output
        .we_data(), //output
        .we_inst() //ouput
    );
    
    mem_read_decoder datamem_read_decoder (
        .fnc(),
        .wanted_bytes(),
        .raw_data(),
        .data()
    );

    // On-chip UART
    uart #(
        .CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) on_chip_uart (
        .clk(clk),
        .reset(rst),
        .data_in(),
        .data_in_valid(),
        .data_out_ready(),
        .serial_in(FPGA_SERIAL_RX),

        .data_in_ready(),
        .data_out(),
        .data_out_valid(),
        .serial_out(FPGA_SERIAL_TX)
    );
endmodule
