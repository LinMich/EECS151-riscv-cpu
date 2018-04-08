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
    reg [31:0] ex_rs1_after_fwd_reg;
    reg [31:0] ex_rs2_after_fwd_reg;
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

    wire [6:0] ex_opcode;
    assign ex_opcode = ex_inst_reg[6:0];

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
    

    
    
    //--------------------------------------------------------------
    
    // Memory-mapped IO UART
    reg [31:0] cycle_counter;
    reg [31:0] instr_counter;
    
    
    reg ex_reset_counters;
    reg ex_use_cycle_counter_reg_data;
    reg ex_use_instr_counter_reg_data;
    reg ex_UART_transmitter_write;
    reg ex_UART_control_read;
    reg ex_UART_receiver_data;
    wire ex_MemtoReg;
    assign ex_MemtoReg = ex_opcode == `OPC_LOAD;
    
    
    reg mwb_reset_counters;
    reg mwb_use_cycle_counter_reg_data;
    reg mwb_use_instr_counter_reg_data;
    reg mwb_UART_control_read;
    reg mwb_UART_receiver_data;
    reg mwb_MemtoReg;
    reg[31:0] mwb_regfile_input_data_mux_out;
    
    
    
    wire stall;
    assign stall = ex_take_or_inc;

    // UART 
    wire UART_data_out;
    wire UART_data_in_ready;
    wire UART_data_out_valid;
    


    always @ (posedge clk) begin
        if (rst || mwb_reset_counters) begin
            instr_counter <= 0;
        end else if (!stall) begin
            instr_counter <= instr_counter + 1;
        end

        if (rst || mwb_reset_counters) begin
            cycle_counter <= 0;
        end else begin
            cycle_counter <= cycle_counter + 1;
        end
    end 
    
    always @(*) begin
        ex_UART_transmitter_write = 1'b0;
        ex_reset_counters = 1'b0;
        
        ex_UART_control_read = 1'b0;
        ex_UART_receiver_data = 1'b0;
        ex_use_cycle_counter_reg_data = 1'b0;
        ex_use_instr_counter_reg_data = 1'b0;
        
        if (ex_opcode == `OPC_STORE) begin
            if (ex_aluout_reg == 32'h80000008) begin
                // UART transmitter data write
                ex_UART_transmitter_write = 1'b1;
            end       
            else if (ex_aluout_reg == 32'h80000018) begin
                ex_reset_counters = 1'b1;
            end
                
        end
        else if (ex_opcode == `OPC_LOAD) begin
            if (ex_aluout_reg == 32'h80000000) begin
                // UART control read
                ex_UART_control_read = 1'b1;
            end
            else if (ex_aluout_reg == 32'h80000004) begin
                // UART receiver data
                ex_UART_receiver_data = 1'b1;
            end
            else if (ex_aluout_reg == 32'h80000010) begin
                ex_use_cycle_counter_reg_data = 1'b1;
            end
            else if (ex_aluout_reg == 32'h80000014) begin
                ex_use_instr_counter_reg_data = 1'b1;
            end
        end
    end
    
    always @(*) begin
        if(mwb_MemtoReg) begin
            if (mwb_use_cycle_counter_reg_data) begin
                mwb_regfile_input_data_mux_out = cycle_counter;
            end
            else if (mwb_use_instr_counter_reg_data) begin
                mwb_regfile_input_data_mux_out = instr_counter;
            end
            else if (mwb_UART_control_read) begin
                mwb_regfile_input_data_mux_out = {30'd0, UART_data_out_valid, UART_data_in_ready};
            end
            else if (mwb_UART_receiver_data) begin
                mwb_regfile_input_data_mux_out = {24'd0, UART_data_out};
            end
            else begin
                mwb_regfile_input_data_mux_out = mwb_data_mem_reader_out;
            end
        end
        else begin
            // need something here?
        end
    end  
    
    
    // On-chip UART
    uart #(
        .CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) on_chip_uart (
        .clk(clk),
        .reset(rst),
        .data_in(), //NEEDS CONNECTING
        .data_in_valid(ex_UART_transmitter_write && !stall),
        .data_out_ready(mwb_UART_receiver_data && !stall),
        .serial_in(FPGA_SERIAL_RX),

        .data_in_ready(UART_data_in_ready),
        .data_out(UART_data_out),
        .data_out_valid(UART_data_out_valid),
        .serial_out(FPGA_SERIAL_TX)
    );
    
    
    //--------------------------------------------------------------
    
    
    



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
        .rs1(ex_rs1_after_fwd_reg),
        .rs2(ex_rs2_after_fwd_reg),
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
        .write_data(ex_rs1_after_fwd_reg),
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
            ex_rs1_after_fwd_reg <= 0;
            ex_rs2_after_fwd_reg <= 0;
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
            ex_rs1_reg <= fd_rs1_reg;
            ex_rs2_reg <= fd_rs2_reg;
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

            mwb_reset_counters <= ex_reset_counters;
            mwb_use_cycle_counter_reg_data <= ex_use_cycle_counter_reg_data;
            mwb_use_instr_counter_reg_data <= ex_use_instr_counter_reg_data;
            mwb_UART_control_read <= ex_UART_control_read;
            mwb_UART_receiver_data <= ex_UART_receiver_data;
            
            mwb_MemtoReg <= ex_MemtoReg;
        end
    end
    
    always @(*) begin
        // input to regfile writing.
        case (mwb_wbsel_reg)
        2'b00: mwb_regfile_input_data = ex_pc_reg;
        2'b01: mwb_regfile_input_data = mwb_aluout_reg;
        2'b10: mwb_regfile_input_data = mwb_regfile_input_data_mux_out;
        2'b11: mwb_regfile_input_data = mwb_u_reg;
        default: mwb_regfile_input_data = 32'bx;
        endcase
        
//        ex_rs1_after_fwd_reg = ex_rs1_reg;
//        ex_rs2_after_fwd_reg = ex_rs2_reg;
        
        // handles data forwarding to input a of ALU
        case (ex_fwd_rs1)
        2'b00: ex_rs1_after_fwd_reg = ex_rs1_reg;
        2'b01: ex_rs1_after_fwd_reg = mwb_u_reg;
        2'b10: ex_rs1_after_fwd_reg = mwb_aluout_reg;
        2'b11: ex_rs1_after_fwd_reg = mwb_data_mem_reader_out;
        endcase

        // handles data forwarding to input b of ALU
        case (ex_fwd_rs2)
        2'b00: ex_rs2_after_fwd_reg = ex_rs2_reg;
        2'b01: ex_rs2_after_fwd_reg = mwb_u_reg;
        2'b10: ex_rs2_after_fwd_reg = mwb_aluout_reg;
        2'b11: ex_rs2_after_fwd_reg = mwb_data_mem_reader_out;
        endcase

        
        // input a to ALU
        case (ex_op1)
        2'b00: ex_alu_mux_1 = ex_u_reg;
        2'b01: ex_alu_mux_1 = ex_rs1_after_fwd_reg;
        default: ex_alu_mux_1 = 32'bx;
        endcase
        
        // input b to ALU
        case (ex_op2)
        2'b00: ex_alu_mux_2 = ex_pc_reg;
        2'b01: ex_alu_mux_2 = ex_s_reg;
        2'b10: ex_alu_mux_2 = ex_i_reg;
        2'b11: ex_alu_mux_2 = ex_rs2_after_fwd_reg;
        default: ex_alu_mux_2 = 32'bx;
        endcase
    end

endmodule
