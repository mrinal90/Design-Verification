`include "sdramc_interface.sv"
`include "env.sv"


program testcase 
  ( 	
  interface tcifdriver, interface tcifmonitor);
        
 env env0;
    
 initial begin
 
   //-----------------Waveform Dump-----------//
   
   $dumpfile("dump.vcd"); $dumpvars();
   
   //------------Initializing Variables-------//
   
   tcifdriver.configure();
   tcifdriver.init(); 
  
   env0 = new(tcifdriver,tcifmonitor);
   
   //------------Send, Receive and Verify Data-------//
   
   #1000;
   wait(tcifdriver.sdr_init_done == 1);

   #1000;
   env0.run();
/*  
  $display("-------------------------------------- ");
  $display(" Case-1: Single Write/Read Case        ");
  $display("-------------------------------------- ");
    begin
      tcifdriver.burst_write(32'h4_0000,8'h4);
    end
    #5000;
    begin
      tcifdriver.burst_read();
    end
  #10000;
*/ 
  $finish;
   
 end
    
 final begin 
   $display("================================End of Display==================================");
 end


endprogram