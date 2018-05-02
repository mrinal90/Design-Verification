`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV

class scoreboard extends uvm_scoreboard;
   `uvm_component_utils(scoreboard)
   
   typedef uvm_in_order_class_comparator#(packet) packet_comparator;
  packet_comparator comparator;

   uvm_analysis_export#(packet) from_agent_out;
   uvm_analysis_export#(packet) from_agent_in;

   function new(input string name="Scoreboard",input uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(input uvm_phase phase);
      super.build_phase(phase);
      
      comparator = packet_comparator::type_id::create("comparator",this);
      from_agent_out = new("from_agent_out",this);
      from_agent_in = new("from_agent_in",this);

   endfunction

   virtual function void connect_phase(input uvm_phase phase);
      super.connect_phase(phase);
      this.from_agent_out.connect(comparator.after_export);
      this.from_agent_in.connect(comparator.before_export);

   endfunction


   virtual function void report_phase(input uvm_phase phase);
      `uvm_info("ScoreboardClass report_phase()",$sformatf("%m"),UVM_HIGH);
      `uvm_info("Scoreboard Report:",
      $sformatf("Number of Packet Matches=%0d,Number of Packet Mismatches=%0d", comparator.m_matches, comparator.m_mismatches),UVM_HIGH);
      
      if(comparator.m_mismatches != 0) begin
         `uvm_fatal("TEST FAIL","PACKET MISMATCHES");
      end
      else begin
         `uvm_info("TEST PASS",$sformatf("PACKET COMPARE SUCCESSFUL"),UVM_HIGH);      
      end

   endfunction


endclass 

`endif       
