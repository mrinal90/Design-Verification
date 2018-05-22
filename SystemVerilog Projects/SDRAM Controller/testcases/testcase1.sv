`include "sdramc_interface.sv"
`include "env.sv"


program testcase 
  ( 	
  interface tcifdriver, interface tcifmonitor);
    
    class test_bringup extends packet;
        constraint legal_burst_length {
          burst_length == 8'd4;
        }
        
        constraint mem_address {
          mem_addr == 32'h4_0000;
        }
     endclass
    
    env env0;
    test_bringup testpacket;
    int num_of_writes;
    
    initial begin
 
    //-----------------Waveform Dump-----------//
   
      $dumpfile("dump.vcd"); $dumpvars();
   
    //------------Initializing Variables-------//
   
      tcifdriver.configure();
      tcifdriver.init(); 
      num_of_writes = $urandom_range(2,5);
  
      env0 = new(tcifdriver,tcifmonitor);
   
   //------------Send, Receive and Verify Data-------//
      testpacket = new();
      env0.drv.ethernet = testpacket;
      #1000;
      wait(tcifdriver.sdr_init_done == 1);

      #1000;
      env0.run(num_of_writes);
/*  
  $display("-------------------------------------- ");
  $display(" Case-1: Single Write/Read Case        ");
  $display("-------------------------------------- ");
    begin
      tcifdriver.burst_write(32'h0000_0FF0,8'h8);
    end
    #5000;
    begin
      tcifdriver.burst_read();
    end
*/
      #10000;

      $finish;
    end
    
 final begin 
   $display("================================End of Display==================================");
 end


endprogram