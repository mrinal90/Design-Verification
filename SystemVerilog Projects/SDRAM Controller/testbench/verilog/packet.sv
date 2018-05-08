class packet;
  
  //RTL signal
  rand bit [31:0] mem_addr;
  rand bit [31:0] mem_data;
  
  //Non-RTL Signal
   
 
  //Constraint List
  
  //Print Function
  function void print(string command);
    
    $display("Status: %s Address: %x  %s Data: %x ",command, mem_addr, command, mem_data);
    
  endfunction
  
endclass
