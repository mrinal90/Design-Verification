class driver;
  
  packet ethernet;
  virtual xge_interface vi;
  mailbox drv2sb;
  
  function new(input virtual xge_interface vif, input mailbox drv2sb);
    this.vi= vif;
    this.drv2sb= drv2sb;
    ethernet =new();
  endfunction
  
  task send_data();
  endtask
  
endclass
  
  