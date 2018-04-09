`include "Opcode.vh"

module control_unit (
    input [31:0] instruction,
    input should_branch, // comes from the branch control module
    
    output [1:0] op1_sel, // selects rs1 input for alu
    output [1:0] op2_sel, // selects rs2 input for alu
    output b_jmp_target, // selects whether to take b or j type immediate for adding to pc
    output [1:0] wb_select, // selects which data source to write back to regfile from
    output brjmp_jalr, // selects whether pc should increment by 4, jump. or jalr
    output take_brjmpjalr_inc, // selects whether to use input from brjmp_jalr or pc+4 for new PC
    output [2:0] alu_func3, // forwards alu func 3
    output alu_func1, // forwards alu func 1
    output reg_we, // whether to write to reg file
    output [2:0] load_funct // function code for mem reader
);

    reg [1:0] op1_sel_reg;
    reg [1:0] op2_sel_reg;
    reg b_jmp_target_reg;
    reg [1:0] wb_select_reg;
    reg brjmp_jalr_reg;
    reg take_brjmpjalr_inc_reg;
    reg [2:0] alu_func3_reg;
    reg alu_func1_reg;
    reg reg_we_reg;
    reg [2:0] load_funct_reg;

    assign op1_sel = op1_sel_reg;
    assign op2_sel = op2_sel_reg;
    assign b_jmp_target = b_jmp_target_reg;
    assign wb_select = wb_select_reg;
    assign brjmp_jalr = brjmp_jalr_reg;
    assign take_brjmpjalr_inc = take_brjmpjalr_inc_reg;
    assign alu_func3 = alu_func3_reg;
    assign alu_func1 = alu_func1_reg;
    assign reg_we = reg_we_reg; // TODO: implement this signal
    assign load_funct = load_funct_reg;

    always @(*) begin
        case (instruction[6:0])
        `OPC_LUI: begin
            op1_sel_reg = 2'bxx;
            op2_sel_reg = 2'bxx;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'b11;
            brjmp_jalr_reg = 1'bx;
            take_brjmpjalr_inc_reg = 1'b0;
            alu_func3_reg = 3'bxxx;
            alu_func1_reg = 1'bx;
            reg_we_reg = 1'b1;
            load_funct_reg = 3'b000;
        end
        `OPC_AUIPC: begin
            op1_sel_reg = 2'b00;
            op2_sel_reg = 2'b00;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'b01;
            brjmp_jalr_reg = 1'bx;
            take_brjmpjalr_inc_reg = 1'b0;
            alu_func3_reg = `FNC_ADD_SUB;
            alu_func1_reg = `FNC2_ADD;
            reg_we_reg = 1'b1;
            load_funct_reg = 3'b000;
        end
        `OPC_JAL: begin
            op1_sel_reg = 2'bxx;
            op2_sel_reg = 2'bxx;
            b_jmp_target_reg = 1'b1;
            wb_select_reg = 2'b00;
            brjmp_jalr_reg = 1'b0;
            take_brjmpjalr_inc_reg = 1'b1;
            alu_func3_reg = 3'bxxx;
            alu_func1_reg = 1'bx;
            reg_we_reg = 1'b1;
            load_funct_reg = 3'b000;
        end
        `OPC_JALR: begin
            op1_sel_reg = 2'b01;
            op2_sel_reg = 2'b10;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'b00;
            brjmp_jalr_reg = 2'b1;
            take_brjmpjalr_inc_reg = 1'b1;
            alu_func3_reg = `FNC_ADD_SUB;
            alu_func1_reg = `FNC2_ADD;
            reg_we_reg = 1'b1;
            load_funct_reg = 3'b000;
        end
        `OPC_BRANCH: begin
            op1_sel_reg = 2'bxx;
            op2_sel_reg = 2'bxx;
            b_jmp_target_reg = 1'b0;
            wb_select_reg = 2'bxx;
            brjmp_jalr_reg = 1'b0;
            take_brjmpjalr_inc_reg = (should_branch) ? 1'b1 : 1'b0;
            alu_func3_reg = 3'bxxx;
            alu_func1_reg = 1'bx;
            reg_we_reg = 1'b0;
            load_funct_reg = 3'b000;
        end
        `OPC_STORE: begin
            op1_sel_reg = 2'b01;
            op2_sel_reg = 2'b01;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'bxx;
            brjmp_jalr_reg = 2'bxx;
            take_brjmpjalr_inc_reg = 1'b0;
            alu_func3_reg = `FNC_ADD_SUB;
            alu_func1_reg = `FNC2_ADD;
            reg_we_reg = 1'b0;
            load_funct_reg = instruction[14:12];
        end
        `OPC_LOAD: begin
            op1_sel_reg = 2'b01;
            op2_sel_reg = 2'b10;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'b10;
            brjmp_jalr_reg = 2'bxx;
            take_brjmpjalr_inc_reg = 1'b0;
            alu_func3_reg = `FNC_ADD_SUB;
            alu_func1_reg = `FNC2_ADD;
            reg_we_reg = 1'b1;
            load_funct_reg = instruction[14:12];
        end
        `OPC_ARI_RTYPE: begin
            op1_sel_reg = 2'b01;
            op2_sel_reg = 2'b11;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'b01;
            brjmp_jalr_reg = 2'bxx;
            take_brjmpjalr_inc_reg = 1'b0;
            alu_func3_reg = instruction[14:12];
            alu_func1_reg = instruction[30];
            reg_we_reg = 1'b1;
            load_funct_reg = 3'b000;
        end
        `OPC_ARI_ITYPE: begin
            op1_sel_reg = 2'b01;
            op2_sel_reg = 2'b10;
            b_jmp_target_reg = 1'bx;
            wb_select_reg = 2'b01;
            brjmp_jalr_reg = 2'bxx;
            take_brjmpjalr_inc_reg = 1'b0;
            alu_func3_reg = instruction[14:12];
            alu_func1_reg = (instruction[14:12] == `FNC_SRL_SRA) ? instruction[30] : 1'b0; // always 0 except for right shifts
            reg_we_reg = 1'b1;
            load_funct_reg = 3'b000;
        end
//        32'h00000000: begin
//            op1_sel_reg = 2'b00;
//            op2_sel_reg = 2'b00;
//            b_jmp_target_reg = 1'b0;
//            wb_select_reg = 2'b00;
//            brjmp_jalr_reg = 2'b00;
//            take_brjmpjalr_inc_reg = 1'b1;
//            alu_func3_reg = 3'b000;
//            alu_func1_reg = 1'b0;
//            reg_we_reg = 1'b0;
//        end
        default: begin
            op1_sel_reg = 2'b00;
            op2_sel_reg = 2'b00;
            b_jmp_target_reg = 1'b0;
            wb_select_reg = 2'b00;
            brjmp_jalr_reg = 2'b00;
            take_brjmpjalr_inc_reg = 1'b0;
            alu_func3_reg = 3'b000;
            alu_func1_reg = 1'b0;
            reg_we_reg = 1'b0;
            load_funct_reg = 3'b000;
        end        
        endcase
    end

endmodule