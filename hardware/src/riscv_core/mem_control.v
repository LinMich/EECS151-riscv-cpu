`include "Opcode.vh"

module mem_control (
    input [6:0] opcode,
    input [2:0] fnc,
    input [31:0] addr,
    input [31:0] pc,
    input [31:0] write_data,
    
    output [31:0] fmt_wr_data,
    output [3:0] we_data,
    output [3:0] we_inst
);

    reg [31:0] fmt_wr_data_reg;
    reg [3:0] we_data_reg;
    reg [3:0] we_inst_reg;
    
    assign fmt_wr_data = fmt_wr_data_reg;
    assign we_data = we_data_reg;
    assign we_inst = we_inst_reg;
    
    always @(*) begin
        case (opcode)
        `OPC_LUI: begin
            we_data_reg = (addr[28] == 1) ? 4'b1111 : 4'b0000;
            we_inst_reg = (addr[29] == 1 && pc[30] == 1) ? 4'b1111 : 4'b0000;
            fmt_wr_data_reg = write_data;
        end
        `OPC_STORE: begin
            case (fnc)
            `FNC_SW: begin // handle store word
                we_data_reg = (addr[28] == 1) ? 4'b1111 : 4'b0000;
                we_inst_reg = (addr[29] == 1 && pc[30] == 1) ? 4'b1111 : 4'b0000;
                fmt_wr_data_reg = write_data;
            end
            `FNC_SH: begin // handle store half
                case (addr[1:0])
                2'b00: begin
                    we_data_reg = (addr[28] == 1) ? 4'b0001 : 4'b0000;
                    we_inst_reg = (addr[29] == 1 && pc[30] == 1) ? 4'b0001 : 4'b0000;
                    fmt_wr_data_reg = {{24{1'b0}}, write_data[7:0]};
                end
                2'b01: begin
                    we_data_reg = (addr[28] == 1) ? 4'b0011 : 4'b0000;
                    we_inst_reg = (addr[29] == 1 && pc[30] == 1) ? 4'b0011 : 4'b0000;
                    fmt_wr_data_reg = {{16{1'b0}}, write_data[15:0]};
                end
                2'b10: begin
                    we_data_reg = (addr[28] == 1) ? 4'b0110 : 4'b0000;
                    we_inst_reg = (addr[29] == 1 && pc[30] == 1) ? 4'b0110 : 4'b0000;
                    fmt_wr_data_reg = {{8{1'b0}}, write_data[15:0], {8{1'b0}}};
                end
                2'b11: begin
                    we_data_reg = (addr[28] == 1) ? 4'b1100 : 4'b0000;
                    we_inst_reg = (addr[29] == 1 && pc[30] == 1) ? 4'b1100 : 4'b0000;
                    fmt_wr_data_reg = {write_data[15:0], {16{1'b0}}};
                end
                default: begin
                    we_data_reg = 4'b0000;
                    we_inst_reg = 4'b0000;
                    fmt_wr_data_reg = 32'b0;
                end
                endcase
            end
            `FNC_SB: begin // handle store byte
                case (addr[1:0])
                2'b00: begin
                    we_data_reg = (addr[28] == 1) ? 4'b0001 : 4'b0000;
                    we_inst_reg = (addr[29] == 1 && pc[30] == 1) ? 4'b0001 : 4'b0000;
                    fmt_wr_data_reg = {{24{1'b0}}, write_data[7:0]};
                end
                2'b01: begin
                    we_data_reg = (addr[28] == 1) ? 4'b0010 : 4'b0000;
                    we_inst_reg = (addr[29] == 1 && pc[30] == 1) ? 4'b0010 : 4'b0000;
                    fmt_wr_data_reg = {{16{1'b0}}, write_data[7:0], {8{1'b0}}};
                end
                2'b10: begin
                    we_data_reg = (addr[28] == 1) ? 4'b0100 : 4'b0000;
                    we_inst_reg = (addr[29] == 1 && pc[30] == 1) ? 4'b0100 : 4'b0000;
                    fmt_wr_data_reg = {{8{1'b0}}, write_data[7:0], {16{1'b0}}};
                end
                2'b11: begin
                    we_data_reg = (addr[28] == 1) ? 4'b1000 : 4'b0000;
                    we_inst_reg = (addr[29] == 1 && pc[30] == 1) ? 4'b1000 : 4'b0000;
                    fmt_wr_data_reg = {write_data[7:0], {24{1'b0}}};
                end
                default: begin
                    we_data_reg = 4'b0000;
                    we_inst_reg = 4'b0000;
                    fmt_wr_data_reg = 32'b0; 
                end
                endcase
            end
            default: begin
                we_data_reg = 4'b0000;
                we_inst_reg = 4'b0000;
                fmt_wr_data_reg = 32'b0;
            end
            endcase
        end
        default: begin
            we_data_reg = 4'b0000;
            we_inst_reg = 4'b0000;
            fmt_wr_data_reg = 32'b0;
        end
        endcase
    end

endmodule