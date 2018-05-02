class scoreboard;
  
  mailbox rcv_from_drv;
  mailbox rcv_from_mon;
  int unsigned mismatches;
  
  function new (input mailbox drv2sb, input mailbox mon2sb);
    this.rcv_from_drv = drv2sb;
    this.rcv_from_mon = mon2sb;
  endfunction
  
  task compare_data();
  endtask
  
endclass
