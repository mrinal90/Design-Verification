
//`include "definesPkg.sv"
//import definesPkg::* ;				// Wildcard Import
`include "Assertions.sv"
`include "Testcase.sv"


module top;
bit HCLK;
bit HRESETn,wait_data;


///////////////INPUT CLOCK/////////////////


initial begin 
  HCLK=1'b1;
  forever #10 HCLK = ~HCLK;
end
  
initial begin
  HRESETn=1'b0;
  #500 HRESETn=1'b1;
end

///////////////INSTANCIATION///////////////
  AHBInterface AHBBUS (.HCLK(HCLK), .HRESETn(HRESETn));
  //AHBSlaveTop SlaveTop(.SlaveInterface(AHBBUS.Slave), .wait_slave_to_master(wait_data));
  AHBSlaveTop SlaveTop(.SlaveInterface(AHBBUS.Slave));
  //test T1(.InterfaceInstance(AHBBUS), .wait_data(wait_data));
  test T1(.InterfaceInstance(AHBBUS));
  monitor m1(.Bus(AHBBUS),.reset(HRESETn));


endmodule