class monitor;
  
  virtual sdramc_interface mi;
  mailbox mon2sb;
  
  function new(input virtual sdramc_interface mif, input mailbox mon2sb);
    this.mi= mif;
    this.mon2sb =mon2sb;
  endfunction
  
  task collect_data(int addr);
    packet rcvpkt;
    rcvpkt = new();
//    forever begin
    @(negedge mi.sys_clk);
     mi.wb_stb_i        = 1;
     mi.wb_cyc_i        = 1;
     mi.wb_we_i         = 0;
    do begin
      @ (posedge mi.sys_clk);
    end while(mi.wb_ack_o == 1'b0);
    
    rcvpkt.mem_data = mi.wb_dat_o;
    rcvpkt.mem_addr = mi.wb_addr_i;
    rcvpkt.print("READ");
    
    @ (negedge mi.sdram_clk);
    mi.wb_stb_i        = 0;
    mi.wb_cyc_i        = 0;
    mi.wb_we_i         = 'hx;
    mi.wb_addr_i       = 'hx;
    
//    end
  endtask
  
endclass
