`ifndef CONFIGURE_SEQUENCE_SV
`define CONFIGURE_SEQUENCE_SV

`include "../../testbench/verilog/configure_item.sv"

class configure_sequence extends uvm_sequence #(configure_item);
  `uvm_object_utils(configure_sequence);
  
  function new(input string name="configure_sequence");
    super.new(name);
    `uvm_info("CONFIGURE_CLASS", $sformatf("Hierarchy:%m"), UVM_HIGH)
  endfunction  
 
 virtual task pre_body();
   if(starting_phase != null) begin
    starting_phase.raise_objection(this);
   end
 endtask 

  virtual task body();

     `uvm_do_with(req,
           {wb_adr_i == 8'b0;
            wb_adr_i == 8'b0;
    	    wb_clk_i == 1'b0;
            wb_cyc_i == 1'b0;
            wb_dat_i == 32'b0;
            wb_rst_i == 1'b1;
            wb_stb_i == 1'b0;
            wb_we_i == 1'b0;
            pkt_rx_ren == 1'b0;
            pkt_tx_data == 64'b0;
            pkt_tx_val == 1'b0;
            pkt_tx_sop == 1'b0;
    	    pkt_tx_eop == 1'b0;
    	    pkt_tx_mod == 3'b0;
            cycles == 1'b1;
           });    

  endtask
  
  virtual task post_body();
   if(starting_phase != null) begin
    starting_phase.drop_objection(this);
   end
  endtask

endclass

`endif
