`include "Opcode.vh"

module ALU (
    input [31:0] ina,
    input [31:0] inb,
    
    input [2:0] fnc3,
    input fnc1,
    
    output [31:0] result
);

    reg [31:0] result_reg;
    assign result = result_reg;
    
    always @(*) begin
        case (fnc3)
        `FNC_ADD_SUB: begin
            if (fnc1 == `FNC2_ADD) result_reg = ina + inb;
            else result_reg = ina - inb; 
        end
        `FNC_SLL: result_reg = ina << inb[4:0];
        `FNC_SLT: begin
            if ($signed(ina) < $signed(inb)) result_reg = 1;
            else result_reg = 0;
        end
        `FNC_SLTU: begin
            if (ina < inb) result_reg = 1;
            else result_reg = 0;
        end
        `FNC_XOR: result_reg = ina ^ inb;
        `FNC_OR: result_reg = ina | inb;
        `FNC_AND: result_reg = ina & inb;
        `FNC_SRL_SRA: begin
            if (fnc1 == `FNC2_SRL) result_reg = ina >> inb[4:0];
            else result_reg = $signed(ina) >>> inb[4:0];
        end
        default: result_reg = 0;
        endcase
        
    end

endmodule