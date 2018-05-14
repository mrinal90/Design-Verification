class scoreboard;
  
  mailbox rcv_from_drv;
  mailbox rcv_from_mon;
  int unsigned mismatches;
  
  function new (input mailbox drv2sb, input mailbox mon2sb);
    this.rcv_from_drv = drv2sb;
    this.rcv_from_mon = mon2sb;
  endfunction
  
  task compare_data(input mailbox rcv_from_drv, input mailbox rcv_from_mon);
    
   int unsigned error;
   packet pkt_from_drv;
   packet pkt_from_mon;
    
   rcv_from_drv.get(pkt_from_drv);
    
   rcv_from_mon.get(pkt_from_mon);
    
    error=0;
    
    if (pkt_from_drv.mem_data != pkt_from_mon.mem_data) begin
      $display("time=%0t SCOREBOARD: Data Mismatch  Expected = %h Measured = %h \n",$time, pkt_from_drv.mem_data, pkt_from_mon.mem_data);
      error++;
    end
    
    if(!error) begin 
      $display("time=%0t -------------------------SCOREBOARD: DATA VERIFIED-------------------------------\n",$time);
    end
    else $display("time=%0t ----------------------SCOREBOARD: ERROR IN DATA--------------------------\n",$time);
    
    
  endtask
  
endclass
