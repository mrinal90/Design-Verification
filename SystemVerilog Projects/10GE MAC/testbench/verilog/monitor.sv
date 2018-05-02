class monitor;
  
  virtual xge_interface mi;
  mailbox mon2sb;
  
  function new(input virtual xge_interface mif, input mailbox mon2sb);
    this.mi= mif;
    this.mon2sb =mon2sb;
  endfunction
  
 
//-----------------Task to monitor packets----------------------// 
  
  task collect_packet();
    bit transfer_in_progress = 0;
    packet rcvpkt;
    bit [7:0] rcv_data[$]; 
    bit [63:0] tmp_rx_data;
    int j;
    bit packet_done =0;
    bit err_in_packet = 0;
	rcvpkt = new();
    
   forever begin
   @(mi.cb) begin

    if (mi.cb.pkt_rx_avail == 1) begin     
      mi.cb.pkt_rx_ren <= 1;
    end
       
      if (mi.cb.pkt_rx_val) begin           
        if(mi.cb.pkt_rx_sop && !mi.cb.pkt_rx_eop && transfer_in_progress==0) begin 
          transfer_in_progress = 1;
          mi.cb.pkt_rx_ren <= 1'b1;
          rcvpkt.sop_flag = mi.cb.pkt_rx_sop;
          rcvpkt.dst_addr = mi.cb.pkt_rx_data[63:16];
          rcvpkt.src_addr[47:32] = mi.cb.pkt_rx_data[15:0];
          rcvpkt.src_addr[31:0] = 32'h0;
          rcvpkt.ether_type = 16'h0;
          rcvpkt.payload = new [0]; 
          while ( rcv_data.size()>0 ) begin
              rcv_data.pop_front();
          end
        end
        
        if(!mi.cb.pkt_rx_sop && !mi.cb.pkt_rx_eop && transfer_in_progress==1) begin
          transfer_in_progress = 1;
          mi.cb.pkt_rx_ren <= 1'b1;
          if ( rcv_data.size()==0 ) begin
            rcvpkt.src_addr[31:0] = mi.cb.pkt_rx_data[63:32];
            rcvpkt.ether_type = mi.cb.pkt_rx_data[31:16];
            rcv_data.push_back(mi.cb.pkt_rx_data[15:8]);
            rcv_data.push_back(mi.cb.pkt_rx_data[7:0]);
          end
          else begin
            for ( int i=0; i<8; i++ ) begin
              tmp_rx_data = mi.cb.pkt_rx_data;
              rcv_data.push_back( (tmp_rx_data >> (64-8*(i+1))) & 8'hFF );
            end
          end
        end
        
        if (mi.cb.pkt_rx_eop && transfer_in_progress==1) begin
          rcvpkt.eop_flag = mi.cb.pkt_rx_eop;
          transfer_in_progress = 0;
          err_in_packet = mi.cb.pkt_rx_err;
          mi.cb.pkt_rx_ren <= 1'b0;
          
          if ( mi.cb.pkt_rx_mod==0 ) begin
            for ( int i=0; i<8; i++ ) begin
              tmp_rx_data = mi.cb.pkt_rx_data;
              rcv_data.push_back( (tmp_rx_data >> (64-8*(i+1))) & 8'hFF );
            end
          end
          else begin
            for ( int i=0; i<mi.cb.pkt_rx_mod; i++ ) begin
              tmp_rx_data = mi.cb.pkt_rx_data;
              rcv_data.push_back( (tmp_rx_data >> (64-8*(i+1))) & 8'hFF );
            end
          end
          
          rcvpkt.payload = new[rcv_data.size()];
          j = 0;
          while ( rcv_data.size()>0 ) begin
            rcvpkt.payload[j]  = rcv_data.pop_front();
            j++;
          end
          packet_done  = 1;
          
        end
		
        if ( mi.cb.pkt_rx_sop && mi.cb.pkt_rx_eop && transfer_in_progress==0) begin
            err_in_packet   = mi.cb.pkt_rx_err;
            mi.cb.pkt_rx_ren <= 1'b1;
            rcvpkt.sop_flag            = mi.cb.pkt_rx_sop;
            rcvpkt.eop_flag            = mi.cb.pkt_rx_eop;
            rcvpkt.dst_addr        = mi.cb.pkt_rx_data[63:16];
            rcvpkt.src_addr[47:32] = mi.cb.pkt_rx_data[15:0];
            rcvpkt.src_addr[31:0]  = 32'h0;
            rcvpkt.ether_type          = 16'h0;
            rcvpkt.payload = new[0];
          while ( rcv_data.size()>0 ) begin
              rcv_data.pop_front();
            end
            packet_done = 1;
            
        end
        
        if ( packet_done ) begin
          $display("============================PACKET RECEIVED======================");
          rcvpkt.print("RECEIVE");
          if ( !err_in_packet && rcvpkt.sop_flag && rcvpkt.eop_flag ) begin
            mon2sb.put(rcvpkt);
          end
          else begin
            $display("time = %3d: MONITOR: ERROR PACKET\n ",$time);
          end
          packet_done= 0;
        end
      end   
   end
   end
  endtask
//---------------------------------------------------------// 
  
endclass
