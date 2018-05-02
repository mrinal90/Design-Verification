class configure_item extends uvm_sequence_item;

  rand int  wb_adr_i;
  rand bit  wb_clk_i;
  rand bit  wb_cyc_i;
  rand int  wb_dat_i;
  rand bit  wb_rst_i;
  rand bit  wb_stb_i;
  rand bit  wb_we_i;
  rand bit  pkt_rx_ren;
  rand int  pkt_tx_data;
  rand bit  pkt_tx_val;
  rand bit  pkt_tx_sop;
  rand bit  pkt_tx_eop;
  rand int  pkt_tx_mod;
  rand int  cycles;

  `uvm_object_utils_begin(configure_item)

    `uvm_field_int (wb_adr_i, UVM_ALL_ON)
    `uvm_field_int (wb_clk_i, UVM_ALL_ON)
    `uvm_field_int (wb_cyc_i, UVM_ALL_ON)
    `uvm_field_int (wb_dat_i, UVM_ALL_ON)
    `uvm_field_int (wb_rst_i, UVM_ALL_ON)
    `uvm_field_int (wb_stb_i, UVM_ALL_ON)
    `uvm_field_int (wb_we_i, UVM_ALL_ON)
    `uvm_field_int (pkt_rx_ren, UVM_ALL_ON)
    `uvm_field_int (pkt_tx_data, UVM_ALL_ON)
    `uvm_field_int (pkt_tx_val, UVM_ALL_ON)
    `uvm_field_int (pkt_tx_sop, UVM_ALL_ON)
    `uvm_field_int (pkt_tx_eop, UVM_ALL_ON)
    `uvm_field_int (pkt_tx_mod, UVM_ALL_ON)
    `uvm_field_int (cycles, UVM_ALL_ON)
  `uvm_object_utils_end

  function new (input string name ="Configure Item");
    super.new(name);
    `uvm_info("Configure_ITEM_CLASS_BASE", $sformatf("Hierarchy:%m"), UVM_HIGH)
  endfunction

endclass

