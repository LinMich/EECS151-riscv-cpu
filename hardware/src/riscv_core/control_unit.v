`include "Opcode.vh"

module control_unit (
    input [31:0] instruction,
    
    output [1:0] op1_sel, // selects rs1 input for alu
    output [1:0] op2_sel, // selects rs2 input for alu
    output b_jmp_target, // selects whether to take b or j type immediate for adding to pc
    output [1:0] wb_select, // selects which data source to write back to regfile from
    output brjmp_jalr, // selects whether pc should increment by 4, jump. or jalr
    output take_br, // 
    output br_or_inc,
    output [2:0] alu_func3, // forwards alu func 3
    output alu_func1 // forwards alu func 1
    
);

    always @(*) begin
        case(instruction[6:0]):
        OPC_LUI: begin
            op1_sel = 2'bxx;
            op2_sel = 2'bxx;
            b_jmp_target = 1'bx;
            wb_select = 2'b11;
            brjmp_jalr = 1'bx;
            take_br = 1'bx;
            br_or_inc = 1'b1;
            alu_func3 = 3'bxxx;
            alu_func1 = 1'bx;
        end
        OPC_AUIPC: begin
            op1_sel = 2'b00;
            op2_sel = 2'b00;
            b_jmp_target = 1'bx;
            wb_select = 2'b01;
            brjmp_jalr = 1'bx;
            take_br = 1'bx;
            br_or_inc = 1'b1;
            alu_func3 = FNC_ADD_SUB;
            alu_func1 = FNC2_ADD;
        end
        OPC_JAL: begin
            op1_sel = 2'bxx;
            op2_sel = 2'bxx;
            b_jmp_target = 1'b1;
            wb_select = 2'b00;
            brjmp_jalr = 1'b0;
            take_br = 1'b1;
            br_or_inc = 1'b0;
            alu_func3 = 3'bxxx;
            alu_func1 = 1'bx;
        end
        OPC_JALR: begin
            op1_sel = 2'b01;
            op2_sel = 2'b10;
            b_jmp_target = 1'bx;
            wb_select = 2'b00;
            brjmp_jalr = 2'b1;
            take_br = 1'b1;
            br_or_inc = 1'b0;
            alu_func3 = FNC_ADD_SUB;
            alu_func1 = FNC_ADD;
        end
        OPC_BRANCH: begin
            op1_sel = 2'bxx;
            op2_sel = 2'bxx;
            b_jmp_target = 1'b0;
            wb_select = 2'bxx;
            brjmp_jalr = 1'b0;
            take_br = 1'bx;
            br_or_inc = 1'b1;
            alu_func3 = 3'bxxx;
            alu_func1 = 1'bx;
        end
        OPC_STORE: begin
            op1_sel = 2'bxx;
            op2_sel = 2'bxx;
            b_jmp_target = 1'bx;
            wb_select = 2'bxx;
                        brjmp_jalr = 2'bxx;
            take_br = 1'bx;
            br_or_inc = 1'b1;
            alu_func3 = 3'bxxx;
            alu_func1 = 1'bx;
        end
        OPC_LOAD: begin
            op1_sel = 2'bxx;
            op2_sel = 2'bxx;
            b_jmp_target = 1'bx;
            wb_select = 2'bxx;
                        brjmp_jalr = 2'bxx;
            take_br = 1'bx;
            br_or_inc = 1'b1;
            alu_func3 = 3'bxxx;
            alu_func1 = 1'bx;
        end
        OPC_ARI_RTYPE: begin
            op1_sel = 2'bxx;
            op2_sel = 2'bxx;
            b_jmp_target = 1'bx;
            wb_select = 2'bxx;
                        brjmp_jalr = 2'bxx;
            take_br = 1'bx;
            br_or_inc = 1'b1;
            alu_func3 = 3'bxxx;
            alu_func1 = 1'bx;
        end
        OPC_ARI_ITYPE: begin
            op1_sel = 2'bxx;
            op2_sel = 2'bxx;
            b_jmp_target = 1'bx;
            wb_select = 2'bxx;
                        brjmp_jalr = 2'bxx;
            take_br = 1'bx;
            br_or_inc = 1'b1;
            alu_func3 = 3'bxxx;
            alu_func1 = 1'bx;
        end
        default: begin
            op1_sel = 2'bxx;
            op2_sel = 2'bxx;
            b_jmp_target = 1'bx;
            wb_select = 2'bxx;
            brjmp_jalr = 2'bxx;
            take_br = 1'bx;
            br_or_inc = 1'bx;
            alu_func3 = 3'bxxx;
            alu_func1 = 1'bx;
        end        
        endcase
    end

endmodule