class tx_monitor extends uvm_monitor;
   `uvm_component_utils(tx_monitor)
   virtual xge_interface mi;
   
   uvm_analysis_port#(packet) ap;
 
   function new(input string name="TXMonitor",input uvm_component parent);
      super.new(name,parent);
   endfunction

   virtual function void build_phase(input uvm_phase phase);
      super.build_phase(phase);
      ap = new("ap",this);

      uvm_config_db#(virtual xge_interface)::get(this, "", "mi",mi);

     if(mi==null) begin
       `uvm_fatal("CFGERR","Virtual Interface for TX Monitor not set")
     end
   endfunction
   
   virtual task run_phase(input uvm_phase phase);

      packet drvpkt;
      bit transfer_in_progress = 0;
      bit [7:0] rcv_data[$];
      bit [63:0] tmp_rx_data;
      int j;
      bit packet_done =0;
//      bit err_in_packet = 0;
      
//      drvpkt=packet::type_id::create("drvpkt",this);

      `uvm_info("OMONITOR run_phase()",$sformatf("%m"),UVM_HIGH);
      
      forever begin
      @(mi.cb);
 
//      if (mi.pkt_rx_avail == 1) begin
//         mi.pkt_rx_ren <= 1;
//      end
      if (mi.pkt_tx_val) begin
        if(mi.pkt_tx_sop && !mi.pkt_tx_eop && transfer_in_progress==0) begin
          transfer_in_progress = 1;
//          mi.pkt_rx_ren <= 1'b1;
          drvpkt=packet::type_id::create("drvpkt",this);
          drvpkt.sop_flag = mi.pkt_tx_sop;
          drvpkt.dst_addr = mi.pkt_tx_data[63:16];
          drvpkt.src_addr[47:32] = mi.pkt_tx_data[15:0];
          drvpkt.src_addr[31:0] = 32'h0;
          drvpkt.ether_type = 16'h0;
          drvpkt.payload = new [0];
          while ( rcv_data.size()>0 ) begin
              rcv_data.pop_front();
          end
        end

        if(!mi.pkt_tx_sop && !mi.pkt_tx_eop && transfer_in_progress==1) begin
          transfer_in_progress = 1;
//          mi.pkt_rx_ren <= 1'b1;
          if ( rcv_data.size()==0 ) begin
            drvpkt.src_addr[31:0] = mi.pkt_tx_data[63:32];
            drvpkt.ether_type = mi.pkt_tx_data[31:16];
            rcv_data.push_back(mi.pkt_tx_data[15:8]);
            rcv_data.push_back(mi.pkt_tx_data[7:0]);
          end
          else begin
            for ( int i=0; i<8; i++ ) begin
              tmp_rx_data = mi.pkt_tx_data;
              rcv_data.push_back( (tmp_rx_data >> (64-8*(i+1))) & 8'hFF );
            end
          end
        end

        if (mi.pkt_tx_eop && transfer_in_progress==1) begin
          drvpkt.eop_flag = mi.pkt_tx_eop;
          transfer_in_progress = 0;
//          err_in_packet = mi.pkt_tx_err;
//          mi.pkt_rx_ren <= 1'b0;

          if ( mi.pkt_tx_mod==0 ) begin
            for ( int i=0; i<8; i++ ) begin
              tmp_rx_data = mi.pkt_tx_data;
              rcv_data.push_back( (tmp_rx_data >> (64-8*(i+1))) & 8'hFF );
            end
          end
          else begin
            for ( int i=0; i<mi.pkt_tx_mod; i++ ) begin
              tmp_rx_data = mi.pkt_tx_data;
              rcv_data.push_back( (tmp_rx_data >> (64-8*(i+1))) & 8'hFF );
            end
          end

          drvpkt.payload = new[rcv_data.size()];
          j = 0;
          while ( rcv_data.size()>0 ) begin
            drvpkt.payload[j]  = rcv_data.pop_front();
            j++;
          end
          packet_done  = 1;

        end

        if ( mi.pkt_tx_sop && mi.pkt_tx_eop && transfer_in_progress==0) begin
//            err_in_packet   = mi.pkt_rx_err;
//            mi.pkt_rx_ren <= 1'b1;
            drvpkt.sop_flag            = mi.pkt_tx_sop;
            drvpkt.eop_flag            = mi.pkt_tx_eop;
            drvpkt.dst_addr        = mi.pkt_tx_data[63:16];
            drvpkt.src_addr[47:32] = mi.pkt_tx_data[15:0];
            drvpkt.src_addr[31:0]  = 32'h0;
            drvpkt.ether_type          = 16'h0;
            drvpkt.payload = new[0];
          while ( rcv_data.size()>0 ) begin
              rcv_data.pop_front();
            end
            packet_done = 1;

        end

        if ( packet_done ) begin
          $display("============================PACKET RECEIVED======================");
         //Content of received packet is:
         `uvm_info("Got_input_packet",{"\n",drvpkt.sprint()},UVM_HIGH);
//         if ( !err_in_packet && drvpkt.sop_flag && drvpkt.eop_flag ) begin
         if (drvpkt.sop_flag && drvpkt.eop_flag ) begin
            ap.write(drvpkt);
         end
         else begin
            `uvm_warning("ERROR","INPUT MONITOR: Missing EOP/SOP flag");
         end
         packet_done = 0;
       end
      end
    end
   endtask

endclass//TX_MONITOR_SV 
