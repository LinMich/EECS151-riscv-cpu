module Riscv151 #(
    parameter CPU_CLOCK_FREQ = 50_000_000
)(
    input clk,
    input rst,

    // Ports for UART that go off-chip to UART level shifter
    input FPGA_SERIAL_RX,
    output FPGA_SERIAL_TX
);

    // Instantiate your memories here
    // You should tie the ena, enb inputs of your memories to 1'b1
    // They are just like power switches for your block RAMs

    // Construct your datapath, add as many modules as you want

    // On-chip UART
    uart #(
        .CLOCK_FREQ(CPU_CLOCK_FREQ)
    ) on_chip_uart (
        .clk(clk),
        .reset(rst),
        .data_in(),
        .data_in_valid(),
        .data_out_ready(),
        .serial_in(FPGA_SERIAL_RX),

        .data_in_ready(),
        .data_out(),
        .data_out_valid(),
        .serial_out(FPGA_SERIAL_TX)
    );
endmodule
