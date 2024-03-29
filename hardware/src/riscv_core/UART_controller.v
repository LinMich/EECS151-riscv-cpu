`include "Opcode.vh"

// this module handles formatting the 

module UART_controller (
    input [31:0] instruction, // from inst reg
    input [31:0] address, // from ALU out
    input [31:0] raw_write_data, // from forwarded rs2
    
    
    input data_out_valid, // signals from UART for passing control signals
    input data_in_ready,
    
    
    output data_in_valid, // signals for telling UART to transmit data being sent to it or read data from it
    output data_out_ready,
    output data_write_ctrl_sig,
    output [31:0] formatted_write_data,
    output [7:0] uart_write_data
);

    reg data_in_valid_reg;
    reg data_out_ready_reg;
    reg data_write_ctrl_sig_reg;
    reg [31:0] formatted_write_data_reg;
    reg [7:0] uart_write_data_reg;
    
    assign data_in_valid = data_in_valid_reg;
    assign data_out_ready = data_out_ready_reg;
    assign data_write_ctrl_sig = data_write_ctrl_sig_reg;
    assign formatted_write_data = formatted_write_data_reg;
    assign uart_write_data = uart_write_data_reg;
    
    
    always @(*) begin
        if (address == 32'h80000008 && instruction[6:0] == `OPC_STORE) begin // store data from rs2 into UART
            data_in_valid_reg = 1;
            data_out_ready_reg = 0;
            data_write_ctrl_sig_reg = 0;
//            formatted_write_data_reg = {24'b0, raw_write_data[7:0]};
            formatted_write_data_reg = 32'b0;
            uart_write_data_reg = raw_write_data[7:0];
        end else if (address == 32'h80000000 && instruction[6:0] == `OPC_LOAD) begin // load control signals to rd
            data_in_valid_reg = 0;
            data_out_ready_reg = 0;
            data_write_ctrl_sig_reg = 1;
            formatted_write_data_reg = {30'b0, data_out_valid, data_in_ready};
            uart_write_data_reg = 8'b0;
        end else if (address == 32'h80000004 && instruction [6:0] == `OPC_LOAD) begin // load data from UART to rd
            data_in_valid_reg = 0;
            data_out_ready_reg = 1;
            data_write_ctrl_sig_reg = 0;
            formatted_write_data_reg = 32'b0;
            uart_write_data_reg = 8'b0;
        end else begin
            data_in_valid_reg = 0;
            data_out_ready_reg = 0;
            data_write_ctrl_sig_reg = 0;
            formatted_write_data_reg = 32'd0;
            uart_write_data_reg = 8'b0;
        end
    end


endmodule