class packet;
  
  //RTL signal
  rand bit [31:0] src_addr;
  rand bit [31:0] src_data;
  rand bit [31:0] dst_addr;
  rand bit [31:0] dst_data;
 
  function void print(string command);
  endfunction
  
endclass
