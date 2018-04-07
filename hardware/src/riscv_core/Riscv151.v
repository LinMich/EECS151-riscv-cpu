module Riscv151 #(
    parameter CPU_CLOCK_FREQ = 50_000_000
)(
    input clk,
    input rst,

    // Ports for UART that go off-chip to UART level shifter
    input FPGA_SERIAL_RX,
    output FPGA_SERIAL_TX
);

    /* REGISTERS AND WIRES */
    reg [31:0] pc_reg;
    
    // fetch/decode wires
    //wire [31:0] fd_inst;
    wire [4:0] fd_rs1_to_regf;
    wire [4:0] fd_rs2_to_regf;
    
    // fetch/decode stage outputs
    wire [31:0] fd_j_reg;
    wire [31:0] fd_b_reg;
    wire [31:0] fd_s_reg;
    wire [31:0] fd_u_reg;
    wire [31:0] fd_i_reg;
    wire [31:0] fd_rs2_reg;
    wire [31:0] fd_rs1_reg;
    wire [31:0] fd_inst_reg;
    wire [4:0] fd_rd_reg;
    
    // execute stage inputs
    reg [31:0] ex_j_reg;
    reg [31:0] ex_b_reg;
    reg [31:0] ex_s_reg;
    reg [31:0] ex_u_reg;
    reg [31:0] ex_i_reg;
    reg [31:0] ex_rs2_reg;
    reg [31:0] ex_rs1_reg;
    reg [31:0] ex_inst_reg;
    reg [4:0] ex_rd_reg;
    reg [31:0] ex_pc_reg;
    
    // execute stage wires
    reg [31:0] ex_alu_mux_1;
    reg [31:0] ex_alu_mux_2;
    wire ex_br_ctl_to_ctl;
    wire [31:0] ex_b_jmp_jalr_to_pc_mux;
    wire ex_take_or_inc;
    wire [1:0] ex_op1;
    wire [1:0] ex_op2;
    wire ex_fnc1;
    wire ex_brjmp_jalr;
    wire ex_b_jmp_targ;  
    
    // execute stage outputs
    // rd carries through from input reg
    wire [31:0] ex_aluout_reg;
    wire [31:0] ex_memwrdat_reg;
    wire [3:0] ex_wed_reg;
    wire [3:0] ex_wei_reg; 
    wire [2:0] ex_fnc3_reg;
    wire [1:0] ex_wbsel_reg;
    wire ex_regwe_reg;
    wire [1:0] ex_fwd_rs1;
    wire [1:0] ex_fwd_rs2;
    
    // mem/writeback stage inputs
    reg [31:0] mwb_aluout_reg;
    reg [31:0] mwb_memwrdat_reg;
    reg [3:0] mwb_wed_reg;
    reg [3:0] mwb_wei_reg; 
    reg [2:0] mwb_fnc3_reg;
    reg [1:0] mwb_wbsel_reg;
    reg mwb_regwe_reg;
    reg [4:0] mwb_rd_reg;
    reg [31:0] mwb_u_reg;
    reg [6:0] mwb_opcode_reg;
    
    // mem/writeback stage wires
    wire [31:0] mwb_dat_mem_to_reader;
    wire [31:0] mwb_data_mem_reader_out; // might not even need this... pretty sure we do
    reg [31:0] mwb_regfile_input_data;
    
    // Instantiate your memories here
    // You should tie the ena, enb inputs of your memories to 1'b1
    // They are just like power switches for your block RAMs
    bios_mem BIOS (
        .ena(1'b1),
        .enb(1'b1),
        .clka(clk),  
        .clkb(clk),  
        .addra(pc_reg[13:2]),     //12-bit, from I stage
        .douta(fd_inst_reg),           //32-bit, to mux to I stage (instruction)
        .addrb(),       //12-bit, from datapath
        .doutb()          //32-bit, to mux to M stage ("dataout from mem")   
    );
    
    dmem_blk_ram d_mem (
        .clka(clk),
        .ena(1'b1),
        .wea(mwb_wed_reg),
        .addra(mwb_aluout_reg[15:2]),
        .dina(mwb_memwrdat_reg),
        .douta(mwb_dat_mem_to_reader)
    );

    
    // Construct your datapath, add as many modules as you want
    ALU alu (
        .ina(ex_alu_mux_1),
        .inb(ex_alu_mux_2),
        .fnc3(ex_fnc3_reg),
        .fnc1(ex_fnc1),
        .result(ex_aluout_reg) //output
    );
    
    branch_control branch_controller (
        .rs1(ex_rs1_reg),
        .rs2(ex_rs2_reg),
        .fnc(ex_inst_reg[14:12]),
        .should_br(ex_br_ctl_to_ctl) //output
    );
    
    control_unit controller (
        .instruction(ex_inst_reg), //input
        .should_branch(ex_br_ctl_to_ctl), //input
        .op1_sel(ex_op1),
        .op2_sel(ex_op2),
        .b_jmp_target(ex_b_jmp_targ),
        .wb_select(ex_wbsel_reg),
        .brjmp_jalr(ex_brjmp_jalr),
        .take_brjmpjalr_inc(ex_take_or_inc),
        .alu_func3(ex_fnc3_reg),
        .alu_func1(ex_fnc1),
        .reg_we(ex_regwe_reg)
    );
    
    instruction_decoder decoder (
        .instruction(fd_inst_reg), //input
        .j_sext(fd_j_reg),
        .b_sext(fd_b_reg),
        .s_sext(fd_s_reg),
        .u_imm(fd_u_reg),
        .i_sext(fd_i_reg),
        .rs1(fd_rs1_to_regf),
        .rs2(fd_rs2_to_regf),
        .rd(fd_rd_reg)
    );
    
    reg_file reggie (
        .clk(clk),
        .we(mwb_regwe_reg),
        .ra1(fd_rs1_to_regf),
        .ra2(fd_rs2_to_regf),
        .wa(mwb_rd_reg),
        .wd(mwb_regfile_input_data),
        .rd1(fd_rs1_reg), //output
        .rd2(fd_rs2_reg) //output
    );
    
    mem_control memory_controller (
        .opcode(ex_inst_reg[6:0]),
        .fnc(ex_fnc3_reg),
        .addr(ex_aluout_reg),
        .write_data(ex_rs1_reg),
        .fmt_wr_data(ex_memwrdat_reg), //output
        .we_data(ex_wed_reg), //output
        .we_inst(ex_wei_reg) //ouput
    );
    
    mem_read_decoder datamem_read_decoder (
        .fnc(mwb_fnc3_reg),
        .wanted_bytes(mwb_wed_reg),
        .raw_data(mwb_dat_mem_to_reader),
        .data(mwb_data_mem_reader_out) //output
    );
    
    haz_unit hazard_unit (
        .alu_in_rs1(ex_inst_reg[19:15]),
        .alu_in_rs2(ex_inst_reg[24:20]),
        .prev_rd(mwb_rd_reg),
        .prev_opcode(mwb_opcode_reg),
        .fwd_rs1(ex_fwd_rs1), //output
        .fwd_rs2(ex_fwd_rs2) //output
    );
    
    always @(posedge clk) begin
        if (rst) begin
            pc_reg <= 'h40000000; // interprets as 32 bits
            
            ex_j_reg <= 0;
            ex_b_reg <= 0;
            ex_s_reg <= 0;
            ex_u_reg <= 0;
            ex_i_reg <= 0;
            ex_rs2_reg <= 0;
            ex_rs1_reg <= 0;
            ex_inst_reg <= 0;
            ex_rd_reg <= 0;
            ex_pc_reg <= 0;
            
            ex_alu_mux_1 <= 0;
            ex_alu_mux_2 <= 0;
            
            mwb_aluout_reg <= 0;
            mwb_memwrdat_reg <= 0;
            mwb_wed_reg <= 0;
            mwb_wei_reg <= 0; 
            mwb_fnc3_reg <= 0;

            mwb_wbsel_reg <= 0;
            mwb_regwe_reg <= 0;
            mwb_rd_reg <= 0;
            mwb_u_reg <= 0;
            mwb_opcode_reg <= 0;
            
            mwb_regfile_input_data <= 0;
        end
        else begin
            if (ex_take_or_inc) begin
                if (!ex_brjmp_jalr) pc_reg <= ex_aluout_reg;
                else pc_reg <= (ex_b_jmp_targ) ? (ex_pc_reg + ex_j_reg) : (ex_pc_reg + ex_b_reg);
            end
            else pc_reg <= pc_reg + 4;
            // end PC logic section
        
            // FD to EX
            ex_j_reg <= fd_j_reg;
            ex_b_reg <= fd_b_reg;
            ex_s_reg <= fd_s_reg;
            ex_u_reg <= fd_u_reg;
            ex_i_reg <= fd_i_reg;
            ex_rd_reg <= fd_rd_reg;
            //ex_rs1_reg <= fd_rs1_reg;
            //ex_rs2_reg <= fd_rs2_reg;
            ex_inst_reg <= fd_inst_reg;
            ex_pc_reg <= pc_reg;
        
            // EX to MWB
            mwb_aluout_reg <= ex_aluout_reg;
            mwb_memwrdat_reg <= ex_memwrdat_reg;
            mwb_wed_reg <= ex_wed_reg;
            mwb_wei_reg <= ex_wei_reg; 
            mwb_fnc3_reg <= ex_fnc3_reg;
            mwb_wbsel_reg <= ex_wbsel_reg;
            mwb_regwe_reg <= ex_regwe_reg;
            mwb_rd_reg <= ex_rd_reg;
            mwb_u_reg <= ex_u_reg;
            mwb_opcode_reg <= ex_inst_reg[6:0];
        end
    end
    
    always @(*) begin
        // input to regfile writing.
        case (mwb_wbsel_reg)
        2'b00: mwb_regfile_input_data = ex_pc_reg;
        2'b01: mwb_regfile_input_data = mwb_aluout_reg;
        2'b10: mwb_regfile_input_data = mwb_data_mem_reader_out;
        2'b11: mwb_regfile_input_data = mwb_u_reg;
        default: mwb_regfile_input_data = 32'bx;
        endcase
        
        // input a to ALU
        case (ex_op1)
        2'b00: ex_alu_mux_1 = ex_u_reg;
        2'b01: ex_alu_mux_1 = ex_rs1_reg;
        default: ex_alu_mux_1 = 32'bx;
        endcase
        
        // input b to ALU
        case (ex_op2)
        2'b00: ex_alu_mux_2 = ex_pc_reg;
        2'b01: ex_alu_mux_2 = ex_s_reg;
        2'b10: ex_alu_mux_2 = ex_i_reg;
        2'b11: ex_alu_mux_2 = ex_rs2_reg;
        default: ex_alu_mux_2 = 32'bx;
        endcase
        
        // handles data forwarding to input a of ALU
        case (ex_fwd_rs1)
        2'b00: ex_rs1_reg = fd_rs1_reg;
        2'b01: ex_rs1_reg = mwb_u_reg;
        2'b10: ex_rs1_reg = mwb_aluout_reg;
        2'b11: ex_rs1_reg = mwb_data_mem_reader_out;
        endcase
        
        // handles data forwarding to input b of ALU
        case (ex_fwd_rs2)
        2'b00: ex_rs2_reg = fd_rs2_reg;
        2'b01: ex_rs2_reg = mwb_u_reg;
        2'b10: ex_rs2_reg = mwb_aluout_reg;
        2'b11: ex_rs2_reg = mwb_data_mem_reader_out;
        endcase
    end

    // On-chip UART
//    uart #(
//        .CLOCK_FREQ(CPU_CLOCK_FREQ)
//    ) on_chip_uart (
//        .clk(clk),
//        .reset(rst),
//        .data_in(),
//        .data_in_valid(),
//        .data_out_ready(),
//        .serial_in(FPGA_SERIAL_RX),

//        .data_in_ready(),
//        .data_out(),
//        .data_out_valid(),
//        .serial_out(FPGA_SERIAL_TX)
//    );
endmodule
