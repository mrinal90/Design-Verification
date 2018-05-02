class driver;
  
  packet ethernet;
  virtual xge_interface vi;
  mailbox drv2sb;
  
  function new(input virtual xge_interface vif, input mailbox drv2sb);
    this.vi= vif;
    this.drv2sb= drv2sb;
    ethernet =new();
  endfunction
  
  //---------------------Task to send randomized packets---------------------------// 
  task send_packet(int num_packet);
     
     packet pkt;
     int unsigned no_of_slices;
     int unsigned pkt_len;
     bit [63:0] pkt_data;
   
     for (int j=0; j<num_packet; j++ ) begin
     
     $display("============================PACKET #%2d======================",j+1); 
    
     pkt = new ethernet;
     
     assert(pkt.randomize());
     pkt_len = 14 + pkt.payload.size();
     no_of_slices = ((pkt_len%8) ? (pkt_len/8 + 1) : (pkt_len/8));
     
     for (int i = 0; i < no_of_slices; i = i + 1) begin
 //--------------------- SOP STATE -------------------------------//     
       pkt_data = 64'h0;
       @(vi.cb);
       if (i == 0) begin
         pkt_data = {pkt.dst_addr, pkt.src_addr[47:32]};
         vi.cb.pkt_tx_val <= 1'b1;
         vi.cb.pkt_tx_sop <= pkt.sop_flag;
         vi.cb.pkt_tx_eop <= 1'b0;
         vi.cb.pkt_tx_mod <= $urandom_range(0,7);
         vi.cb.pkt_tx_data <= pkt_data;
       end
 
  //--------------------- MIDDLE STATE -------------------------------//            
       else if(i == 1) begin
         pkt_data = {pkt.src_addr[31:0], pkt.ether_type, pkt.payload[0], pkt.payload[1]};
         vi.cb.pkt_tx_val <= 1'b1;
         vi.cb.pkt_tx_sop <= 1'b0;
         vi.cb.pkt_tx_eop <= 1'b0;
         vi.cb.pkt_tx_mod <= $urandom_range(0,7);
         vi.cb.pkt_tx_data <= pkt_data;
       end
       
       else if ((i > 1) && (i < no_of_slices -1)) begin
         for (int j = 0; j < 8 ; j = j + 1) begin
           pkt_data = ((pkt_data << 8) | pkt.payload[8*i+j-14]);
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
           pkt_data = ((pkt_data << 8) | pkt.payload[pkt.payload.size()-1-j]);
         end
            
         vi.cb.pkt_tx_val <= 1'b1;
         vi.cb.pkt_tx_sop <= 1'b0;
         vi.cb.pkt_tx_eop <= pkt.eop_flag;
         //vi.cb.pkt_tx_mod <= (pkt_len%8);
         vi.cb.pkt_tx_mod <= 3'b0;
         vi.cb.pkt_tx_data <= pkt_data;
       end
     end
     
     pkt.print("SENT");
     
     while(vi.cb.pkt_tx_full) begin
       @(vi.cb);
       vi.cb.pkt_tx_val <= 1'b0;
       vi.cb.pkt_tx_sop <= 1'b0;
       vi.cb.pkt_tx_eop <= 1'b0;
       vi.cb.pkt_tx_mod <= $urandom_range(0,7);
       vi.cb.pkt_tx_data <= {$urandom, $urandom_range(0,64'hFFFF)};
     end
     
     repeat (pkt.ipg) begin
       @(vi.cb);
       vi.cb.pkt_tx_val <= 1'b0;
       vi.cb.pkt_tx_sop <= 1'b0;
       vi.cb.pkt_tx_eop <= 1'b0;
       vi.cb.pkt_tx_mod <= $urandom_range(0,7);
       vi.cb.pkt_tx_data <= {$urandom,$urandom_range(0,64'hFFFF)};
     end
     
      if ( (j==num_packet-1) && pkt.ipg==0 ) begin
        @(vi.cb);
        vi.cb.pkt_tx_val    <= 1'b0;
        vi.cb.pkt_tx_sop    <= 1'b0;
        vi.cb.pkt_tx_eop    <= 1'b0;
        vi.cb.pkt_tx_mod    <= $urandom_range(0,7);
        vi.cb.pkt_tx_data   <= { $urandom, $urandom_range(0,65535) };
      end  
       
     if (pkt.sop_flag && pkt.eop_flag) begin
       drv2sb.put(pkt);
     end
     else begin
       $display("time = %3d: DRIVER: ERROR PACKET\n ",$time,);
     end
     
     end  
  endtask
//---------------------------------------------------------// 
  
endclass

 
