`include "../../testbench/verilog/reset_sequence.sv"
`include "../../testbench/verilog/configure_sequence.sv"
`include "../../testbench/verilog/packet_sequence.sv"
`include "../../testbench/verilog/env.sv"
`include "../../testbench/verilog/virtual_sequencer.sv"
`include "../../testbench/verilog/virtual_sequence.sv"

class test_base extends uvm_test;

  env env0;
  packet_sequence seq;
  packet eth;

  `uvm_component_utils(test_base);
  
  function new(input string name, input uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void end_of_elaboration_phase(input uvm_phase phase);

    super.end_of_elaboration_phase(phase);
    
    uvm_top.print_topology();

    factory.print();

  endfunction

  virtual function void start_of_simulation_phase(input uvm_phase phase);

    super.start_of_simulation_phase(phase);
    
    uvm_top.print_topology();

    factory.print();

  endfunction
      
//-------------------------ENVIRONMENT---------------------------------------//
  virtual function void build_phase(input uvm_phase phase);

    super.build_phase(phase);

    env0 = env::type_id::create("env0",this);
    
    
    //Running packet sequence using sequencer using config db// 
    uvm_config_db #(uvm_object_wrapper)::set(this,"env0.agent_in.seqr.main_phase","default_sequence",packet_sequence::get_type());

    //Running reset sequence using sequencer using config db//
   uvm_config_db #(uvm_object_wrapper)::set(this,"env0.agent_rst.seqr.reset_phase","default_sequence",reset_sequence::get_type());

    //Running configure sequence using sequencer using config db//
   uvm_config_db #(uvm_object_wrapper)::set(this,"env0.agent_config.seqr.configure_phase","default_sequence",configure_sequence::get_type());

    //Connecting virtual interface vi to actual interface xif//
    uvm_config_db #(virtual xge_interface)::set(this,"env0.agent_in.drv","vi",tb.xif);
    
    //Connecting virtual interface mi of omonitor to actual interface xiff//
    uvm_config_db #(virtual xge_interface)::set(this,"env0.agent_out.omon","mi",tb.xif);
 
    //Connecting virtual interface vi for reset driver  to actual interface riff//
    uvm_config_db #(virtual xge_interface)::set(this,"env0.agent_rst.drv","vi",tb.xif);
   
    //Connecting virtual interface vi for configure driver  to actual interface riff//
    uvm_config_db #(virtual xge_interface)::set(this,"env0.agent_config.drv","vi",tb.xif);

    //Connecting virtual interface mi of imonitor to actual interface xiff//
    uvm_config_db #(virtual xge_interface)::set(this,"env0.agent_in.imon","mi",tb.xif);
 
    //Set number of packets here//
    uvm_config_db #(int unsigned)::set(this,"*","num_packets",5);

  endfunction
  
//-------------------------SEQUENCE------------------------------------------
  virtual task run_phase(input uvm_phase phase);
    
    `uvm_info("TEST_BASE", $sformatf("%m"), UVM_HIGH)

  endtask


//---------------------------Main_Phase--------------------------------------
  virtual task main_phase(input uvm_phase phase);
    uvm_objection objection;
    super.main_phase(phase);

    objection = phase.get_objection();
    objection.set_drain_time(this,0.4us);
  endtask

endclass

//============================================Virtual Sequence Class==============================================================

class test_virtualsequence extends test_base;

  `uvm_component_utils(test_virtualsequence);

  virtual_sequencer v_seqr;

   function new(input string name, input uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(input uvm_phase phase);
     super.build_phase(phase);

     //Create object for Virtual Sequencer//
    v_seqr= virtual_sequencer::type_id::create("v_seqr",this);

     //Running sequence using sequencer using config db//
    //uvm_config_db #(uvm_object_wrapper)::set(this,"env0.agent_in.seqr.main_phase","default_sequence",packet_sequence::get_type());
    uvm_config_db #(uvm_object_wrapper)::set(this,"env0.agent_in.seqr.main_phase","default_sequence",null);

    //Running sequence using sequencer using config db//
    uvm_config_db #(uvm_object_wrapper)::set(this,"env0.agent_rst.seqr.reset_phase","default_sequence",reset_sequence::get_type());

     //Running configure sequence using sequencer using config db//
   uvm_config_db #(uvm_object_wrapper)::set(this,"env0.agent_config.seqr.configure_phase","default_sequence",configure_sequence::get_type());

    //Running Virtual Sequence using Virtual Sequencer on Packet Sequence//
    uvm_config_db #(uvm_object_wrapper)::set(this,"v_seqr.main_phase","default_sequence",virtual_sequence::get_type());
   
   endfunction

   virtual function void connect_phase(input uvm_phase phase);
      super.connect_phase(phase);

      v_seqr.seqr_rst = env0.agent_rst.seqr;
      v_seqr.seqr_pkt = env0.agent_in.seqr;
      v_seqr.seqr_config= env0.agent_config.seqr;

   endfunction

endclass

