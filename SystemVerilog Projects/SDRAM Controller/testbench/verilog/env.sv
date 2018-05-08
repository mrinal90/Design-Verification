`include "packet.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class env;
  
  driver drv;
  monitor mon;
  scoreboard sb;
  mailbox drv2sb;
  mailbox mon2sb;
  
  virtual sdramc_interface vi;
  virtual sdramc_interface mi;
    
  function new(input virtual sdramc_interface vif,
              input virtual sdramc_interface mif);
    
      drv2sb = new();
      mon2sb = new();
    
      this.vi= vif;
    drv = new(vif, drv2sb);
    
      this.mi= mif;
    mon = new(mif, mon2sb);
    
    sb = new(drv2sb,mon2sb);
    
  endfunction
  
//------------Making hierarchical calls to driver, monitor and scoreboard-------// 
  task run(int addr =32'h4_000);
    
//    fork        
    $display("time = %3d: Writing data ... ",$time);
    drv.send_data(addr);
    $display("time = %3d: Reading Data ... ",$time);
    mon.collect_data(addr);
//    $display("time = %3d: Comparing Data ... ",$time);
//    sb.compare_data(drv2sb,mon2sb);  
//    join     
 
  endtask
//---------------------------------------------------------//  
  
endclass
    
    
