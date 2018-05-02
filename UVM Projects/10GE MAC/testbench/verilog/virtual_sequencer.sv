class virtual_sequencer extends uvm_sequencer;
   `uvm_component_utils(virtual_sequencer)
 
   reset_sequencer  seqr_rst;
   packet_sequencer seqr_pkt;
   configure_sequencer seqr_config;

   function new(input string name, input uvm_component parent);
      super.new(name, parent);
   endfunction

endclass
