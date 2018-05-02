//////////////////////////////////////////////////////////////////////
////                                                              ////
////  Original File name: "tb_xge_mac.v"                           ////
////                                                              ////
////  This original file is part of the "10GE MAC" project          ////
////  http://www.opencores.org/cores/xge_mac/                     ////
////                                                              ////  Modified File name:testbench.sv
////  Author(s):                                                  ////
////      - Mrinal Mathur                  
//// Things  Remaining:
////1) Packet Id
////2) Clocking Block
////3) Make Script
////4) Funcitonal Coverage
////5) Complete TestPlan
/////////////////////////////////////////////////////////////////

`include "timescale.v"
`include "defines.v"
//`include "/home/sf100212/SV_Project/testcases/loopback/testcase1.sv"
//`include "/home/sf100212/SV_Project/testcases/missing_eop_packet/testcase2.sv"
//`include "/home/sf100212/SV_Project/testcases/missing_sop_packet/testcase3.sv"
//`include "/home/sf100212/SV_Project/testcases/undersize_packet/testcase4.sv"
//`include "/home/sf100212/SV_Project/testcases/zero_ipg_packet/testcase5.sv"
//`include "/home/sf100212/SV_Project/testcases/oversize_packet/testcase6.sv"

//`define GXB
//`define XIL

module tb;


reg           clk_156m25;
reg           clk_312m50;
reg           clk_xgmii_rx;
reg           clk_xgmii_tx;


// Interface //
  xge_interface xif (clk_156m25, clk_xgmii_rx, clk_xgmii_tx);  
  
//Testcase instantiation//
  testcase itestcase(
  clk_156m25,clk_xgmii_rx,clk_xgmii_tx, xif.testcase_port, xif.testcase_port
  );
  
  //Unit under test//  
xge_mac dut(/*AUTOINST*/
            // Outputs
  .pkt_rx_avail               (xif.pkt_rx_avail),
  .pkt_rx_data                (xif.pkt_rx_data[63:0]),
  .pkt_rx_eop                 (xif.pkt_rx_eop),
  .pkt_rx_err                 (xif.pkt_rx_err),
  .pkt_rx_mod                 (xif.pkt_rx_mod[2:0]),
  .pkt_rx_sop                 (xif.pkt_rx_sop),
  .pkt_rx_val                 (xif.pkt_rx_val),
  .pkt_tx_full                (xif.pkt_tx_full),
  .wb_ack_o                   (xif.wb_ack_o),
  .wb_dat_o                   (xif.wb_dat_o[31:0]),
  .wb_int_o                   (xif.wb_int_o),
  .xgmii_txc                  (xif.xgmii_txc[7:0]),
  .xgmii_txd                  (xif.xgmii_txd[63:0]),
            // Inputs
            .clk_156m25                 (clk_156m25),
            .clk_xgmii_rx               (clk_xgmii_rx),
            .clk_xgmii_tx               (clk_xgmii_tx),
  .pkt_rx_ren                 (xif.pkt_rx_ren),
  .pkt_tx_data                (xif.pkt_tx_data[63:0]),
  .pkt_tx_eop                 (xif.pkt_tx_eop),
  .pkt_tx_mod                 (xif.pkt_tx_mod[2:0]),
  .pkt_tx_sop                 (xif.pkt_tx_sop),
  .pkt_tx_val                 (xif.pkt_tx_val),
  .reset_156m25_n             (xif.reset_156m25_n),
  .reset_xgmii_rx_n           (xif.reset_xgmii_rx_n),
  .reset_xgmii_tx_n           (xif.reset_xgmii_tx_n),
  .wb_adr_i                   (xif.wb_adr_i[7:0]),
  .wb_clk_i                   (xif.wb_clk_i),
  .wb_cyc_i                   (xif.wb_cyc_i),
  .wb_dat_i                   (xif.wb_dat_i[31:0]),
  .wb_rst_i                   (xif.wb_rst_i),
  .wb_stb_i                   (xif.wb_stb_i),
  .wb_we_i                    (xif.wb_we_i),
  .xgmii_rxc                  (xif.xgmii_rxc[7:0]),
  .xgmii_rxd                  (xif.xgmii_rxd[63:0]));

`ifdef GXB
// Example of transceiver instance
gxb gxb(// Outputs
        .rx_ctrldetect                  ({xgmii_rxc[7],
                                          xgmii_rxc[5],
                                          xgmii_rxc[3],
                                          xgmii_rxc[1],
                                          xgmii_rxc[6],
                                          xgmii_rxc[4],
                                          xgmii_rxc[2],
                                          xgmii_rxc[0]}),
        .rx_dataout                     ({xgmii_rxd[63:56],
                                          xgmii_rxd[47:40],
                                          xgmii_rxd[31:24],
                                          xgmii_rxd[15:8],
                                          xgmii_rxd[55:48],
                                          xgmii_rxd[39:32],
                                          xgmii_rxd[23:16],
                                          xgmii_rxd[7:0]}),
        .tx_dataout                     (tx_dataout[3:0]),
        // Inputs
        .pll_inclk                      (clk_156m25),
        .rx_analogreset                 (~reset_156m25_n),
        .rx_cruclk                      ({clk_156m25, clk_156m25, clk_156m25, clk_156m25}),
        .rx_datain                      (tx_dataout[3:0]),
        .rx_digitalreset                (~reset_156m25_n),
        .tx_ctrlenable                  ({xgmii_txc[7],
                                          xgmii_txc[5],
                                          xgmii_txc[3],
                                          xgmii_txc[1],
                                          xgmii_txc[6],
                                          xgmii_txc[4],
                                          xgmii_txc[2],
                                          xgmii_txc[0]}),
        .tx_datain                      ({xgmii_txd[63:56],
                                          xgmii_txd[47:40],
                                          xgmii_txd[31:24],
                                          xgmii_txd[15:8],
                                          xgmii_txd[55:48],
                                          xgmii_txd[39:32],
                                          xgmii_txd[23:16],
                                          xgmii_txd[7:0]}),
        .tx_digitalreset                (~reset_156m25_n));
`endif

`ifdef XIL
// Example of transceiver instance
xaui_block xaui(// Outputs
                .txoutclk               (),
                .xgmii_rxd              (xgmii_rxd[63:0]),
                .xgmii_rxc              (xgmii_rxc[7:0]),
                .xaui_tx_l0_p           (xaui_tx_l0_p),
                .xaui_tx_l0_n           (xaui_tx_l0_n),
                .xaui_tx_l1_p           (xaui_tx_l1_p),
                .xaui_tx_l1_n           (xaui_tx_l1_n),
                .xaui_tx_l2_p           (xaui_tx_l2_p),
                .xaui_tx_l2_n           (xaui_tx_l2_n),
                .xaui_tx_l3_p           (xaui_tx_l3_p),
                .xaui_tx_l3_n           (xaui_tx_l3_n),
                .txlock                 (),
                .align_status           (),
                .sync_status            (),
                .mgt_tx_ready           (),
                .drp_o                  (),
                .drp_rdy                (),
                .status_vector          (),
                // Inputs
                .dclk                   (clk_156m25),
                .clk156                 (clk_156m25),
                .clk312                 (clk_312m50),
                .refclk                 (clk_156m25),
                .reset                  (~reset_156m25_n),
                .reset156               (~reset_156m25_n),
                .xgmii_txd              (xgmii_txd[63:0]),
                .xgmii_txc              (xgmii_txc[7:0]),
                .xaui_rx_l0_p           (xaui_tx_l0_p),
                .xaui_rx_l0_n           (xaui_tx_l0_n),
                .xaui_rx_l1_p           (xaui_tx_l1_p),
                .xaui_rx_l1_n           (xaui_tx_l1_n),
                .xaui_rx_l2_p           (xaui_tx_l2_p),
                .xaui_rx_l2_n           (xaui_tx_l2_n),
                .xaui_rx_l3_p           (xaui_tx_l3_p),
                .xaui_rx_l3_n           (xaui_tx_l3_n),
                .signal_detect          (4'b1111),
                .drp_addr               (7'b0),
                .drp_en                 (2'b0),
                .drp_i                  (16'b0),
                .drp_we                 (2'b0),
                .configuration_vector   (7'b0));

glbl glbl();
`endif

//-------------Clock generation-----------------//

initial begin
    clk_156m25 = 1'b0;
    clk_xgmii_rx = 1'b0;
    clk_xgmii_tx = 1'b0;
    forever begin
      xif.WaitPS(3200);
        clk_156m25 = ~clk_156m25;
        clk_xgmii_rx = ~clk_xgmii_rx;
        clk_xgmii_tx = ~clk_xgmii_tx;
    end
end
//-----------------------------------------------//  
  
  
//-------------Reset generation-----------------//  
initial begin
    xif.reset_156m25_n = 1'b0;
    xif.reset_xgmii_rx_n = 1'b0;
    xif.reset_xgmii_tx_n = 1'b0;
  xif.WaitNS(20);
    xif.reset_156m25_n = 1'b1;
    xif.reset_xgmii_rx_n = 1'b1;
    xif.reset_xgmii_tx_n = 1'b1;
end
//-----------------------------------------------//  

endmodule
