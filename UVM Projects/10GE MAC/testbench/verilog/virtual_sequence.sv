class virtual_sequence extends uvm_sequence;
   `uvm_object_utils(virtual_sequence);

   `uvm_declare_p_sequencer(virtual_sequencer)

   reset_sequence seq_rst;
   configure_sequence seq_config;
   packet_sequence seq_pkt;

   function new(input string name="virtual_sequence");
     super.new(name);
     `uvm_info("VIRTUAL_CLASS", $sformatf("Hierarchy:%m"), UVM_HIGH)
   endfunction
 
   virtual task pre_start();
     super.pre_start();
     `uvm_info("VIRTUAL_SEQUENCE_CLASS pre_start()", $sformatf("HIERARCHY:%m"),UVM_HIGH);
 
     if((get_parent_sequence()==null)&&(starting_phase != null)) begin
        starting_phase.raise_objection(this);
     end
   endtask

   virtual task body();
//      fork 
//        `uvm_do_on(seq_rst, p_sequencer.seqr_rst);
//        `uvm_do_on(seq_config, p_sequencer.seqr_config);
        `uvm_do_on(seq_pkt, p_sequencer.seqr_pkt);
//      join
   endtask

   virtual task post_start();
     super.post_start();
     `uvm_info("VIRTUAL_SEQUENCE_CLASS post_start()", $sformatf("HIERARCHY:%m"),UVM_HIGH);

     if((get_parent_sequence()==null)&&(starting_phase != null)) begin
        starting_phase.drop_objection(this);
     end
   endtask

endclass
