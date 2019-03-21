
/////////////PROGRAM BLOCK/////////////////
//`include "AHB_Interface.sv"
`include "packet.sv"
`define DEBUG

//program test(AHBInterface InterfaceInstance, output logic wait_data);
program test(AHBInterface InterfaceInstance);
	int rd,rd_wait;
    bit [31:0]data_burst_read [31:0];
    //bit [31:0]data_burst[31:0] = '{32'd59, 32'd61, 32'd63, 32'd65};
    bit [DATA_WIDTH-1:0] data_burst[31:0] = '{32'd59, 32'd61, 32'd63, 32'd65,32'd1,32'd2,32'd3,32'd4,32'd5,32'd6,32'd7,32'd8,32'd9,32'd10,32'd11,32'd12,32'd13,32'd14,32'd15,32'd16,32'd17,32'd18,32'd19,32'd20,32'd21,32'd22,32'd23,32'd24,32'd25,32'd26,32'd27,32'd28 } ;
  
  	
	PacketClass pktCls;
  
    initial begin
      //------------Creating Waveform-------//
      $dumpfile("dump.vcd"); $dumpvars();
    end
      
	initial begin
		pktCls = new();
		assert(pktCls.randomize());
		
		#800
      InterfaceInstance.write (32'h00000004,'1);
           
       //InterfaceInstance.write(pktCls.Address_rand,pktCls.Data_rand);
		#20;
      InterfaceInstance.read (32'h00000004, rd); 
		//InterfaceInstance.read (pktCls.Address_rand, rd);
		
		
		
		/////////////////////////////////READ ONLY ERROR CHECK//////////////////////////////////////////
		
		
		//`ifdef ERROR_INJECT
			InterfaceInstance.write (32'h2,'1);
			#20;
			InterfaceInstance.read (32'h2, rd);            
			#20;
		//`endif
		
      InterfaceInstance.burst_write (32'd5,0,0, data_burst);
		#20;
      InterfaceInstance.burst_read (32'd5,0,0, data_burst_read);
		#20;
		
		
		
		
		
		
		///////////////////////////////////////// TEST CASE FOR ZERO BUSY STATE ///////////////////////////////
		
		InterfaceInstance.burst_write (32'd5,4,0, data_burst);
		#20;
		InterfaceInstance.burst_read (32'd5,4,0, data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - BURST4  = %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] );
		`endif
		
		InterfaceInstance.burst_write (32'd10,8,0, data_burst);
		#20; 
		InterfaceInstance.burst_read (32'd10,8,0, data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - BURST8  = %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3], data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7] );
		`endif
		
		InterfaceInstance.burst_write (32'd25,16,0, data_burst);
		#20;
		InterfaceInstance.burst_read (32'd25,16,0, data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - BURST16 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3], data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7],
									data_burst_read[8], data_burst_read[9], data_burst_read[10], data_burst_read[11], data_burst_read[12], data_burst_read[13], data_burst_read[14], data_burst_read[15]);
		`endif
		
		
		
		//////////////////////////////////////// TEST CASE FOR SINGLE BUSY STATE ///////////////////////////////
		
		InterfaceInstance.burst_write (32'd5,4,1, data_burst);
		#20;
		InterfaceInstance.burst_read (32'd5,4,1, data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 1 BUSY - BURST4  = %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] );
		`endif
		
		InterfaceInstance.burst_write (32'd10,8,1, data_burst);
		#20; 
		InterfaceInstance.burst_read (32'd10,8,1, data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 1 BUSY - BURST8  = %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3], data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7] );
		`endif
		
		InterfaceInstance.burst_write (32'd25,16,1, data_burst);
		#20;
		InterfaceInstance.burst_read (32'd25,16,1, data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - BURST16 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3], data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7],
									data_burst_read[8], data_burst_read[9], data_burst_read[10], data_burst_read[11], data_burst_read[12], data_burst_read[13], data_burst_read[14], data_burst_read[15]);
		`endif
		
		
		
		
////////////////////////////////////////////// TEST CASE FOR DOUBLE BUSY STATES /////////////////////////////////////////////////
		
		InterfaceInstance.burst_write (32'd5,4,2, data_burst);
		#20;
		InterfaceInstance.burst_read (32'd5,4,2, data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - BURST4  = %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] );
		`endif
		
		InterfaceInstance.burst_write (32'd10,8,2, data_burst);
		#20; 
		InterfaceInstance.burst_read (32'd10,8,2, data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - BURST8  = %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3], data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7] );
		`endif
		
		InterfaceInstance.burst_write (32'd25,16,2, data_burst);
		#20;
		InterfaceInstance.burst_read (32'd25,16,2, data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - BURST16 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3], data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7],
									data_burst_read[8], data_burst_read[9], data_burst_read[10], data_burst_read[11], data_burst_read[12], data_burst_read[13], data_burst_read[14], data_burst_read[15]);
		`endif
		
		
		
////////////////////////////////////////////// TEST CASE FOR SINGLE, DOUBLE AND CONTINUOUS STATES ///////////////////////////////
		
		InterfaceInstance.burst_write (32'd5,4,1, data_burst);
		#20;
		InterfaceInstance.burst_read (32'd5,4,1, data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 1 BUSY - BURST4  = %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] );
		`endif
		
		InterfaceInstance.burst_write (32'd10,8,2, data_burst);
		#20; 
		InterfaceInstance.burst_read (32'd10,8,2, data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - BURST8  = %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3], data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7] );
		`endif
		
		InterfaceInstance.burst_write (32'd45,16,0, data_burst);
		#20;
		InterfaceInstance.burst_read (32'd45,16,0, data_burst_read);
		#20;
		`ifdef DEBUG		
		$display ("DATA - 0 BUSY - BURST16 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3], data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7],
									data_burst_read[8], data_burst_read[9], data_burst_read[10], data_burst_read[11], data_burst_read[12], data_burst_read[13], data_burst_read[14], data_burst_read[15]);
		`endif

		
		
////////////////////////////////////////////////////////WAIT STATES INITIATED BY THE SLAVE////////////////////////////////////////////////////////////			
		
		
		fork
			begin
			//wait_data = 1;
            InterfaceInstance.wait_data = 1;
			`ifdef DEBUG
			  //$display ("wait data = %d\n", wait_data);
              $display ("wait data = %d\n", InterfaceInstance.wait_data);  
			`endif
			#60;
			//wait_data = 0;
            //InterfaceInstance.wait_data = 0;
			#20;
			`ifdef DEBUG
			//$display ("wait data = %d\n", wait_data);
              $display ("wait data = %d\n", InterfaceInstance.wait_data);
			`endif
			end
			
			begin
			#60;
              InterfaceInstance.wait_data = 0;
              #40
			InterfaceInstance.read (32'h00000004, rd_wait);
			end
        join
        
	
	
		
		`ifdef DEBUG
		$display ("DATA @ address 32'h00000004 with wait states installed by Slave = %h\n", rd_wait);
		`endif
		
		
////////////////////////////////////////////BASIC READ AND WRITE - SLAVE 2///////////////////////////////////////////?/////		
		
		InterfaceInstance.write (32'h00000706, '1);
		//InterfaceInstance.write(pktCls.Address_rand,pktCls.Data_rand);
		#20;
		InterfaceInstance.read (32'h00000706, rd); 

		`ifdef DEBUG
		$display ("DATA @ address 706h - SLAVE 2 = %h\n", rd);
		`endif

		

////////////////////////////////////////////BASIC 4 BEAT BURST READ AND WRITE - SLAVE 2///////////////////////////////////////////?/////		
		
		
		InterfaceInstance.burst_write (32'h0700,4, 2,data_burst);
		
		#20;
		InterfaceInstance.burst_read (32'h0700,4, 2,data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - 4 BEAT BURST - SLAVE 2  = %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] );
		`endif
		
		
		
		
		
////////////////////////////////////////////BASIC 8 BEAT BEAT BURST READ AND WRITE - SLAVE 1//////////////////////////////////////////////
		
		InterfaceInstance.burst_write (32'h0100,8, 1,data_burst);
		
		#20;
		InterfaceInstance.burst_read (32'h0100,8, 1,data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 1 BUSY - 8 BEAT BURST - SLAVE 1 = %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] , data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7] );
		`endif
		

		
////////////////////////////////////////////BASIC 16 BEAT 1 BUSY BURST READ AND WRITE - SLAVE 1//////////////////////////////////////////////
		
		
		InterfaceInstance.burst_write (32'h0100,16, 1,data_burst);
		
		#20;
		InterfaceInstance.burst_read (32'h0100,16, 1,data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 1 BUSY - 16 BEAT BURST - SLAVE 1 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] , data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7], data_burst_read[8], data_burst_read[9], data_burst_read[10], data_burst_read[11] , data_burst_read[12], data_burst_read[13], data_burst_read[14], data_burst_read[15] );
		`endif
	
	
	
////////////////////////////////////////////BASIC 16 BEAT 2 BUSY BURST READ AND WRITE - SLAVE 1//////////////////////////////////////////////
		
		
		InterfaceInstance.burst_write (32'h0150,16, 2,data_burst);
		
		#20;
		InterfaceInstance.burst_read (32'h0150,16, 2,data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - 16 BEAT BURST - SLAVE 1 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] , data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7], data_burst_read[8], data_burst_read[9], data_burst_read[10], data_burst_read[11] , data_burst_read[12], data_burst_read[13], data_burst_read[14], data_burst_read[15] );
		`endif	
		
		
		
////////////////////////////////////////////BASIC 8 BEAT 1 BUSY BURST READ AND WRITE - SLAVE 1//////////////////////////////////////////////
		
		InterfaceInstance.burst_write (32'h0180,8, 1,data_burst);
		
		#20;
		InterfaceInstance.burst_read (32'h0180,8, 1,data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 1 BUSY - 8 BEAT BURST - SLAVE 1 = %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] , data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7] );
		`endif		
		
		
		
////////////////////////////////////////////BASIC 4 BEAT BURST READ AND WRITE - SLAVE 2///////////////////////////////////////////?/////		
		
		
		InterfaceInstance.burst_write (32'h0730,4, 1,data_burst);
		
		#20;
		InterfaceInstance.burst_read (32'h0730,4, 1,data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 1 BUSY - 4 BEAT BURST - SLAVE 2  = %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] );
		`endif
		
				
	


////////////////////////////////////////////BASIC 4 BEAT BURST READ AND WRITE - SLAVE 2///////////////////////////////////////////?/////		
		
		
		InterfaceInstance.burst_write (32'h0760,4, 2,data_burst);
		
		#20;
		InterfaceInstance.burst_read (32'h0760,4, 2,data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - 4 BEAT BURST - SLAVE 2  = %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] );
		`endif	
		
		
		
////////////////////////////////////////////BASIC 16 BEAT 2 BUSY BURST READ AND WRITE - SLAVE 2//////////////////////////////////////////////
		
		
		InterfaceInstance.burst_write (32'h0780,16, 1,data_burst);
		
		#20;
		InterfaceInstance.burst_read (32'h0780,16, 1,data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 2 BUSY - 16 BEAT BURST - SLAVE 2 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] , data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7], data_burst_read[8], data_burst_read[9], data_burst_read[10], data_burst_read[11] , data_burst_read[12], data_burst_read[13], data_burst_read[14], data_burst_read[15] );
		`endif	
		
		
		
////////////////////////////////////////////BASIC 16 BEAT 0 BUSY BURST READ AND WRITE - SLAVE 2//////////////////////////////////////////////
		
		
		InterfaceInstance.burst_write (32'h725,16, 0,data_burst);
		
		#20;
		InterfaceInstance.burst_read (32'h725,16, 0,data_burst_read);
		#20;
		`ifdef DEBUG
		$display ("DATA - 0 BUSY - 16 BEAT BURST - SLAVE 2 = %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n", data_burst_read[0], data_burst_read[1], data_burst_read[2], data_burst_read[3] , data_burst_read[4], data_burst_read[5], data_burst_read[6], data_burst_read[7], data_burst_read[8], data_burst_read[9], data_burst_read[10], data_burst_read[11] , data_burst_read[12], data_burst_read[13], data_burst_read[14], data_burst_read[15] );
		`endif			
		
		
		/*
////////////////////////////////////////////OUT OF BOUNDS CHECK//////////////////////////////////////////////////
		
		InterfaceInstance.burst_write (32'h801,4,0, data_burst);
		#20;
		InterfaceInstance.burst_read (32'h801,4,0, data_burst_read);
		#20;
				
		*/
		
		//$stop;
        
    end
endprogram
