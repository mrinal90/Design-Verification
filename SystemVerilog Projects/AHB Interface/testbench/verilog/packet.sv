/*Packet Class*/
class PacketClass;
  
  rand bit [31:0] Address_rand,Data_rand;
  
  constraint c {	
    Address_rand >  32'h00000000;
    Address_rand    <  32'h00000400;
               }
  
endclass