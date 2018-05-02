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
  
  virtual xge_interface vi;
  virtual xge_interface mi;
    
  function new(input virtual xge_interface vif,
              input virtual xge_interface mif);
    
      drv2sb = new();
      mon2sb = new();
    
      this.vi= vif;
    drv = new(vif, drv2sb);
    
      this.mi= mif;
    mon = new(mif, mon2sb);
    
    sb = new(drv2sb,mon2sb);
    
  endfunction
  
//------------Making hierarchical calls to driver, monitor and scoreboard-------// 
  task run(int num_packet =4);
    
//     fork        
    $display("time = %3d: Sending packet ... ",$time);
    drv.send_data(num_packet);
//       $display("time = %3d: Collecting packet ... ",$time);
//        mon.collect_packet();
//        $display("time = %3d: Comparing packet ... ",$time);
//        sb.compare(drv2sb,mon2sb);  
//     join_any     
 
  endtask
//---------------------------------------------------------//  
  
endclass
    
    
