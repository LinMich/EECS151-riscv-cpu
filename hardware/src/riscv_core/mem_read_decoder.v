`include "Opcode.vh"

module mem_read_decoder (
    input [2:0] fnc,
    input [1:0] wanted_bytes,
    input [31:0] raw_data,
    
    output [31:0] data
);

    reg [31:0] data_reg;
    assign data = data_reg;
    
    always @(*) begin
        case (fnc)
        `FNC_LW: data_reg = raw_data;
        `FNC_LH: begin
            case (wanted_bytes)
            2'b00: data_reg = { {24{raw_data[7]}}, raw_data[7:0] };
            2'b01: data_reg = { {16{raw_data[15]}}, raw_data[15:0] };
            2'b10: data_reg = { {16{raw_data[23]}}, raw_data[23:8] };
            2'b11: data_reg = { {16{raw_data[31]}}, raw_data[31:16] };
            default: data_reg = 32'bx;
            endcase
        end
        `FNC_LB: begin
            case (wanted_bytes)
            2'b00: data_reg = { {24{raw_data[7]}}, raw_data[7:0] };
            2'b01: data_reg = { {24{raw_data[15]}}, raw_data[15:8] };
            2'b10: data_reg = { {24{raw_data[23]}}, raw_data[23:16] };
            2'b11: data_reg = { {24{raw_data[31]}}, raw_data[31:24] };
            default: data_reg = 32'bx;
            endcase
        end
        `FNC_LHU: begin
            case (wanted_bytes)
            2'b00: data_reg = { {24{1'b0}}, raw_data[7:0] };
            2'b01: data_reg = { {16{1'b0}}, raw_data[15:0] };
            2'b10: data_reg = { {16{1'b0}}, raw_data[23:8] };
            2'b11: data_reg = { {16{1'b0}}, raw_data[31:16] };
            4'b1000: data_reg = { {24{1'b0}}, raw_data[31:24] };
            default: data_reg = 32'bx;
            endcase
        end
        `FNC_LBU: begin
            case (wanted_bytes)
            2'b00: data_reg = { {24{1'b0}}, raw_data[7:0] };
            2'b01: data_reg = { {24{1'b0}}, raw_data[15:8] };
            2'b10: data_reg = { {24{1'b0}}, raw_data[23:16] };
            2'b11: data_reg = { {24{1'b0}}, raw_data[31:24] };
            default: data_reg = 32'bx;
            endcase
        end
        default: data_reg = 32'bx;
        endcase
    end

endmodule