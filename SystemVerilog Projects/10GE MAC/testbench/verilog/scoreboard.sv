
`include "/home/sf100212/SV_Project/testbench/verilog/coverage.sv" 

class scoreboard;

  mailbox rcv_from_drv;
  mailbox rcv_from_mon;
  int unsigned mismatches;
  
  coverage cov = new();
  
  function new (input mailbox drv2sb, input mailbox mon2sb);
    this.rcv_from_drv = drv2sb;
    this.rcv_from_mon = mon2sb;
  endfunction

//------------------Task to compare sent and receive packets-----------------------// 
  task compare(input mailbox rcv_from_drv, input mailbox rcv_from_mon);
    
   int unsigned error;
   packet pkt_from_drv;
   packet pkt_from_mon;
    
   forever begin 
 	
    error = 0; 
     
    rcv_from_drv.get(pkt_from_drv);
    
    rcv_from_mon.get(pkt_from_mon);
    
    error = loopback_mode(pkt_from_drv, pkt_from_mon);
     
     if(!error) begin 
       $display("time=%0t ------------SCOREBOARD: PACKET VERIFIED-------\n",$time);
     end
     else mismatches++;

    cov.collect_coverage(pkt_from_drv);
   end   
  endtask
//---------------------------------------------------------//   
  
  
  function loopback_mode(input packet driver, input packet monitor);
    int unsigned error;
    
    if (driver.dst_addr != monitor.dst_addr) begin
      $display("time=%0t SCOREBOARD: Destination Address Mismatch Expected = %h Measured = %h \n ",$time, driver.dst_addr, monitor.dst_addr);
       error++;
    end
    
    if (driver.src_addr != monitor.src_addr) begin
      $display("time=%0t SCOREBOARD: Source Address Mismatch  Expected = %h Measured = %h \n",$time, driver.src_addr, monitor.src_addr);
      error++;
    end
    
    if (driver.ether_type != monitor.ether_type) begin
      $display("time=%0t SCOREBOARD: Ether Type Mismatch  Expected = %h Measured = %h \n",$time, driver.ether_type, monitor.ether_type);
      error++;
    end
    
    if (driver.payload.size() != monitor.payload.size()) begin
      if (monitor.payload.size() != 8'h2e) begin
        $display("time=%0t SCOREBOARD: Payload Size Mismatch  Expected = %h Measured = %h \n",$time, driver.payload.size(), monitor.payload.size());
        error++;
      end
    end
    
    for (int i =0; i < driver.payload.size(); i = i + 1) begin
      if (driver.payload[i] != monitor.payload[i]) begin
        $display("time=%0t SCOREBOARD: Payload Byte Mismatch  Expected = %h Measured = %h \n",$time, driver.payload[i], monitor.payload[i]);
        error++;
      end
    end
  
    return(error);
  endfunction
 
endclass
