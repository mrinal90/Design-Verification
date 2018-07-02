`include "sdramc_interface.sv"
`include "env.sv"


program testcase 
  ( 	
  interface tcifdriver, interface tcifmonitor);
    
    class test_bringup extends packet;
     
        constraint burst_length {
          mem_data.size() dist {8'd4:=1, 8'd5:=1};
        } 
      
        // Address Decodeing:
        //  with cfg_col bit configured as: 00
        //    <12 Bit Row> <2 Bit Bank> <8 Bit Column> <2'b00>
        constraint mem_address {
          mem_addr[1:0] == 10'b0;
          mem_addr[9:2] inside {[0:7]}; 
          mem_addr[11:10] inside {[1:4]};
          mem_addr[23:12] inside {[0:3]};
          mem_addr[31:24] == 8'b0;
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
      num_of_writes = $urandom_range(2,10);
  
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
      #15000;

      $finish;
    end
    
 final begin 
   $display("================================End of Display==================================");
 end


endprogram