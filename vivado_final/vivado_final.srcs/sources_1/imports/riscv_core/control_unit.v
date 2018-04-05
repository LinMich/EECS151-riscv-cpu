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

    reg [1:0] op1_sel_reg;
    reg [1:0] op2_sel_reg;
    reg b_jmp_target_reg;
    reg [1:0] wb_select_reg;
    reg brjmp_jalr_reg;
    reg take_br_reg;
    reg br_or_inc_reg;
    reg [2:0] alu_func3_reg;
    reg alu_func1_reg;

    assign op1_sel = op1_sel_reg;
    assign op2_sel = op2_sel_reg;
    assign b_jmp_target = b_jmp_target_reg;
    assign wb_select = wb_select_reg;
    assign brjmp_jalr = brjmp_jalr_reg;
    assign take_br = take_br_reg;
    assign br_or_inc = br_or_inc_reg;
    assign alu_func3 = alu_func3_reg;
    assign alu_func1 = alu_func1_reg;

    always @(*) begin
        case(instruction[6:0])
        `OPC_LUI: begin
            op1_sel_reg = 2'bxx;
            op2_sel_reg = 2'bxx;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'b11;
            brjmp_jalr_reg = 1'bx;
            take_br_reg = 1'bx;
            br_or_inc_reg = 1'b1;
            alu_func3_reg = 3'bxxx;
            alu_func1_reg = 1'bx;
        end
        `OPC_AUIPC: begin
            op1_sel_reg = 2'b00;
            op2_sel_reg = 2'b00;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'b01;
            brjmp_jalr_reg = 1'bx;
            take_br_reg = 1'bx;
            br_or_inc_reg = 1'b1;
            alu_func3_reg = `FNC_ADD_SUB;
            alu_func1_reg = `FNC2_ADD;
        end
        `OPC_JAL: begin
            op1_sel_reg = 2'bxx;
            op2_sel_reg = 2'bxx;
            b_jmp_target_reg = 1'b1;
            wb_select_reg = 2'b00;
            brjmp_jalr_reg = 1'b0;
            take_br_reg = 1'b1;
            br_or_inc_reg = 1'b0;
            alu_func3_reg = 3'bxxx;
            alu_func1_reg = 1'bx;
        end
        `OPC_JALR: begin
            op1_sel_reg = 2'b01;
            op2_sel_reg = 2'b10;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'b00;
            brjmp_jalr_reg = 2'b1;
            take_br_reg = 1'b1;
            br_or_inc_reg = 1'b0;
            alu_func3_reg = `FNC_ADD_SUB;
            alu_func1_reg = `FNC2_ADD;
        end
        `OPC_BRANCH: begin
            op1_sel_reg = 2'bxx;
            op2_sel_reg = 2'bxx;
            b_jmp_target_reg = 1'b0;
            wb_select_reg = 2'bxx;
            brjmp_jalr_reg = 1'b0;
            take_br_reg = 1'bx;
            br_or_inc_reg = 1'b1;
            alu_func3_reg = 3'bxxx;
            alu_func1_reg = 1'bx;
        end
        `OPC_STORE: begin
            op1_sel_reg = 2'bxx;
            op2_sel_reg = 2'bxx;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'bxx;
            brjmp_jalr_reg = 2'bxx;
            take_br_reg = 1'bx;
            br_or_inc_reg = 1'b1;
            alu_func3_reg = 3'bxxx;
            alu_func1_reg = 1'bx;
        end
        `OPC_LOAD: begin
            op1_sel_reg = 2'bxx;
            op2_sel_reg = 2'bxx;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'bxx;
            brjmp_jalr_reg = 2'bxx;
            take_br_reg = 1'bx;
            br_or_inc_reg = 1'b1;
            alu_func3_reg = 3'bxxx;
            alu_func1_reg = 1'bx;
        end
        `OPC_ARI_RTYPE: begin
            op1_sel_reg = 2'bxx;
            op2_sel_reg = 2'bxx;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'bxx;
            brjmp_jalr_reg = 2'bxx;
            take_br_reg = 1'bx;
            br_or_inc_reg = 1'b1;
            alu_func3_reg = 3'bxxx;
            alu_func1_reg = 1'bx;
        end
        `OPC_ARI_ITYPE: begin
            op1_sel_reg = 2'bxx;
            op2_sel_reg = 2'bxx;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'bxx;
            brjmp_jalr_reg = 2'bxx;
            take_br_reg = 1'bx;
            br_or_inc_reg = 1'b1;
            alu_func3_reg = 3'bxxx;
            alu_func1_reg = 1'bx;
        end
        default: begin
            op1_sel_reg = 2'bxx;
            op2_sel_reg = 2'bxx;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'bxx;
            brjmp_jalr_reg = 2'bxx;
            take_br_reg = 1'bx;
            br_or_inc_reg = 1'bx;
            alu_func3_reg = 3'bxxx;
            alu_func1_reg = 1'bx;
        end        
        endcase
    end

endmodule