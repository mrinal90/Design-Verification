`ifndef	TX_AGENT__SV
`define	TX_AGENT__SV

`include "../../testbench/verilog/tx_driver.sv"
`include "../../testbench/verilog/tx_monitor.sv"

typedef	uvm_sequencer #(packet)	packet_sequencer;

class tx_agent extends uvm_agent;
   `uvm_component_utils(tx_agent)

    packet_sequencer seqr;
    tx_driver drv;
    tx_monitor imon;
    uvm_analysis_port#(packet) analysis_port;

  function new(input string name ="TX_Agent", input uvm_component parent);
    super.new(name, parent);
    `uvm_info("TX_AGENT_BASE", $sformatf("Hierarchy:%m"), UVM_HIGH)
  endfunction

  virtual function void build_phase(input uvm_phase phase);
    super.build_phase(phase);
    if(is_active == UVM_ACTIVE) begin
       seqr=packet_sequencer::type_id::create("seqr",this);
       drv=tx_driver::type_id::create("drv",this);
    end
    imon=tx_monitor::type_id::create("imon",this);
    analysis_port = new("analysis_port",this);
    `uvm_info("TX_AGENT_BASE", $sformatf("Hierarchy:%m"), UVM_HIGH)
  endfunction   
  
  virtual function void connect_phase(input uvm_phase phase);
    super.connect_phase(phase);
    if(is_active==UVM_ACTIVE)begin
       drv.seq_item_port.connect(seqr.seq_item_export);
    end
    imon.ap.connect(this.analysis_port);
  endfunction
   
endclass

`endif //TX_AGENT__SV

