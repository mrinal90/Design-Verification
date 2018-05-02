`ifndef	TX_DRIVER__SV
`define	TX_DRIVER__SV

class tx_driver extends uvm_driver #(packet);
   `uvm_component_utils(tx_driver)
   
   virtual xge_interface vi;

   function new(input string name="TX_DRIVER", input uvm_component parent);
      super.new(name, parent);
   endfunction

   virtual function void build_phase(input uvm_phase phase);
     `uvm_info("TX DRIVER CLASS", "HIERARCHY: %m", UVM_HIGH);
     uvm_config_db#(virtual xge_interface)::get(this, "", "vi",vi);

     if(vi==null) begin
       `uvm_fatal("CFGERR","Virtual Interface for TX Driver not set")
     end
   endfunction

   virtual task run_phase(input uvm_phase phase);
     
     integer unsigned no_of_slices;
     integer unsigned pkt_len;
     bit [63:0] pkt_data;


     forever begin
     
     seq_item_port.try_next_item(req);

     if ( req == null ) begin
        @(vi.cb);
        vi.cb.pkt_tx_val    <= 1'b0;
        vi.cb.pkt_tx_sop    <= 1'b0;
        vi.cb.pkt_tx_eop    <= 1'b0;
        vi.cb.pkt_tx_mod    <= $urandom_range(7,0);
        vi.cb.pkt_tx_data   <= { $urandom, $urandom_range(65535,0) };
      end
     else begin
     `uvm_info( get_name(), $psprintf("Packet: \n%0s", req.sprint()), UVM_HIGH)
     pkt_len = 14 + req.payload.size();
     no_of_slices = ((pkt_len%8) ? (pkt_len/8 + 1) : (pkt_len/8));

     for (int i = 0; i < no_of_slices; i = i + 1) begin
 //--------------------- SOP STATE -------------------------------//
       pkt_data = 64'h0;
       @(vi.cb);
       if (i == 0) begin
         pkt_data = {req.dst_addr, req.src_addr[47:32]};
         vi.cb.pkt_tx_val <= 1'b1;
         vi.cb.pkt_tx_sop <= req.sop_flag;
         vi.cb.pkt_tx_eop <= 1'b0;
         vi.cb.pkt_tx_mod <= $urandom_range(0,7);
         vi.cb.pkt_tx_data <= pkt_data;
       end

  //--------------------- MIDDLE STATE -------------------------------//
       else if(i == 1) begin
         pkt_data = {req.src_addr[31:0], req.ether_type, req.payload[0], req.payload[1]};
         vi.cb.pkt_tx_val <= 1'b1;
         vi.cb.pkt_tx_sop <= 1'b0;
         vi.cb.pkt_tx_eop <= 1'b0;
         vi.cb.pkt_tx_mod <= $urandom_range(0,7);
         vi.cb.pkt_tx_data <= pkt_data;
       end

       else if ((i > 1) && (i < no_of_slices -1)) begin
         for (int j = 0; j < 8 ; j = j + 1) begin
           pkt_data = ((pkt_data << 8) | req.payload[8*i+j-14]);
         end

         vi.cb.pkt_tx_val <= 1'b1;
         vi.cb.pkt_tx_sop <= 1'b0;
         vi.cb.pkt_tx_eop <= 1'b0;
         vi.cb.pkt_tx_mod <= $urandom_range(0,7);
         vi.cb.pkt_tx_data <= pkt_data;
       end

  //--------------------- EOP STATE -------------------------------//
       else if (i == no_of_slices-1) begin
         for (int j = 7; j >= 0 ; j = j - 1) begin
           pkt_data = ((pkt_data << 8) | req.payload[req.payload.size()-1-j]);
         end

         vi.cb.pkt_tx_val <= 1'b1;
         vi.cb.pkt_tx_sop <= 1'b0;
         vi.cb.pkt_tx_eop <= req.eop_flag;
         //vi.cb.pkt_tx_mod <= (pkt_len%8);
         vi.cb.pkt_tx_mod <= 3'b0;
         vi.cb.pkt_tx_data <= pkt_data;
       end
     end

//     req.print("SENT");

     while(vi.cb.pkt_tx_full) begin
       @(vi.cb);
       vi.cb.pkt_tx_val <= 1'b0;
       vi.cb.pkt_tx_sop <= 1'b0;
       vi.cb.pkt_tx_eop <= 1'b0;
       vi.cb.pkt_tx_mod <= $urandom_range(0,7);
       vi.cb.pkt_tx_data <= {$urandom, $urandom_range(0,64'hFFFF)};
     end

     repeat (req.ipg) begin
       @(vi.cb);
       vi.cb.pkt_tx_val <= 1'b0;
       vi.cb.pkt_tx_sop <= 1'b0;
       vi.cb.pkt_tx_eop <= 1'b0;
       vi.cb.pkt_tx_mod <= $urandom_range(0,7);
       vi.cb.pkt_tx_data <= {$urandom,$urandom_range(0,64'hFFFF)};
     end

     seq_item_port.item_done();
     end
   end
   endtask

endclass

`endif //TX_DRIVER_SV
