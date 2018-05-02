class packet extends uvm_sequence_item;
  
  //RTL signal
  rand bit [47:0] src_addr;    //6 bytes
  rand bit [47:0] dst_addr;    //6 bytes
  rand bit [15:0] ether_type;  //2 bytes
  rand bit [7:0]  payload[];
  rand bit [31:0] ipg;

  //Non RTL signal
  rand bit sop_flag;
  rand bit eop_flag;
  static bit [15:0] pktid;
  
  `uvm_object_utils_begin(packet)
    `uvm_field_int (src_addr, UVM_ALL_ON)
    `uvm_field_int (dst_addr, UVM_ALL_ON)
    `uvm_field_int (ether_type, UVM_ALL_ON)
    `uvm_field_array_int (payload, UVM_ALL_ON)
    `uvm_field_int (ipg, UVM_ALL_ON)
  `uvm_object_utils_end

  function new (input string name ="FootSoldier");
    super.new(name);
    `uvm_info("PACKET_CLASS_BASE", $sformatf("Hierarchy:%m"), UVM_HIGH)
  endfunction

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
endclass


//====================================LOOPBACK PACKET===================================//

class packet_loopback extends packet;

   `uvm_object_utils(packet_loopback)

  constraint legal_payload {
          payload.size() dist {50:=2, 58:=2, 66:=2, 74:=2, 82:=2};
        }

   constraint legal_ipg {
          ipg == 32'd12;
        }

   function new(input string name="LOOPBACK Packet");
     super.new(name);
     `uvm_info("Packet_Loopback CLASS",$sformatf("Hierarchy:%m"),UVM_HIGH);

   endfunction

endclass

//====================================MISSING SOP PACKET===================================//


class packet_missing_sop extends packet;

   `uvm_object_utils(packet_missing_sop)

  constraint legal_payload {
          payload.size() dist {50:=2, 58:=2, 66:=2, 74:=2, 82:=2};
        }

   constraint legal_ipg {
          ipg == 32'd12;
        }
   constraint sop_bit{
          sop_flag dist {1 := 8, 0 := 2};
        }

   function new(input string name="MISSING SOP PACKET");
     super.new(name);
     `uvm_info("Packet_Missing_Sop CLASS",$sformatf("Hierarchy:%m"),UVM_HIGH);

   endfunction

endclass

//====================================MISSING SOP PACKET===================================//


class packet_missing_eop extends packet;

   `uvm_object_utils(packet_missing_eop)

  constraint legal_payload {
          payload.size() dist {50:=2, 58:=2, 66:=2, 74:=2, 82:=2};
        }

   constraint legal_ipg {
          ipg == 32'd12;
        }
   constraint eop_bit{
          eop_flag dist {1 := 8, 0 := 2};
        }

   function new(input string name="MISSING EOP PACKET");
     super.new(name);
     `uvm_info("Packet_Missing_Eop CLASS",$sformatf("Hierarchy:%m"),UVM_HIGH);

   endfunction

endclass

//====================================OVERSIZE PACKET===================================//


class packet_oversize extends packet;

   `uvm_object_utils(packet_oversize)

   constraint legal_payload {
          payload.size() dist {1602:=2, 58:=2, 66:=2, 74:=2, 82:=2};
        }

   constraint legal_ipg {
          ipg == 32'd12;
        }

   function new(input string name="OVERSIZE PACKET");
     super.new(name);
     `uvm_info("Packet_Oversize CLASS",$sformatf("Hierarchy:%m"),UVM_HIGH);

   endfunction

endclass

//====================================UNDERSIZE PACKET===================================//

class packet_undersize extends packet;

   `uvm_object_utils(packet_undersize)

   constraint legal_payload {
          payload.size() dist {34:=2, 42:=2, 66:=2, 74:=2, 82:=2};
        }

   constraint legal_ipg {
          ipg == 32'd12;
        }

   function new(input string name="UNDERSIZE PACKET");
     super.new(name);
     `uvm_info("Packet_Undersize CLASS",$sformatf("Hierarchy:%m"),UVM_HIGH);

   endfunction

endclass


//====================================ZERO IPG PACKET===================================//


class packet_zero_ipg extends packet;

   `uvm_object_utils(packet_zero_ipg)

   constraint legal_payload {
          payload.size() dist {50:=2, 58:=2, 66:=2, 74:=2, 82:=2};
        }

   constraint legal_ipg {
          ipg == 32'd0;
        }

   function new(input string name="ZERO IPG PACKET");
     super.new(name);
     `uvm_info("Packet_Zero_IPG CLASS",$sformatf("Hierarchy:%m"),UVM_HIGH);

   endfunction

endclass



