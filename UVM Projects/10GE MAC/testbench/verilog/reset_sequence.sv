`ifndef RESET_SEQUENCE_SV
`define RESET_SEQUENCE_SV

`include "../../testbench/verilog/reset_item.sv"

class reset_sequence extends uvm_sequence #(reset_item);
  `uvm_object_utils(reset_sequence);

  function new(input string name="reset_sequence");
    super.new(name);
    `uvm_info("RESET_CLASS", $sformatf("Hierarchy:%m"), UVM_HIGH)
  endfunction
 
 virtual task pre_body();
   if(starting_phase != null) begin
    starting_phase.raise_objection(this);
   end
 endtask 

  virtual task body();

     `uvm_do_with(req,{reset_156m25_n==1; reset_xgmii_rx_n==1; reset_xgmii_tx_n==1;  cycles==1;});

     `uvm_do_with(req,{reset_156m25_n==0; reset_xgmii_rx_n==0; reset_xgmii_tx_n==0;  cycles==1;});

     `uvm_do_with(req,{reset_156m25_n==1; reset_xgmii_rx_n==1; reset_xgmii_tx_n==1;  cycles==1;});
   

  endtask
  
  virtual task post_body();
   if(starting_phase != null) begin
    starting_phase.drop_objection(this);
   end
  endtask

endclass

`endif
