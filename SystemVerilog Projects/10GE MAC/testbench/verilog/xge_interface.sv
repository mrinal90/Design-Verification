`include "timescale.v"

interface xge_interface (input clk_156m25, input clk_xgmii_rx, input clk_xgmii_tx);
  
  
    reg                  pkt_rx_ren;            // To rx_dq0 of rx_dequeue.v
    reg [63:0]          pkt_tx_data;            // To tx_eq0 of tx_enqueue.,
       reg                 pkt_tx_eop;             // To tx_eq0 of tx_enqueue.v
    reg [2:0]           pkt_tx_mod;             // To tx_eq0 of tx_enqueue.v
      reg                  pkt_tx_sop;             // To tx_eq0 of tx_enqueue.v
      reg                  pkt_tx_val;             // To tx_eq0 of tx_enqueue.v
      reg                reset_156m25_n;         // To rx_dq0 of rx_dequeue.v, ...
      reg                  reset_xgmii_rx_n;       // To rx_eq0 of rx_enqueue.v, ...
      reg                 reset_xgmii_tx_n;       // To tx_dq0 of tx_dequeue.v, ...
    reg [7:0]           wb_adr_i;               // To wishbone_if0 of wishbone_if.v
       reg                 wb_clk_i;               // To sync_clk_wb0 of sync_clk_wb.v, ...
       reg                 wb_cyc_i;               // To wishbone_if0 of wishbone_if.v
     reg [31:0]          wb_dat_i;               // To wishbone_if0 of wishbone_if.v
       reg                 wb_rst_i;               // To sync_clk_wb0 of sync_clk_wb.v, ...
       reg                 wb_stb_i;               // To wishbone_if0 of wishbone_if.v
       reg                 wb_we_i;                // To wishbone_if0 of wishbone_if.v
     reg  [7:0]         xgmii_rxc;              // To rx_eq0 of rx_enqueue.v
     reg [63:0]         xgmii_rxd;              // To rx_eq0 of rx_enqueue.v
    // End of automatics

    /*AUTOOUTPUT*/
    // Beginning of automatic outputs (from unused autoinst outputs)
       wire                pkt_rx_avail;           // From rx_dq0 of rx_dequeue.v
     wire [63:0]          pkt_rx_data;            // From rx_dq0 of rx_dequeue.v
      wire                 pkt_rx_eop;             // From rx_dq0 of rx_dequeue.v
      wire                pkt_rx_err;             // From rx_dq0 of rx_dequeue.v
    wire [2:0]            pkt_rx_mod;             // From rx_dq0 of rx_dequeue.v
       wire                pkt_rx_sop;             // From rx_dq0 of rx_dequeue.v
       wire                pkt_rx_val;             // From rx_dq0 of rx_dequeue.v
       wire                pkt_tx_full;            // From tx_eq0 of tx_enqueue.v
       wire                wb_ack_o;               // From wishbone_if0 of wishbone_if.v
     wire [31:0]         wb_dat_o;               // From wishbone_if0 of wishbone_if.v
        wire               wb_int_o;               // From wishbone_if0 of wishbone_if.v
       wire [7:0]        xgmii_txc;              // From tx_dq0 of tx_dequeue.v
     wire [63:0]          xgmii_txd;              // From tx_dq0 of tx_dequeue.v
    // End of automatics
  //////////////
   
reg [7:0]     tx_buffer[0:10000];
integer       tx_length;
integer       tx_count;
integer       rx_count;
  
  
//----------------------Tasks to add delay--------------------//

task WaitNS;
  input [31:0] delay;
    begin
        #(1000*delay);
    end
endtask

task WaitPS;
  input [31:0] delay;
    begin
        #(delay);
    end
endtask
//---------------------------------------------------------// 
  
  
//---------------------Task to initialize variables----------------------------// 
task init();  
  // Unused for this testbench

    assign wb_adr_i = 8'b0;
    assign wb_clk_i = 1'b0;
    assign wb_cyc_i = 1'b0;
    assign wb_dat_i = 32'b0;
    assign wb_rst_i = 1'b1;
    assign wb_stb_i = 1'b0;
    assign wb_we_i = 1'b0;
    
    tx_count = 0;
    rx_count = 0;

  
//----------------------XGMII Loopback Mode----------------------------------//
// This test is done with loopback on XGMII or using one of the tranceiver examples

    assign xgmii_rxc = xgmii_txc;
    assign xgmii_rxd = xgmii_txd;


    for (tx_length = 0; tx_length <= 1000; tx_length = tx_length + 1) begin
        tx_buffer[tx_length] = 0;
    end

    pkt_rx_ren = 1'b0;

    pkt_tx_data = 64'b0;
    pkt_tx_val = 1'b0;
    pkt_tx_sop = 1'b0;
    pkt_tx_eop = 1'b0;
    pkt_tx_mod = 3'b0;


endtask
//---------------------------------------------------------------------------//   


  
//------------------Default Clocking block for Pkt transfer-------------// 
  default clocking cb @(posedge clk_156m25);
    
    output  #1               xgmii_rxd, xgmii_rxc, wb_we_i, wb_stb_i, wb_rst_i, wb_dat_i,wb_cyc_i, wb_clk_i, wb_adr_i, reset_xgmii_tx_n, reset_xgmii_rx_n, reset_156m25_n, pkt_tx_val, pkt_tx_sop, pkt_tx_mod, pkt_tx_eop, pkt_tx_data, pkt_rx_ren;             
    input   #1				xgmii_txd, xgmii_txc, wb_int_o, wb_dat_o, wb_ack_o, pkt_tx_full,
  pkt_rx_val, pkt_rx_sop, pkt_rx_mod, pkt_rx_err, pkt_rx_eop,
  pkt_rx_data, pkt_rx_avail;	
    
  endclocking
//---------------------------------------------------------//   
  
//------------------Modport for Testcase-------------//
  modport testcase_port (clocking cb);
  
endinterface
