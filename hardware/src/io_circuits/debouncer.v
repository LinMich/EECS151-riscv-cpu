`include "util.vh"

module debouncer #(
    parameter width = 1,
    parameter sample_count_max = 25000,
    parameter pulse_count_max = 150,
    parameter wrapping_counter_width = `log2(sample_count_max),
    parameter saturating_counter_width = `log2(pulse_count_max))
(
    input clk,
    input [width-1:0] glitchy_signal,
    output [width-1:0] debounced_signal
);
    // Create your debouncer circuit here
    // This module takes in a vector of 1-bit synchronized, but possibly glitchy signals
    // and should output a vector of 1-bit signals that hold high when their respective counter saturates
    reg [wrapping_counter_width-1:0] sample_counter;
    reg pulse;
    
    initial begin
        sample_counter = 0;
        pulse = 0;
    end
    
    // sample pulse generator
    always @(posedge clk) begin
        if (sample_counter == sample_count_max) begin
            sample_counter <= 0;
            pulse <= 1;
        end else begin
            sample_counter <= sample_counter + 1;
            pulse <= 0;
        end
    end
    
    // saturating counter
    reg [saturating_counter_width-1:0] pulse_counter [width-1:0];
    //reg [width-1:0] output_passthrough;
    
    integer k;
    initial begin
        //output_passthrough = 0;
        for (k = 0; k < width; k = k + 1) begin
            pulse_counter[k] = 0;
        end
    end
    
    genvar i;
    generate
        for (i = 0; i < width; i = i + 1) begin:SATURATOR_LOOP
            always @(posedge clk) begin
                if (glitchy_signal[i] == 0)
                    pulse_counter[i] <= 0;
                else if (pulse && glitchy_signal[i] == 1 && pulse_counter[i] < pulse_count_max)
                    pulse_counter[i] <= pulse_counter[i] + 1;
                else pulse_counter[i] <= pulse_counter[i];
                //output_passthrough[i] <= (pulse_counter[i] == pulse_count_max);
            end
            
            assign debounced_signal[i] = (pulse_counter[i] == pulse_count_max);
        end
    endgenerate
    

    // Remove this line once you create your synchronizer
    //assign debounced_signal = output_passthrough;
endmodule
