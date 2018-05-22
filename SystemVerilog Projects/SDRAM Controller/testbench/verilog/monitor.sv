class monitor;
  
  virtual sdramc_interface mi;
  mailbox mon2sb;
  
  function new(input virtual sdramc_interface mif, input mailbox mon2sb);
    this.mi= mif;
    this.mon2sb =mon2sb;
  endfunction
  
  task collect_data();
    packet rcvpkt;
    bit [25:0] Address[$];
    bit [7:0] bl;
    bit read_process;
    bit address_fetch;
    
    rcvpkt = new();
    bl = 8'b0;
   
    forever begin
    
      @ (negedge mi.sdram_clk) begin
        if ((mi.wb_we_i == 1'b1)&&(mi.wb_ack_o == 1'b1)) begin
          Address.push_back(mi.wb_addr_i);
          bl            = bl +1;
          address_fetch = 1;
          read_process  = 0;
        end
      end
   
      @ (posedge mi.sys_clk) begin
        if ((mi.wb_we_i === 1'bX)&&(address_fetch == 1'b1)) begin  
          @ (posedge mi.sys_clk);
          for(int i=0; i < bl; i++) begin
            read_process       = 1;
            address_fetch      = 0;
            mi.wb_stb_i        = 1;
            mi.wb_cyc_i        = 1;
            mi.wb_we_i         = 0;
            mi.wb_addr_i       = Address.pop_front();

            do begin
              @ (posedge mi.sys_clk);
            end while(mi.wb_ack_o == 1'b0);

            rcvpkt.mem_data = mi.wb_dat_o;
            rcvpkt.mem_addr = mi.wb_addr_i;

      //      rcvpkt.print("READ");
            $display("Time = %3d Status: Read Address: %x Burst Size: %x Read Data: %x ", $time, mi.wb_addr_i, bl, mi.wb_dat_o);
          end
        end
      end
      
      if ((read_process == 1)&&(address_fetch == 0)) begin
        
          mi.wb_stb_i        = 0;
          mi.wb_cyc_i        = 0;
          mi.wb_we_i         = 'hx;
          mi.wb_addr_i       = 'hx;
          bl = 8'b0;
        end
      
    end
    
    mon2sb.put(rcvpkt); 
  endtask
  
endclass
