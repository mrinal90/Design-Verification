class monitor;
  
  virtual xge_interface mi;
  mailbox mon2sb;
  
  function new(input virtual xge_interface mif, input mailbox mon2sb);
    this.mi= mif;
    this.mon2sb =mon2sb;
  endfunction
  
  task collect_data();
  endtask
  
endclass
