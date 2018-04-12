`include "util.vh"

module uart_transmitter #(
    parameter CLOCK_FREQ = 33_000_000,
    parameter BAUD_RATE = 115_200)
(
    input clk,
    input reset,

    input [7:0] data_in,
    input data_in_valid,
    output data_in_ready,

    output serial_out
);

    localparam  SYMBOL_EDGE_TIME    =   CLOCK_FREQ / BAUD_RATE;
    localparam  CLOCK_COUNTER_WIDTH =   `log2(SYMBOL_EDGE_TIME);
    localparam  IDLE = 0;
    localparam  START = 1;
    localparam  STOP = 10;

    reg [9:0] to_send;
    reg [CLOCK_COUNTER_WIDTH:0] clock_ctr;
    reg [3:0] state;

    assign data_in_ready = state == IDLE;
    assign serial_out = state == IDLE ? 1 : to_send[state-1];

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end
        else if (state == IDLE && (data_in_valid && data_in_ready)) begin
            state <= START;
        end
        else if (state != IDLE) begin
            state <= clock_ctr == SYMBOL_EDGE_TIME ? (state == STOP ? IDLE : state+1) : state;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            to_send <= 0;
        end
        else if (data_in_valid && data_in_ready) begin
            to_send <= {1'b1, data_in, 1'b0};
        end
    end

    always @(posedge clk) begin
        if (reset || (data_in_valid && data_in_ready) || (clock_ctr == SYMBOL_EDGE_TIME)) begin
            clock_ctr <= 0;
        end
        else begin
            clock_ctr <= clock_ctr + 1;
        end
    end

endmodule
