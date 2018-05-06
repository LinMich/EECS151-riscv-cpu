`include "util.vh"

/*
 *
 *  Implemenets the basic Bresenham line-drawing algorithm
 *  Note: x0 must be less than x1. Otherwise, nothing will be drawn.
 *
 *  Currently designed for single color
 *  To modify for multicolor, change the color components and how they are written.
 * 
 * https://www.tutorialspoint.com/computer_graphics/line_generation_algorithm.htm
 */

module accelerator #(
    parameter pixel_width = 1024,
    parameter pixel_height = 768,
    parameter pixel_width_bits = `log2(pixel_width),   //10-bit
    parameter pixel_height_bits = `log2(pixel_height), //10-bit

    parameter mem_width = 1,
    parameter mem_depth = 786432,
    parameter mem_addr_width = `log2(mem_depth)
)(
    input   clk,
    //no reset

    //Pixel data
    input [pixel_width_bits - 1 : 0] x0,
    input [pixel_height_bits - 1 : 0] y0,
    input [pixel_width_bits - 1 : 0] x1,
    input [pixel_height_bits - 1 : 0] y1,
    input color,

    //CPU interface
    output RX_ready,
    input  RX_valid,    //fire signal

    //Arbiter Interface
    output   XL_wr_en,
    output   [mem_width-1:0] XL_wr_data,
    output   [mem_addr_width-1:0] XL_wr_addr
);

    reg [pixel_width_bits - 1 : 0] x_curr; // x_curr
    reg [pixel_height_bits - 1 : 0] y_curr; // y_curr
    reg [pixel_width_bits - 1 : 0] x_target;
    reg [pixel_height_bits - 1 : 0] y_target;

//     reg [pixel_width_bits : 0] pk_step_L = 0;
//     reg [pixel_height_bits : 0] pk_step_U = 0;

    reg [pixel_width_bits : 0] dx = 0;
    reg [pixel_width_bits : 0] dy = 0;
    reg [pixel_width_bits : 0] error = 0;
    reg y_step = 0;
    reg steep = 0;
//    reg [pixel_width_bits : 0] dy = 0;
//    reg [pixel_width_bits : 0] err = 0;
//    reg [pixel_width_bits : 0] e2 = 0;
//    reg down;
//    reg right;

    reg color_reg;
    reg TX_running;

     wire complete = (x_curr == x_target && y_curr == y_target);

    assign RX_ready = ~TX_running;

    assign XL_wr_en = TX_running;
    assign XL_wr_data = color_reg;
    assign XL_wr_addr = (steep == 1) ? {x_curr, y_curr} : {y_curr, x_curr};

    //2-phase operation
    //Phase 1: determine pixel
    //Phase 2: write pixel
    //On a clock edge, pixel K is written to the memory, and pixel K+1 is calculated and registered
    always @(posedge clk) begin
        if (TX_running) begin
//            if (complete) begin
//                TX_running <= 1'b0;
//            end else if (x_curr == x_target && px < 0) begin    //I don't think this can happen but...
//                TX_running <= 1'b0;
//            end else begin //set up phase 2
//                if (px < 0) begin
//                    px <= px + pk_step_L;
//                    x_curr <= x_curr + 1;
//                    y_curr <= y_curr;
//                end else begin
//                    px <= px + pk_step_U;
//                    x_curr <= x_curr;
//                    y_curr <= y_curr + 1;
//                end
//            end
            //end state
//            if (x == x1 && y == y1) TX_running <= 1'b0;
//            else begin
//                e2 = err << 1;
//                if (e2 > dy) begin
//                  err = err + dy;
//                  if (right) x = x + 1;
//                  else x = x - 1;
//                end
//                if (e2 < dx) begin
//                  err = err + dx;
//                  if (down) y = y + 1;
//                  else y = y - 1;
//                end
//            end
            if (x_curr >= x_target) TX_running <= 1'b0;
            else begin
                if (error < dy) begin
                    y_curr <= (y_step) ? y_curr + 1 : y_curr - 1;
                    error <= (error - dy) + dx;
                end else begin
                    error <= error - dy;
                end
                
                x_curr <= x_curr + 1;
            end
        end else if (RX_valid) begin
            TX_running <= 1'b1;
            
            if (((`max(y0,y1) - `min(y0,y1)) > (`max(x0,x1) - `min(x0,x1)) && (x0 > x1))) begin
                x_curr <= y1;
                y_curr <= x1;
                x_target <= y0;
                y_target <= x0;
                dx <= y0 - y1;
                dy <= (`max(x0,x1) - `min(x0,x1));
                error <= (y0 - y1) >> 1;
                y_step <= (x1 < x0) ? 1 : 0;
                steep <= 1;
            end else if ((`max(y0,y1) - `min(y0,y1)) > (`max(x0,x1) - `min(x0,x1))) begin // steep
                x_curr <= y0;
                y_curr <= x0;
                x_target <= y1;
                y_target <= x1;
                dx <= y1 - y0;
                dy <= (`max(x0,x1) - `min(x0,x1));
                error <= (y1 - y0) >> 1;
                y_step <= (x0 < x1) ? 1 : 0;
                steep <= 1;
            end else if (x0 > x1) begin
                x_curr <= x1;
                y_curr <= y1;
                x_target <= x0;
                y_target <= y0;
                dx <= x0 - x1;
                dy <= (`max(y0,y1) - `min(y0,y1));
                error <= (x0 - x1) >> 1;
                y_step <= (y0 < y1) ? 1 : 0;
                steep <= 0;
            end else begin
                x_curr <= x0;
                y_curr <= y0;
                x_target <= x1;
                y_target <= y1;
                dx <= x1 - x0;
                dy <= (`max(y0,y1) - `min(y0,y1));
                error <= (x1 - x0) >> 1;
                y_step <= (y0 < y1) ? 1 : 0;
                steep <= 0;
            end

//            dx = x1 - x0;
//            right = dx >= 0;
//            if (~right) dx = -dx;

//            dy = y1 - y0;
//            down = dy >= 0;
//            if (down) dy = -dy;

//            err = dx + dy;
//            x <= x0;
//            y <= y0;

//            x_curr <= x0;
//            y_curr <= y0;
            
//            x_target <= x1;
//            y_target <= y1;
            
//            pk_step_L <= (2 * (y1 - y0));
            
//            pk_step_U <= (2 * (y1 - y0)) - (2 * (x1 - x0));
            
//            px <= (2 * (y1 - y0)) - (x1 - x0); //initial

            color_reg <= color;
        end else begin
            TX_running <= 1'b0;
        end
    end
endmodule
