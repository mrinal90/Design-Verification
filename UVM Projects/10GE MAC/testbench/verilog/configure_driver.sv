`ifndef	CONFIGURE_DRIVER__SV
`define	CONFIGURE_DRIVER__SV

class configure_driver extends uvm_driver #(configure_item);
   `uvm_component_utils(configure_driver)
   
   virtual xge_interface vi;

   function new(input string name="CONFIGURE_DRIVER", input uvm_component parent);
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

        `uvm_info("ConfigureDriver run_phase()",{"\n",req.sprint()},UVM_HIGH);
        
        repeat(req.cycles) @(vi.cb);
        vi.wb_adr_i <= req.wb_adr_i;
        vi.wb_clk_i <= req.wb_clk_i;
        vi.wb_cyc_i <= req.wb_cyc_i;
        vi.wb_dat_i <= req.wb_dat_i;
        vi.wb_rst_i <= req.wb_rst_i;
        vi.wb_stb_i <= req.wb_stb_i;
        vi.wb_we_i <= req.wb_we_i;
        vi.pkt_rx_ren <= req.pkt_rx_ren;
        vi.pkt_tx_data <= req.pkt_tx_data;
        vi.pkt_tx_val <= req.pkt_tx_val;
        vi.pkt_tx_sop <= req.pkt_tx_sop;
        vi.pkt_tx_eop <= req.pkt_tx_eop;
        vi.pkt_tx_mod <= req.pkt_tx_mod;
       

        seq_item_port.item_done();

      end
   endtask

endclass

`endif //DRIVER__SV
