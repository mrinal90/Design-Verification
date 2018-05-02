//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Original File name: "tb_top.v"                           ////  
////  Modified File name:testbench.sv                              ////
////  This original file is part of the "SDRAM-CONTROLLER" project  ////
////  https://opencores.org/project,sdr_ctrl                    ////
////  Notes: 
////  1) SDRAM has debug mode =0 
////  Author(s):                                                  ////
////      - Mrinal Mathur                  
//// 
////
////
////
/////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
`include "mt48lc2m32b2.v"
//`include "IS42VM16400K.v"
//`include "mt48lc8m8a2.v"
`include "testcase1.sv"

module tb;

  parameter P_SYS  = 10;     //    200MHz
  parameter P_SDR  = 20;     //    100MHz

  // General
//  reg            RESETN;
  bit            sdram_clk;
  bit            sys_clk;
  bit 			 wb_clk_i;
  bit 			 wb_rst_i;
  bit 		     sdram_resetn;
  
  initial sys_clk <= 0;
  initial sdram_clk <= 0;
  initial sdram_resetn  <= 1'h1;
   
  // to fix the sdram interface timing issue
  wire #(2.0) sdram_clk_d   = sdram_clk;
  
  assign wb_clk_i = sys_clk;
  assign wb_rst_i = !sdram_resetn;
  
  always #(P_SYS/2) sys_clk = !sys_clk;
  always #(P_SDR/2) sdram_clk = !sdram_clk;
  
  initial begin
    #100
    // Applying reset
    sdram_resetn    <= 1'h0;
    #10000;
    // Releasing reset
    sdram_resetn    <= 1'h1;
  end
  

  //------------------SD RAM Controller Interface-------------// 
  
  sdramc_interface sif(sdram_clk, sys_clk, wb_clk_i, wb_rst_i, sdram_resetn);
  
  //------------------TESTCASE INSTANTIATION-------------// 
  testcase itestcase(sif.testcase_port, sif.testcase_port);
  
  //------------------SDRAM CONTROLLER WITH WISHBONE INSTANTIATION-------------// 
  sdrc_top #(.SDR_DW(32),.SDR_BW(4)) u_dut(
          .cfg_sdr_width      (sif.cfg_sdr_width   ) , 

/* WISH BONE */
    	  .cfg_colbits        (2'b00              ), // 8 Bit Column Address
    	  .wb_rst_i           (wb_rst_i            ),
    	  .wb_clk_i           (wb_clk_i            ),

          .wb_stb_i           (sif.wb_stb_i           ),
          .wb_ack_o           (sif.wb_ack_o           ),
          .wb_addr_i          (sif.wb_addr_i          ),
          .wb_we_i            (sif.wb_we_i            ),
          .wb_dat_i           (sif.wb_dat_i           ),
          .wb_sel_i           (sif.wb_sel_i           ),
          .wb_dat_o           (sif.wb_dat_o           ),
          .wb_cyc_i           (sif.wb_cyc_i           ),
          .wb_cti_i           (sif.wb_cti_i           ), 

/* Interface to SDRAMs */
    	  .sdram_clk          (sdram_clk              ),
    	  .sdram_resetn       (sdram_resetn           ),
          .sdr_cs_n           (sif.sdr_cs_n           ),
          .sdr_cke            (sif.sdr_cke            ),
          .sdr_ras_n          (sif.sdr_ras_n          ),
          .sdr_cas_n          (sif.sdr_cas_n          ),
          .sdr_we_n           (sif.sdr_we_n           ),
    	  .sdr_dqm            (sif.sdr_dqm            ),
          .sdr_ba             (sif.sdr_ba             ),
          .sdr_addr           (sif.sdr_addr           ), 
    	  .sdr_dq             (sif.sdr_dq             ),

    /* Parameters */
          .sdr_init_done      (sif.sdr_init_done      ),
          .cfg_req_depth      (sif.cfg_req_depth      ),	        //how many req. buffer should hold
    	  .cfg_sdr_en         (sif.cfg_sdr_en          ),
    	  .cfg_sdr_mode_reg   (sif.cfg_sdr_mode_reg    ),
    	  .cfg_sdr_tras_d     (sif.cfg_sdr_tras_d      ),
    	  .cfg_sdr_trp_d      (sif.cfg_sdr_trp_d       ),
    	  .cfg_sdr_trcd_d     (sif.cfg_sdr_trcd_d      ),
    	  .cfg_sdr_cas        (sif.cfg_sdr_cas         ),
    	  .cfg_sdr_trcar_d    (sif.cfg_sdr_trcar_d     ),
    	  .cfg_sdr_twr_d      (sif.cfg_sdr_twr_d       ),
    	  .cfg_sdr_rfsh       (sif.cfg_sdr_rfsh        ), // reduced from 12'hC35
    	  .cfg_sdr_rfmax      (sif.cfg_sdr_rfmax       )

  	);
  
  
  
  //------------------SDRAM INSTANTIATION-------------// 
  mt48lc2m32b2 #(.data_bits(32)) u_sdram32 (
    	  .Dq                 (sif.sdr_dq             ), 
          .Addr               (sif.sdr_addr[10:0]     ), 
          .Ba                 (sif.sdr_ba             ), 
    	  .Clk                (sdram_clk_d        ), 
          .Cke                (sif.sdr_cke            ), 
          .Cs_n               (sif.sdr_cs_n           ), 
          .Ras_n              (sif.sdr_ras_n          ), 
          .Cas_n              (sif.sdr_cas_n          ), 
          .We_n               (sif.sdr_we_n           ), 
          .Dqm                (sif.sdr_dqm            )
     );

  
endmodule