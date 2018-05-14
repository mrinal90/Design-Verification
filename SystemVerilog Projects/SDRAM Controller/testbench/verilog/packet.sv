class packet;
  
  //RTL signal
  rand bit [31:0] mem_addr;
  rand bit [31:0] mem_data;
  
  //Non-RTL Signal
  rand bit [7:0] burst_length; 
 
  //Constraint List
  
  //Print Function
  function void print(string command);
    
    $display("Status: %s Address: %x Burst Size: %x %s Data: %x ",command, mem_addr, burst_length, command, mem_data);
    
  endfunction
  
endclass
