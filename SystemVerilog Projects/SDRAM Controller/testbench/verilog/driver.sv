//////////////////////////////////////////////////////////////////////
////                                                              ////
////  File name:driver.sv                              
////                   
////  Notes: The burst packets have to be part of 1 big packet
////  
/////////////////////////////////////////////////////////////////

class driver;
  
  packet ethernet;
  virtual sdramc_interface vi;
  mailbox drv2sb;
  
  function new(input virtual sdramc_interface vif, input mailbox drv2sb);
    this.vi= vif;
    this.drv2sb= drv2sb;
    ethernet =new();
  endfunction
  
  task send_data(int num_of_writes);
//    task send_data();
    packet pkt;
    logic [31:0] Address;
    logic [31:0] Write_data;
    int burst_length;
    
    
    for (int j=0; j<num_of_writes; j++ ) begin
      
      $display("time = %3d===========================Write + Read #%2d======================",$time,j+1); 
      
      pkt=new ethernet;
      assert(pkt.randomize);
      burst_length = pkt.mem_data.size();
      Address = pkt.mem_addr;
      
      if (vi.wb_we_i === 1'bX) begin
        
      	@(posedge vi.sys_clk);

        for(int i=0; i < burst_length; i++) begin
          vi.wb_stb_i        = 1;
          vi.wb_cyc_i        = 1;
          vi.wb_we_i         = 1;
          vi.wb_sel_i        = 4'b1111;
          
          //pkt.mem_data 		 = pkt.mem_data +i;
          
          Write_data = pkt.mem_data[i];
          
          vi.wb_addr_i       = Address[31:2]+i;
          vi.wb_dat_i        = Write_data;

          do begin
            @ (posedge vi.sys_clk);
          end while(vi.wb_ack_o == 1'b0);

          //         $display("Address:%32b", Address);       //Debug
          //pkt.print("WRITE");
          /*$display("Time = %3d Status: Write Address: %x Burst Size: %2x Write Data: %x ", $time, vi.wb_addr_i, burst_length, vi.wb_dat_i);*/
         
          @ (posedge vi.sys_clk);
           
        end
        
        drv2sb.put(pkt);
        pkt.print("WRITE");
        
        vi.wb_stb_i        = 0;
        vi.wb_cyc_i        = 0;
        vi.wb_we_i         = 'hx;
        vi.wb_sel_i        = 'hx;
        vi.wb_dat_i        = 'hx;
        vi.wb_addr_i       = 'hx;

               
      end
      
      #2000;
    end
  endtask
  
endclass
  
  