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
    
    forever begin
      
      rcv_from_drv.get(pkt_from_drv);

      rcv_from_mon.get(pkt_from_mon);

      error=0;
      
      error = error_count(pkt_from_drv, pkt_from_mon);

      if(!error) begin 
        $display("time=%0t -------------------------SCOREBOARD: DATA VERIFIED-------------------------------\n",$time);
      end
      else $display("time=%0t ----------------------SCOREBOARD: ERROR IN DATA--------------------------\n",$time);
    
    end
    
  endtask
  
  function error_count(input packet driver, input packet monitor);
    
    int unsigned error;
    
    for (int i =0; i <= driver.mem_data.size(); i = i + 1) begin
      if (driver.mem_data[i] != monitor.mem_data[i]) begin
        $display("time=%0t SCOREBOARD: Data Mismatch  Expected = %h Measured = %h \n",$time, driver.mem_data[i], monitor.mem_data[i]);
        error++;
      end
    end
    
    return(error);
  endfunction
  
endclass
