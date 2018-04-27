// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (lin64) Build 2086221 Fri Dec 15 20:54:30 MST 2017
// Date        : Wed Apr 25 16:43:32 2018
// Host        : c125m-21.EECS.Berkeley.EDU running 64-bit CentOS release 6.9 (Final)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ block_mem_1x786432_stub.v
// Design      : block_mem_1x786432
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_1,Vivado 2017.4" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clka, wea, addra, dina, douta, clkb, web, addrb, dinb, 
  doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[19:0],dina[0:0],douta[0:0],clkb,web[0:0],addrb[19:0],dinb[0:0],doutb[0:0]" */;
  input clka;
  input [0:0]wea;
  input [19:0]addra;
  input [0:0]dina;
  output [0:0]douta;
  input clkb;
  input [0:0]web;
  input [19:0]addrb;
  input [0:0]dinb;
  output [0:0]doutb;
endmodule
