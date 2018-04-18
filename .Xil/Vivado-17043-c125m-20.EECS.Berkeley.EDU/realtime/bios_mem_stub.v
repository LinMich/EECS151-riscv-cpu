// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module bios_mem(clka, ena, addra, douta, clkb, enb, addrb, doutb);
  input clka;
  input ena;
  input [11:0]addra;
  output [31:0]douta;
  input clkb;
  input enb;
  input [11:0]addrb;
  output [31:0]doutb;
endmodule
