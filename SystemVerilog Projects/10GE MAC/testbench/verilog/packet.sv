class packet;
  //RTL signal
  rand bit [63:0] data;
  rand bit [47:0] src_addr;    //6 bytes
  rand bit [47:0] dst_addr;    //6 bytes
  rand bit [15:0] ether_type;  //2 bytes
  rand bit [7:0]  payload[];
  rand bit [31:0] ipg;             
  
  //Non RTL signal
  rand bit sop_flag;
  rand bit eop_flag;
  static bit [15:0] pktid;
  
  constraint legal_payload{
    payload.size() inside {[46:1500]};
  }
  
  constraint allowed_type{
    this.ether_type == 16'h0800 ||
    this.ether_type == 16'h0806 ||
    this.ether_type == 16'h86DD;
  }

  constraint legal_ipg{
    ipg inside {[10:50]};
  }
  
  constraint sop_bit{
    this.sop_flag== 1'b1;
  }
  
  constraint eop_bit{
    this.eop_flag== 1'b1;
  }
  
  function void print(string command);
    $display("time = %3d:  Packet%3d %s: DST ADDR =%h, SRC ADDR =%h, ETHER TYPE =%h, PAYLOAD SIZE =%h\n ",$time, pktid, command, dst_addr, src_addr, ether_type, payload.size());    
    
    for (int i =0; i <= payload.size()/8; i = i + 1) begin
      $display("time = %3d:  Packet %s: payload=%h%h%h%h_%h%h%h%h", $time, command, payload[8*i], payload[8*i+1], payload[8*i+2], payload[8*i+3], payload[8*i+4], payload[8*i+5],payload[8*i+6], payload[8*i+7]);
    end
  endfunction

  function increase_pktid();
    this.pktid++;
  endfunction
 
endclass
  
 
