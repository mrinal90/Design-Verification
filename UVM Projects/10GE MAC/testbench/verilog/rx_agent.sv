`ifndef	RX_AGENT__SV
`define	RX_AGENT__SV

`include "../../testbench/verilog/rx_monitor.sv"


class rx_agent extends uvm_agent;
   `uvm_component_utils(rx_agent)

    rx_monitor omon;
   
    uvm_analysis_port#(packet) analysis_port;

  function new(input string name ="RXAgent", input uvm_component parent);
    super.new(name, parent);
    `uvm_info("AGENT_BASE", $sformatf("Hierarchy:%m"), UVM_HIGH)
  endfunction

  virtual function void build_phase(input uvm_phase phase);
    super.build_phase(phase);

    omon=rx_monitor::type_id::create("omon",this);
    `uvm_info("RX_AGENT_BASE", $sformatf("Hierarchy:%m"), UVM_HIGH)
  endfunction   
  
  virtual function void connect_phase(input uvm_phase phase);
    super.connect_phase(phase);
    this.analysis_port=omon.ap;
  endfunction
   
endclass

`endif //RX_AGENT__SV

