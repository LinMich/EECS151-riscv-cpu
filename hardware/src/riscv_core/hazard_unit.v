`include "Opcode.vh"

module haz_unit (
    input [4:0] alu_in_rs1,
    input [4:0] alu_in_rs2,
    input [4:0] prev_rd,
    input [6:0] prev_opcode,
    
    output [1:0] fwd_rs1,
    output [1:0] fwd_rs2
);

    reg [1:0] fwd_rs1_pass;
    reg [1:0] fwd_rs2_pass;
    
    assign fwd_rs1 = fwd_rs1_pass;
    assign fwd_rs2 = fwd_rs2_pass;
    
    always @(*) begin
        if (alu_in_rs1 == prev_rd) begin
            fwd_rs2_pass = 2'b00;
            if (prev_opcode == `OPC_LUI) fwd_rs1_pass = 2'b01;
            else if (prev_opcode == `OPC_STORE) fwd_rs1_pass = 2'b11;
            else fwd_rs1_pass = 2'b10;
        end 
        else if (alu_in_rs2 == prev_rd) begin
            fwd_rs1_pass = 0;
            if (prev_opcode == `OPC_LUI) fwd_rs2_pass = 2'b01;
            else if (prev_opcode == `OPC_STORE) fwd_rs2_pass = 2'b11;
            else fwd_rs2_pass = 2'b10;
        end 
        else begin
            fwd_rs1_pass = 0;
            fwd_rs2_pass = 0;
        end
        
        // used for selecting whether to forward the output of the prev
        // cycle's ALU, imm for LUI inst, or result of load from memory
//        if (prev_opcode == `OPC_LUI) lui_alu_load_pass = 2'b10;
//        else if (prev_opcode == `OPC_STORE) lui_alu_load_pass = 2'b01;
//        else lui_alu_load_pass = 2'b00;
    end

endmodule