`include "util.vh"

/* ---------------
 * EECS151 FPGA Lab Spring 2018
 * Video Controller
 *
 * This module generates the pixel data and horizontal/vertical sync pulses
 * for a digital video signal, based on data for each pixel in the
 * framebuffer. The intended sink for our outputs is a DVI/HDMI controller,
 * whose task it is to buffer our output signals, implement TMDS, and encode
 * data as appropriate for the wire.
 *
 * To get parameter configurations for various resolutions, refer to this
 * website: tinyvga.com/vga-timing
 *
 * Parameters for XGA 1024x768 @ 60 Hz refresh rate
 *     Pixel Clock: 65.0 Mhz
 *     Horizontal Timing: (Whole line = 1344 pixels)
 *         Visible area: 1024 pixels
 *         Front porch: 24 pixels
 *         Sync pulse: 136 pixels
 *         Back porch: 160 pixels
 *     Vertical Timing: (Whole frame = 806 lines)
 *         Visible area: 768 lines
 *         Front porch: 3 lines
 *         Sync pulse: 6 lines
 *         Back porch: 29 lines
 * ---------------
*/

module video_controller # (
  parameter H_FRONT_PORCH = 24,
  parameter H_SYNC_PULSE = 136,
  parameter H_BACK_PORCH = 160,
  parameter H_VISIBLE_AREA = 1024,
  parameter H_WHOLE_LINE =
      H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH + H_VISIBLE_AREA,

  parameter V_FRONT_PORCH = 3,
  parameter V_SYNC_PULSE = 6,
  parameter V_BACK_PORCH = 29,
  parameter V_VISIBLE_AREA = 768,
  parameter V_WHOLE_FRAME =
      V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH + V_VISIBLE_AREA,
 
  parameter RAM_WIDTH = 24,
  parameter RAM_DEPTH = 786432,     // This is 1024 * 768. Coincidence?
  parameter RAM_ADDR_BITS = 32
)(
  // This is the pixel clock @ 65 Mhz for 1024 x 768 resolution.
  input                           clk,
  // This is a reset synchronized to the pixel clock.
  input                           rst,

  // Framebuffer interface.
  output wire [RAM_ADDR_BITS-1:0] framebuffer_addr,
  input  wire                     framebuffer_addr_rdy,
  output reg                      framebuffer_addr_valid,

  input  wire [RAM_WIDTH-1:0]     framebuffer_data,
  input  wire                     framebuffer_data_valid,
  output reg                      framebuffer_data_rdy,

  output [RAM_WIDTH-1:0]          hdmi_data,  // RGB data output.
  output                          hdmi_de,    // High when video data is active.
  output                          hdmi_h,     // Horizontal sync
  output                          hdmi_v      // Vertical sync
);
  //// YOUR DVI CONTROLLER GOES HERE
  //
  reg [RAM_ADDR_BITS-1:0] framebuffer_addr_reg;
  reg [23:0] hdmi_data_reg;
  reg hdmi_de_reg;
  reg hdmi_h_reg;
  reg hdmi_v_reg;
  
  reg [`log2(V_WHOLE_FRAME):0] v_counter;
  reg [`log2(H_WHOLE_LINE):0] h_counter;
  
  // You can assign hdmi_de, hdmi_v, hdmi_h, framebuffer_addr.
  assign framebuffer_addr = framebuffer_addr_reg;
  assign hdmi_data = hdmi_data_reg;
  assign hdmi_de = hdmi_de_reg;
  assign hdmi_h = hdmi_h_reg;
  assign hdmi_v = hdmi_v_reg;
  
  //
  // You can change the listed signals above to be regs or wires if needed.
  //
  // You CAN ONLY use the 'clk' input to drive synchronous logic.
  always @(posedge clk) begin
    if (rst) begin
        v_counter <= -1;
        h_counter <= -1;
        framebuffer_addr_reg <= 32'h90000000;
        hdmi_v_reg <= 1;
        hdmi_h_reg <= 1;
        hdmi_de_reg <= 0;
        hdmi_data_reg <= 0;
    end else begin
    
        // incrementing logic
        if (h_counter >= H_WHOLE_LINE - 1) begin
            if (v_counter >= V_WHOLE_FRAME - 1) begin
                v_counter = 0;
                h_counter = 0;
                framebuffer_addr_reg = 32'h90000000;
            end else begin
                v_counter = v_counter + 1;
                h_counter = 0;
            end
        end else h_counter = h_counter + 1;
        
        if ($signed(v_counter) < V_SYNC_PULSE) hdmi_v_reg <= 0;
        else if (v_counter < V_SYNC_PULSE + V_BACK_PORCH) begin
            hdmi_v_reg <= 1;
            hdmi_data_reg <= 0;
            hdmi_de_reg <= 0;
            hdmi_h_reg <= 1;
//            framebuffer_addr_reg <= 32'h90000000;
        end else if (v_counter < V_SYNC_PULSE + V_BACK_PORCH + V_VISIBLE_AREA) begin // horizontal part
            if (h_counter < H_SYNC_PULSE) hdmi_h_reg <= 0;
            else if (h_counter < H_SYNC_PULSE + H_BACK_PORCH) begin
                hdmi_v_reg <= 1;
                hdmi_data_reg <= 0;
                hdmi_de_reg <= 0;
                hdmi_h_reg <= 1;
//                framebuffer_addr_reg <= 32'h90000000;
            end else if (h_counter < H_SYNC_PULSE + H_BACK_PORCH + H_VISIBLE_AREA) begin // actual data part
                hdmi_de_reg <= 1;
                framebuffer_addr_reg <= (32'h90000000 + ((v_counter - (V_SYNC_PULSE + V_BACK_PORCH)) << 10) + ((h_counter + 1) - (H_SYNC_PULSE + H_BACK_PORCH))); // addr calc according to spec
//                hdmi_data_reg <= 24'hffffff;
                hdmi_data_reg <= framebuffer_data;
            end else if (h_counter < H_SYNC_PULSE + H_BACK_PORCH + H_VISIBLE_AREA + H_FRONT_PORCH) begin
                hdmi_h_reg <= 1;
                hdmi_de_reg <= 0;
                hdmi_v_reg <= 1;
                hdmi_data_reg <= 0;
//                framebuffer_addr_reg <= 32'h90000000;
            end
        end else if (v_counter < V_SYNC_PULSE + V_BACK_PORCH + V_VISIBLE_AREA + V_FRONT_PORCH) begin
            hdmi_v_reg <= 1;
            hdmi_data_reg <= 0;
            hdmi_de_reg <= 0;
            hdmi_h_reg <= 1;
//            framebuffer_addr_reg <= 32'h90000000;
        end
    end
  end
  
  
endmodule

