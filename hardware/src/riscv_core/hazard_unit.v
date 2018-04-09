`include "Opcode.vh"

module haz_unit (
    input [4:0] alu_in_rs1,
    input [4:0] alu_in_rs2,
    input [4:0] old_rd,
    input [4:0] older_rd,
    input older_regwe,
    input [6:0] old_opcode,
    
    output [2:0] fwd_rs1,
    output [2:0] fwd_rs2
);

    reg [2:0] fwd_rs1_pass;
    reg [2:0] fwd_rs2_pass;
    
    assign fwd_rs1 = fwd_rs1_pass;
    assign fwd_rs2 = fwd_rs2_pass;
    
    always @(*) begin
        if (alu_in_rs1 == old_rd) begin
            if (old_opcode == `OPC_LUI) fwd_rs1_pass = 3'b001;
            else if (old_opcode == `OPC_STORE) fwd_rs1_pass = 3'b011;
            else fwd_rs1_pass = 3'b010;
        end else if (alu_in_rs1 == older_rd && older_regwe) fwd_rs1_pass = 3'b100; // forward bc the regfile is sync write
        else fwd_rs1_pass = 3'b000;
        
        if (alu_in_rs2 == old_rd) begin
            if (old_opcode == `OPC_LUI) fwd_rs2_pass = 3'b001;
            else if (old_opcode == `OPC_STORE) fwd_rs2_pass = 3'b011;
            else fwd_rs2_pass = 3'b010;
        end else if (alu_in_rs2 == older_rd && older_regwe) fwd_rs2_pass = 3'b100; // forward bc the regfile is sync write
        else fwd_rs2_pass = 3'b000;
     
    end

endmodule