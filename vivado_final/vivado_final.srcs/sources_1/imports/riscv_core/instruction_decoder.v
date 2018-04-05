module instruction_decoder(
    input [31:0] instruction,
    
    output [31:0] j_sext,
    output [31:0] b_sext,
    output [31:0] s_sext,
    output [31:0] u_imm,
    output [31:0] i_sext,
    output [4:0] rs1,
    output [4:0] rs2,
    output [4:0] rd
);

    reg [31:0] j_pass;
    reg [31:0] b_pass;
    reg [31:0] s_pass;
    reg [31:0] u_pass;
    reg [31:0] i_pass;
    reg [4:0] rs1_pass;
    reg [4:0] rs2_pass;
    reg [4:0] rd_pass;
    
    initial begin
        j_pass = 0;
        b_pass = 0;
        s_pass = 0;
        u_pass = 0;
        i_pass = 0;
        rs1_pass = 0;
        rs2_pass = 0;
        rd_pass = 0;
    end
    
    assign j_sext = j_pass;
    assign b_sext = b_pass;
    assign s_sext = s_pass;
    assign u_imm = u_pass;
    assign i_sext = i_pass;
    assign rs1 = rs1_pass;
    assign rs2 = rs2_pass;
    assign rd = rd_pass;
    
    always @(*) begin
        j_pass = { {9{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0 };
        b_pass = { {19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
        s_pass = { {20{instruction[31]}}, instruction[31:25], instruction[11:7] };
        u_pass = instruction[31:12] << 12;
        i_pass = { {20{instruction[31]}}, instruction[31:20] };
        rs1_pass = instruction[19:15];
        rs2_pass = instruction[24:20];
        rd = instruction[11:7];
    end

endmodule
