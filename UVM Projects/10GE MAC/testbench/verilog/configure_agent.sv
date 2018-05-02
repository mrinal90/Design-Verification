`ifndef	CONFIGURE_AGENT__SV
`define	CONFIGURE_AGENT__SV

`include "../../testbench/verilog/configure_driver.sv"

typedef	uvm_sequencer #(configure_item)	configure_sequencer;

class configure_agent extends uvm_agent;
   `uvm_component_utils(configure_agent)

    configure_sequencer seqr;
    configure_driver drv;
//    imonitor imon;

  function new(input string name ="CONFIGUREAgent", input uvm_component parent);
    super.new(name, parent);
    `uvm_info("CONFIGURE_AGENT_BASE", $sformatf("Hierarchy:%m"), UVM_HIGH)
  endfunction

  virtual function void build_phase(input uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE) begin
       seqr=configure_sequencer::type_id::create("seqr",this);
       drv=configure_driver::type_id::create("drv",this);
    end
//    imon=imonitor::type_id::create("imon",this);
  endfunction   
  
  virtual function void connect_phase(input uvm_phase phase);
    super.connect_phase(phase);
    if(is_active==UVM_ACTIVE)begin
       drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction
   
endclass

`endif //INPUT_AGENT__SV

