`include "Opcode.vh"

module mem_read_decoder (
    input [2:0] fnc,
    input [3:0] wanted_bytes,
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
            4'b0001: data_reg = { {24{raw_data[7]}}, raw_data[7:0] };
            4'b0011: data_reg = { {16{raw_data[15]}}, raw_data[15:0] };
            4'b0110: data_reg = { {16{raw_data[23]}}, raw_data[23:8] };
            4'b1100: data_reg = { {16{raw_data[31]}}, raw_data[31:16] };
            4'b1000: data_reg = { {24{raw_data[31]}}, raw_data[31:24] };
            default: data_reg = 32'bx;
            endcase
        end
        `FNC_LB: begin
            case (wanted_bytes)
            4'b0001: data_reg = { {24{raw_data[7]}}, raw_data[7:0] };
            4'b0010: data_reg = { {24{raw_data[15]}}, raw_data[15:8] };
            4'b0100: data_reg = { {24{raw_data[23]}}, raw_data[23:16] };
            4'b1000: data_reg = { {24{raw_data[31]}}, raw_data[31:24] };
            default: data_reg = 32'bx;
            endcase
        end
        `FNC_LHU: begin
            case (wanted_bytes)
            4'b0001: data_reg = { {24{0}}, raw_data[7:0] };
            4'b0011: data_reg = { {16{0}}, raw_data[15:0] };
            4'b0110: data_reg = { {16{0}}, raw_data[23:8] };
            4'b1100: data_reg = { {16{0}}, raw_data[31:16] };
            4'b1000: data_reg = { {24{0}}, raw_data[31:24] };
            default: data_reg = 32'bx;
            endcase
        end
        `FNC_LBU: begin
            case (wanted_bytes)
            4'b0001: data_reg = { {24{0}}, raw_data[7:0] };
            4'b0010: data_reg = { {24{0}}, raw_data[15:8] };
            4'b0100: data_reg = { {24{0}}, raw_data[23:16] };
            4'b1000: data_reg = { {24{0}}, raw_data[31:24] };
            default: data_reg = 32'bx;
            endcase
        end
        default: data_reg = 32'bx;
        endcase
    end

endmodule