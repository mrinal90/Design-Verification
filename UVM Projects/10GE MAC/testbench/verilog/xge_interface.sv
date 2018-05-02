interface xge_interface(input bit clk_156m25, input bit clk_xgmii_rx, input bit clk_xgmii_tx, ref logic reset_156m25_n, ref logic reset_xgmii_rx_n, ref logic reset_xgmii_tx_n);
  
    logic                  pkt_rx_ren;            // To rx_dq0 of rx_dequeue.v
    logic [63:0]          pkt_tx_data;            // To tx_eq0 of tx_enqueue.,
    logic                 pkt_tx_eop;             // To tx_eq0 of tx_enqueue.v
    logic [2:0]           pkt_tx_mod;             // To tx_eq0 of tx_enqueue.v
    logic                  pkt_tx_sop;             // To tx_eq0 of tx_enqueue.v
    logic                  pkt_tx_val;             // To tx_eq0 of tx_enqueue.v
    logic [7:0]           wb_adr_i;
    logic                 wb_clk_i;
    logic                 wb_cyc_i;               // To wishbone_if0 of wishbone_if.v
    logic [31:0]          wb_dat_i;               // To wishbone_if0 of wishbone_if.v
    logic                 wb_rst_i;               // To sync_clk_wb0 of sync_clk_wb.v, ...
    logic                 wb_stb_i;               // To wishbone_if0 of wishbone_if.v
    logic                 wb_we_i;                // To wishbone_if0 of wishbone_if.v
    logic  [7:0]         xgmii_rxc;              // To rx_eq0 of rx_enqueue.v
    logic [63:0]         xgmii_rxd;              // To rx_eq0 of rx_enqueue.v
    // End of automatics

    /*AUTOOUTPUT*/
    // Beginning of automatic outputs (from unused autoinst outputs)
    logic                pkt_rx_avail;           // From rx_dq0 of rx_dequeue.v
    logic [63:0]          pkt_rx_data;            // From rx_dq0 of rx_dequeue.v
    logic                 pkt_rx_eop;             // From rx_dq0 of rx_dequeue.v
    logic                pkt_rx_err;             // From rx_dq0 of rx_dequeue.v
    logic [2:0]            pkt_rx_mod;             // From rx_dq0 of rx_dequeue.v
    logic                pkt_rx_sop;             // From rx_dq0 of rx_dequeue.v
    logic                pkt_rx_val;             // From rx_dq0 of rx_dequeue.v
    logic                pkt_tx_full;            // From tx_eq0 of tx_enqueue.v
    logic                wb_ack_o;               // From wishbone_if0 of wishbone_if.v
    logic [31:0]         wb_dat_o;               // From wishbone_if0 of wishbone_if.v
    logic               wb_int_o;               // From wishbone_if0 of wishbone_if.v
    logic [7:0]        xgmii_txc;              // From tx_dq0 of tx_dequeue.v
    logic [63:0]          xgmii_txd;              // From tx_dq0 of tx_dequeue.v


//------------------Default Clocking block for Pkt transfer-------------//
  default clocking cb @(posedge clk_156m25);

    output  #1               xgmii_rxd, xgmii_rxc, wb_we_i, wb_stb_i, wb_rst_i, wb_dat_i,wb_cyc_i, wb_clk_i, wb_adr_i, reset_xgmii_tx_n, reset_xgmii_rx_n, reset_156m25_n,pkt_rx_ren;
    output  #1               pkt_tx_val, pkt_tx_sop, pkt_tx_mod, pkt_tx_eop, pkt_tx_data;
    input   #1               xgmii_txd, xgmii_txc, wb_int_o, wb_dat_o, wb_ack_o, pkt_tx_full,
  pkt_rx_val, pkt_rx_sop, pkt_rx_mod, pkt_rx_err, pkt_rx_eop,
  pkt_rx_data, pkt_rx_avail;

  endclocking
//---------------------------------------------------------//



//------------------Modport for Testcase-------------//
  modport testcase_port (clocking cb);


endinterface
