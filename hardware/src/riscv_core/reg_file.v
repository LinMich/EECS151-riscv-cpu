module reg_file (
    input clk,
    input we,
    input [4:0] ra1, ra2, wa,
    input [31:0] wd,
    output [31:0] rd1, rd2
);
	(* ram_style = "distributed" *) reg [31:0] register [31:0];

    assign rd1 = register[ra1];
    assign rd2 = register[ra2];

    integer i;

    always @(posedge clk) begin
    	if (reset) begin
    		for (i=0; i<32; i=i+1) begin
    			register[i] <= 32'd0;
    		end
    	end
    	else if (we) begin
    		if (wa != 0) begin
    			register[wa] <= wd;
    		end
    	end
    end

endmodule
