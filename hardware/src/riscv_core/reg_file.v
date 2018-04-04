module reg_file (
    input clk,
    input we,
    input [4:0] ra1, ra2, wa,
    input [31:0] wd,
    output [31:0] rd1, rd2
);
	(* ram_style = "distributed" *) reg [31:0] register [31:0];

    assign rd1 = (ra1 == 0) ? 32'b0 : register[ra1];
    assign rd2 = (ra2 == 0) ? 32'b0 : register[ra2];
    
    initial begin : init
        integer i;
        for(i = 0; i < 32; i = i + 1)
            register[i] = 0;
    end
    always @(posedge clk) begin
    	if (we && (wa != 5'b0)) begin
            register[wa] <= wd;
    	end
    end

endmodule
