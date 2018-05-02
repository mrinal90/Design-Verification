`ifndef PACKET_SEQUENCE_SV
`define PACKET_SEQUENCE_SV

`include "../../testbench/verilog/packet.sv"

class packet_sequence extends uvm_sequence #(packet);
  `uvm_object_utils(packet_sequence);
  
  function new(input string name="packet_sequence");
    super.new(name);
    `uvm_info("PACKET_CLASS", $sformatf("Hierarchy:%m"), UVM_HIGH)
  endfunction  
  
  int unsigned num_packets=3;
 
  virtual task pre_start();
    super.pre_start();

   if(starting_phase != null) begin
    starting_phase.raise_objection(this);
   end
  
   uvm_config_db#(int unsigned)::get(null,get_full_name(),"num_packets",num_packets);
  endtask

  virtual task body();

     repeat(num_packets) begin
       `uvm_do(req)    // req is request...uvm_do creates sequence item.
     end
 
  endtask

  virtual task post_start();
   super.post_start();
   if(starting_phase != null) begin
    starting_phase.drop_objection(this);
   end
  endtask

endclass

`endif
