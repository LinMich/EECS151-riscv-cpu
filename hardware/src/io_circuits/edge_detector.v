module edge_detector #(
    parameter width = 1
)(
    input clk,
    input [width-1:0] signal_in,
    output [width-1:0] edge_detect_pulse
);

    // This module takes a vector of 1-bit signals as input and outputs a vector of 1-bit signals. For each input signal
    // this module will look for a low to high (0->1) logic transition, and should then output a 1 clock cycle wide pulse
    // for that signal.
    // Remove this line once you have implemented this module.
    reg [width-1:0] output_passer;
    reg [width-1:0] old_signals;
    
    initial begin
        output_passer = 0;
        old_signals = 0;
    end
    
    genvar i;
    generate
        for (i = 0; i < width; i = i + 1) begin:EDGE_DETECTORS
            always @(posedge clk) begin
                if (output_passer[i] == 1) output_passer[i] <= 0;
                else if (signal_in[i] == 1 && old_signals[i] == 0) output_passer[i] <= 1;
                else output_passer[i] <= 0;
                
                old_signals[i] <= signal_in[i];
            end
            
            assign edge_detect_pulse[i] = output_passer[i];
        end
    endgenerate
endmodule
