module synchronizer #(parameter width = 1) (
    input [width-1:0] async_signal,
    input clk,
    output [width-1:0] sync_signal
);
    // Create your 2 flip-flop synchronizer here
    // This module takes in a vector of 1-bit asynchronous (from different clock domain or not clocked) signals
    reg [width-1:0] middle;
    reg [width-1:0] ender;
    
    initial begin
        middle = 0;
        ender = 0;
    end
    
    always @(posedge clk) begin
        middle <= async_signal;
        ender <= middle;
    end
    
    // and should output a vector of 1-bit synchronous signals that are synchronized to the input clk
    assign sync_signal = ender;
endmodule
