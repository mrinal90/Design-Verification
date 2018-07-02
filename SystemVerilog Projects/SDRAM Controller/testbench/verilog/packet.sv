class packet;
  
  //RTL signal
  rand bit [31:0] mem_addr;
  rand bit [31:0] mem_data[]; 
 
  //Constraint List
  
  //Print Function
  function void print(string command);
    
    if(command=="WRITE") begin
      
      $display("Time = %3d Status: %s Address: %x Burst Size: %2d ", $time, command, mem_addr, mem_data.size());
     
      for (int i =0; i < mem_data.size(); i = i + 1) begin
        $display("Time = %3d Status: %s Burst_Address: %x Burst_%s #:%2d %s_Data: %x ", $time, command, mem_addr[31:2] + i, command, i+1, command, mem_data[i]);
      end
      
      $display("--------------------------------WRITE COMPLETED-------------------------------\n");
      
    end
    
    if(command=="READ") begin
      
      for (int i =0; i < mem_data.size(); i = i + 1) begin
        $display("Time = %3d Status: %s Burst_Address: %x Burst_%s #:%2d %s_Data: %x ", $time, command, mem_addr - mem_data.size() +1+i , command, i+1, command, mem_data[i]);
      end
      
      $display("--------------------------------READ COMPLETED-------------------------------\n");
    end
    
  endfunction

  
endclass
