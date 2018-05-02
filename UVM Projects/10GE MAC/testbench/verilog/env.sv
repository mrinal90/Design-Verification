`ifndef	ENV__SV
`define	ENV__SV

`include "../../testbench/verilog/tx_agent.sv"
`include "../../testbench/verilog/rx_agent.sv"
`include "../../testbench/verilog/reset_agent.sv"
`include "../../testbench/verilog/configure_agent.sv"
`include "../../testbench/verilog/scoreboard.sv"

class env extends uvm_env;
   `uvm_component_utils(env)

  tx_agent agent_in;
  rx_agent agent_out;
  reset_agent agent_rst;
  configure_agent agent_config;
  scoreboard sb;
  
  function new(input string name="Harsh Env", input uvm_component parent);
    super.new(name,parent);
  endfunction //new

  virtual function void build_phase(input uvm_phase phase);
    super.build_phase(phase);
    
    agent_in = tx_agent::type_id::create("agent_in", this);
    agent_out = rx_agent::type_id::create("agent_out",this);
    agent_rst = reset_agent::type_id::create("agent_rst", this);
    agent_config = configure_agent::type_id::create("agent_config", this);
    sb = scoreboard::type_id::create("sb",this);

  endfunction //build_phase
  
  virtual function void connect_phase(input uvm_phase phase);

    super.connect_phase(phase);
    agent_out.analysis_port.connect(sb.from_agent_out);
    agent_in.analysis_port.connect(sb.from_agent_in);
    
  endfunction

endclass

`endif //ENV__SV

