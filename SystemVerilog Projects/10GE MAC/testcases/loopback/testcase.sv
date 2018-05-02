`include "timescale.v"
`include "/home/sf100212/SV_Project/testbench/verilog/xge_interface.sv"
`include "/home/sf100212/SV_Project/testbench/verilog/env.sv"


program testcase 
  ( 
  input reg					clk_156m25,  
  input reg                   clk_xgmii_rx,         
    input  reg                  clk_xgmii_tx,  
    interface tcifdriver, interface tcifmonitor);

      class loopback_testcase extends packet;
        constraint legal_payload {
          payload.size() dist {50:=2, 58:=2, 66:=2, 74:=2, 82:=2};
        }
        
        constraint legal_ipg {
          ipg == 32'd12;
        }
      endclass
          
//------------Declaring Variables-------//
  env env0;
  loopback_testcase testpacket;
  int num_packet;
      
 initial begin
 
//------------Initializing Variables-------//
   tcifdriver.init(); 
   num_packet = $urandom_range(6,10);
   env0=new(tcifdriver,tcifmonitor);  
  
//------------Testcase packet with constraint replacement-------//
   testpacket = new();
   env0.drv.ethernet = testpacket;
   
   tcifdriver.WaitNS(50);
   
//------------Creating Waveform-------//
   $dumpfile("dump.vcd"); $dumpvars();
   
//------------Send, Receive and Compare packets-------//
   env0.run(4);
   tcifdriver.WaitNS(5000);
   
   $finish;
   
 end
    
  final begin 
    int unsigned    num_of_errors;
    num_of_errors  =   env0.sb.mismatches;
   
    if ( num_of_errors==0 )
      $display("TESTCASE: ---------------------- PASSED -----------------------\n");
    else
      $display("TESTCASE: ---------------------- FAILED -----------------------\n");

    $display("================================End of Display==================================");
  end


endprogram
  
  
  
  
