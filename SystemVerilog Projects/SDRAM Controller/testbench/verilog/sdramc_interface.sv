interface sdramc_interface (input bit sdram_clk, input bit sys_clk, input bit wb_clk_i, input bit wb_rst_i, input bit sdram_resetn);
  
    
  parameter      APP_AW   = 26;  // Application Address Width
  parameter      APP_DW   = 32;  // Application Data Width 
  parameter      APP_BW   = 4;   // Application Byte Width
  parameter      APP_RW   = 9;   // Application Request Width

  parameter      dw       = 32;  // data width
  parameter      tw       = 8;   // tag id width
  parameter      bl       = 9;   // burst_lenght_width 

  logic [1:0]           cfg_sdr_width      ; 
  logic [1:0]           cfg_colbits        ; 

  logic                 wb_stb_i           ;
  logic                 wb_ack_o           ;
  logic [APP_AW-1:0]    wb_addr_i          ;
  logic                 wb_we_i            ; // 1 - Write, 0 - Read
  logic [dw-1:0]        wb_dat_i           ;
  logic [dw/8-1:0]      wb_sel_i           ; // Byte enable
  logic [dw-1:0]        wb_dat_o           ;
  logic                 wb_cyc_i           ;
  logic [2:0]           wb_cti_i           ;

  logic                 sdr_cke             ; // SDRAM CKE
  logic 			    sdr_cs_n            ; // SDRAM Chip Select
  logic                 sdr_ras_n           ; // SDRAM ras
  logic                 sdr_cas_n           ; // SDRAM cas
  logic					sdr_we_n            ; // SDRAM write enable
  logic [3:0] 			sdr_dqm             ; // SDRAM Data Mask
  logic [1:0] 			sdr_ba              ; // SDRAM Bank Enable
  logic [12:0] 			sdr_addr            ; // SDRAM Address
  wire [31:0] 			sdr_dq              ; // SDRA Data Input/output


  logic                 sdr_init_done       ; // Indicate SDRAM Initialisation Done
  logic [3:0] 			cfg_sdr_tras_d      ; // Active to precharge delay
  logic [3:0]           cfg_sdr_trp_d       ; // Precharge to active delay
  logic [3:0]           cfg_sdr_trcd_d      ; // Active to R/W delay
  logic 				cfg_sdr_en          ; // Enable SDRAM controller
  logic [1:0] 			cfg_req_depth       ; // Maximum Request accepted by SDRAM controller
  logic [12:0] 			cfg_sdr_mode_reg    ;
  logic [2:0] 			cfg_sdr_cas         ; // SDRAM CAS Latency
  logic [3:0] 			cfg_sdr_trcar_d     ; // Auto-refresh period
  logic [3:0]           cfg_sdr_twr_d       ; // Write recovery delay
  logic [11 : 0] 		cfg_sdr_rfsh;
  logic [2 : 0] 		cfg_sdr_rfmax;

  // to fix the sdram interface timing issue
//  bit 		 	sdram_clk_d;
  
  
   //------------------Default Clocking block for Data transfer-------------// 
  default clocking cb @(posedge sdram_clk);  
    input #1 cfg_sdr_width, cfg_colbits, wb_stb_i, wb_addr_i, wb_we_i, wb_dat_i, wb_sel_i, wb_cyc_i, wb_cti_i, cfg_req_depth, cfg_sdr_en, cfg_sdr_mode_reg, cfg_sdr_tras_d, cfg_sdr_trp_d, cfg_sdr_trcd_d, cfg_sdr_cas, cfg_sdr_trcar_d, cfg_sdr_twr_d, cfg_sdr_rfsh, cfg_sdr_rfmax;
    
    output #1  sdr_cs_n, sdr_cke, sdr_ras_n, sdr_cas_n, sdr_we_n, sdr_dqm, sdr_ba, sdr_addr, sdr_init_done, wb_ack_o, wb_dat_o;
    
    inout  sdr_dq;
    
  endclocking
  
   //------------------Modport Declaration for testcase-------------// 
  modport testcase_port (clocking cb);
   
//-----------Task to initialize variables-----------------------// 
  task init();  
    wb_addr_i      <= 0;
    wb_dat_i       <= 0;
    wb_sel_i       <= 4'h0;
    wb_we_i        <= 0;
    wb_stb_i       <= 0;
    wb_cyc_i       <= 0;
  endtask
    
//---------------------Task to Configure----------------------------//
  task configure();
    
    cfg_sdr_width <= 2'b00 ;     
    cfg_req_depth <= 2'h3;
    cfg_sdr_en <= 1'b1;
    cfg_sdr_mode_reg <= 13'h033;
    cfg_sdr_tras_d <= 4'h4;
    cfg_sdr_trp_d <= 4'h2;
    cfg_sdr_trcd_d <= 4'h2;
    cfg_sdr_cas <= 3'h3;
    cfg_sdr_trcar_d <= 4'h7;
    cfg_sdr_twr_d <= 4'h1;
    cfg_sdr_rfsh <= 12'h100;
    cfg_sdr_rfmax <= 3'h6;
  endtask

  //--------------------
  // data/address/burst length FIFO
  //--------------------
    int dfifo[$]; // data fifo
    int afifo[$]; // address  fifo
    int bfifo[$]; // Burst Length fifo
    reg [31:0] read_data;
    reg [31:0] ErrCnt;
    int k;
    reg [31:0] StartAddr;
    
    task burst_write;
      input [31:0] Address;
      input [7:0]  bl;
      int i;
  
      begin
        afifo.push_back(Address);
        bfifo.push_back(bl);

        @ (negedge sys_clk);
        $display("Write Address: %x, Burst Size: %d",Address,bl);

        for(i=0; i < bl; i++) begin
          wb_stb_i        = 1;
          wb_cyc_i        = 1;
          wb_we_i         = 1;
          wb_sel_i        = 4'b1111;
          wb_addr_i       = Address[31:2]+i;
          wb_dat_i        = $random & 32'hFFFFFFFF;
          dfifo.push_back(wb_dat_i);

          do begin
            @ (posedge sys_clk);
          end while(wb_ack_o == 1'b0);
            @ (negedge sys_clk);
   
          $display("time = %3d Status: Burst-No: %d  Write Address: %x  WriteData: %x ",$time,i,wb_addr_i,wb_dat_i);
        end
        wb_stb_i        = 0;
        wb_cyc_i        = 0;
        wb_we_i         = 'hx;
        wb_sel_i        = 'hx;
        wb_addr_i       = 'hx;
        wb_dat_i        = 'hx;
      end
    endtask

    task burst_read;
      reg [31:0] Address;
      reg [7:0]  bl;

      int i,j;
      reg [31:0]   exp_data;
      begin
  
       Address = afifo.pop_front(); 
       bl      = bfifo.pop_front(); 
       @ (negedge sys_clk);

          for(j=0; j < bl; j++) begin
             wb_stb_i        = 1;
             wb_cyc_i        = 1;
             wb_we_i         = 0;
             wb_addr_i       = Address[31:2]+j;

             exp_data        = dfifo.pop_front(); // Exptected Read Data
             do begin
                 @ (posedge sys_clk);
             end while(wb_ack_o == 1'b0);
             if(wb_dat_o !== exp_data) begin
                 $display("READ ERROR: Burst-No: %d Addr: %x Rxp: %x Exd: %x",j,wb_addr_i,wb_dat_o,exp_data);
                 ErrCnt = ErrCnt+1;
             end else begin
                 $display("READ STATUS: Burst-No: %d Addr: %x Rxd: %x",j,wb_addr_i,wb_dat_o);
             end 
             @ (negedge sdram_clk);
          end
       wb_stb_i        = 0;
       wb_cyc_i        = 0;
       wb_we_i         = 'hx;
       wb_addr_i       = 'hx;
    end
    endtask


    
endinterface