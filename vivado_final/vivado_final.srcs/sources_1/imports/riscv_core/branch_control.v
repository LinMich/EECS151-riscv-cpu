`include "Opcode.vh"

module branch_control (
    input [31:0] rs1,
    input [31:0] rs2,
    input [2:0] fnc,
    
    output should_br
);

    reg should_br_pass;
    
    assign should_br = should_br_pass;

    always @(*) begin
        case (fnc)
        `FNC_BEQ: should_br_pass = (rs1 == rs2);
        `FNC_BNE: should_br_pass = (rs1 != rs2);
        `FNC_BLT: should_br_pass = ($signed(rs1) < $signed(rs2));
        `FNC_BGE: should_br_pass = ($signed(rs2) < $signed(rs1));
        `FNC_BLTU: should_br_pass = (rs1 < rs2);
        `FNC_BGEU: should_br_pass = (rs2 < rs1);
        default: should_br_pass = 1'b0;
        endcase
    end


endmodule