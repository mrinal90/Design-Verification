program testcase();
   import uvm_pkg::*;

   `include "../../testbench/verilog/testclass.sv"
   `include "../../testcases/loopback/test_loopback.sv"
   `include "../../testcases/missing_eop/test_missing_eop.sv"
   `include "../../testcases/missing_sop/test_missing_sop.sv"
   `include "../../testcases/oversize/test_oversize.sv"
   `include "../../testcases/undersize/test_undersize.sv"
   `include "../../testcases/zero_ipg/test_zero_ipg.sv"
   initial begin
      run_test();
   end
endprogram
