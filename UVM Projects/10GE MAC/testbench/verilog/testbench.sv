////////////////////////////////////////////////////////////////////////////////////////////
////                                                              			////
////  Original File name: "tb_xge_mac.v"                          			////
////  Modified File name: "testbench.sv"                          			////
////  This original file is part of the "10GE MAC" project        			////
////  http://www.opencores.org/cores/xge_mac/                     			////
////                                                              			////  
////  Author(s):                                                  		      	////
////      - Mrinal Mathur                                         		      	////
//// Things  Remaining:                                           		      	////
////1) Scoreboard: Completed. Input Monitor issue                                       ////
////2) Input Monitor: Completed. Issue was packet creation. not FIFO                    ////
////3) Reset Agent: Completed. Waveform got properly reset. Bcz of diff phases.         ////
////4) Virtual Sequence:Completed.                                     		      	////
////5) Configure Sequence: Completed.                                          		////
////6) Wishbone                     		      	                                ////
////7) IPG Monitor                                                                      ////                                        		      	
////8) Complete TestPlan                                                                ////
////9) Testcases:                                                                       ////
////////////////////////////////////////////////////////////////////////////////////////////
module tb();
   bit           clk_156m25;
   bit           clk_312m50;
   bit           clk_xgmii_rx;
   bit           clk_xgmii_tx;
   
   logic          reset_156m25_n;
   logic          reset_xgmii_rx_n;
   logic          reset_xgmii_tx_n;

// Interface //
  xge_interface xif (clk_156m25, clk_xgmii_rx, clk_xgmii_tx, reset_156m25_n, reset_xgmii_rx_n, reset_xgmii_tx_n);

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

  //-------------Clock generation-----------------//

initial begin
    clk_156m25 = 1'b0;
    clk_xgmii_rx = 1'b0;
    clk_xgmii_tx = 1'b0;
    forever begin
        #3200;
        clk_156m25 = ~clk_156m25;
        clk_xgmii_rx = ~clk_xgmii_rx;
        clk_xgmii_tx = ~clk_xgmii_tx;
    end
end
//-----------------------------------------------//


//----------------------LOOPBACK MODE-------------------------//
initial begin
   assign xif.xgmii_rxc = xif.xgmii_txc;
   assign xif.xgmii_rxd = xif.xgmii_txd;
end


//--------------Waveform Dump---------------------------------//
initial begin
   $vcdpluson();
end



endmodule
