`include "Opcode.vh"

module ALU (
    input [31:0] ina,
    input [31:0] inb,
    
    input [2:0] fnc3,
    input fnc1,
    
    output [1:0] cmp,
    output [31:0] result
);

    always @(*) begin
        case(fnc3):
        FNC_ADD_SUB: begin
            if (fnc1 == FNC2_ADD) result = ina + inb;
            else result = ina - inb; 
        end
        FNC_SLL: result = ina << inb[4:0];
        FNC_SLT: begin
            if ($signed(ina) < $signed(inb)) result = 1;
            else result = 0;
        end
        FNC_SLTU: begin
            if (ina < inb) result = 1;
            else result = 0;
        end
        FNC_XOR: result = ina ^ inb;
        FNC_OR: result = ina | inb;
        FNC_AND: result = ina & inb;
        FNC_SRL_SRA: begin
            if (fnc1 == FNC2_SRL) result = ina >> inb[4:0];
            else result = ina >>> inb[4:0];
        end
        default: result = 0;
        endcase
        
        // handle comparison
        if (ina < inb) cmp = 2'b00;
        else if (ina == inb) cmp = 2'b01;
        else cmp = 2'b10;
    end

endmodule