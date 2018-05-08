class driver;
  
  packet ethernet;
  virtual sdramc_interface vi;
  mailbox drv2sb;
  
  function new(input virtual sdramc_interface vif, input mailbox drv2sb);
    this.vi= vif;
    this.drv2sb= drv2sb;
    ethernet =new();
  endfunction
  
  task send_data(int addr);
    packet pkt;
    
    pkt=new ethernet;
    assert(pkt.randomize);
    @(negedge vi.sys_clk);
     vi.wb_stb_i        = 1;
     vi.wb_cyc_i        = 1;
     vi.wb_we_i         = 1;
     vi.wb_sel_i        = 4'b1111;
     vi.wb_addr_i       = pkt.mem_addr;
     vi.wb_dat_i        = pkt.mem_data;
    
    do begin
      @ (posedge vi.sys_clk);
    end while(vi.wb_ack_o == 1'b0);
    
    pkt.print("WRITE");
//    @ (posedge vi.sys_clk);
    @ (negedge vi.sdram_clk);
    vi.wb_stb_i        = 0;
    vi.wb_cyc_i        = 0;
    vi.wb_we_i         = 'hx;
    vi.wb_sel_i        = 'hx;
    vi.wb_dat_i        = 'hx;
  endtask
  
endclass
  
  