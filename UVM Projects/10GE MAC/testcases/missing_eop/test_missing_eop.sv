class test_missing_eop extends test_virtualsequence;
   `uvm_component_utils(test_missing_eop)

   function new(input string name, input uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(input uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("TEST MISSING EOP CLASS",$sformatf("Hierarchy:%m"),UVM_HIGH);

     set_inst_override_by_type("v_seqr.*",packet::get_type(), packet_missing_eop::get_type());

   endfunction
endclass

