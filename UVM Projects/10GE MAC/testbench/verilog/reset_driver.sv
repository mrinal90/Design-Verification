`ifndef	RESET_DRIVER__SV
`define	RESET_DRIVER__SV

class reset_driver extends uvm_driver #(reset_item);
   `uvm_component_utils(reset_driver)
   
   virtual xge_interface vi;

   function new(input string name="RESET_DRIVER", input uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(input uvm_phase phase);
     super.build_phase(phase);
     `uvm_info("DRIVER CLASS", "HIERARCHY: %m", UVM_HIGH);
     uvm_config_db#(virtual xge_interface)::get(this, "", "vi",vi);

     if(vi==null) begin
       `uvm_fatal("CFGERR","Virtual Interface for Driver not set")
     end
   endfunction

   virtual task run_phase(input uvm_phase phase);

      forever begin

        seq_item_port.get_next_item(req);
        `uvm_info("ResetDriver run_phase()",{"\n",req.sprint()},UVM_HIGH);
        vi.reset_156m25_n <= req.reset_156m25_n;
        vi.reset_xgmii_rx_n <= req.reset_xgmii_rx_n;
        vi.reset_xgmii_tx_n <= req.reset_xgmii_tx_n;
        repeat(req.cycles) @(posedge vi.clk_156m25);
        vi.reset_156m25_n <= req.reset_156m25_n;
        vi.reset_xgmii_rx_n <= req.reset_xgmii_rx_n;
        vi.reset_xgmii_tx_n <= req.reset_xgmii_tx_n;
        seq_item_port.item_done();
      end
   endtask

endclass

`endif //DRIVER__SV
