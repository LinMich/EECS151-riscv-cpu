`include "Opcode.vh"

module hazard_unit (
    input [4:0] alu_in_rs1,
    input [4:0] alu_in_rs2,
    input [4:0] prev_rd,
    input [6:0] prev_opcode,
    
    output fwd_rs1,
    output fwd_rs2,
    output [1:0] lui_alu_load
);

    reg fwd_rs1_pass;
    reg fwd_rs2_pass;
    reg [1:0] lui_alu_load_pass;
    
    assign fwd_rs1 = fwd_rs1_pass;
    assign fwd_rs2 = fwd_rs2_pass;
    assign lui_alu_load = lui_alu_load_pass;
    
    always @(*) begin
        if (alu_in_rs1 == prev_rd) begin
            fwd_rs1_pass = 1;
            fwd_rs2_pass = 0;
        end 
        else if (alu_in_rs2 == prev_rd) begin
            fwd_rs1_pass = 0;
            fwd_rs2_pass = 1;
        end 
        else begin
            fwd_rs1_pass = 0;
            fwd_rs2_pass = 0;
        end
        
        // used for selecting whether to forward the output of the prev
        // cycle's ALU, imm for LUI inst, or result of load from memory
        if (prev_opcode == `OPC_LUI) lui_alu_load_pass = 2'b10;
        else if (prev_opcode == `OPC_STORE) lui_alu_load_pass = 2'b01;
        else lui_alu_load_pass = 2'b00;
    end

endmodule