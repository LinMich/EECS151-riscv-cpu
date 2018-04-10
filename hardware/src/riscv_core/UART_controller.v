`include "Opcode.vh"

// this module handles formatting the 

module UART_controller (
    input [31:0] instruction, // from inst reg
    input [31:0] address, // from ALU out
    input [31:0] raw_write_data, // from forwarded rs2
    
    // signals from UART for passing control signals
    input data_out_valid,
    input data_in_ready,
    
    // signals for telling UART to transmit data being sent to it or read data from it
    output data_in_valid,
    output data_out_ready,
    
    output [7:0] formatted_write_data,
);

    reg data_in_valid_reg;
    reg data_out_ready_reg;
    reg [31:0] formatted_write_data_reg;
    
    assign data_in_valid = data_in_valid_reg;
    assign data_out_ready = data_out_ready_reg;
    assign formatted_write_data = formatted_write_data_reg;
    
    
    always @(*) begin
        if (address == 32'h80000008 && instruction[6:0] == `OPC_STORE) begin // store data from rs2 into UART
            data_in_valid_reg = 1;
            data_out_ready_reg = 0;
            formatted_write_data_reg = {24'b0, raw_write_data[7:0]};
        end else if (address == 32'h80000000 && instruction[6:0] == `OPC_LOAD) begin // load control signals to rd
            data_in_valid_reg = 0;
            data_out_ready_reg = 0;
            formatted_write_data_reg = {30'b0, data_out_valid, data_in_ready};
        end else if (address == 32'h80000004 && instruction [6:0] == `OPC_LOAD) begin // load data from UART to rd
            data_in_valid_reg = 0;
            data_out_ready_reg = 1;
            formatted_write_data_reg = 32'b0;
        end else
            data_in_valid_reg = 0;
            data_out_ready_reg = 0;
            formatted_write_data_reg = 32'd0;
        end
    end


endmodule