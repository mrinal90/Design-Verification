import  argparse
import subprocess
import re

parser = argparse.ArgumentParser(formatter_class=argparse.RawDescriptionHelpFormatter,epilog=('''\
LIST OF TEST_NAME
----------------------------------------
1) loopback
2) missing_eop
3) missing_sop
4) oversize
5) undersize
6) zero_ipg                             
----------------------------------------
For example, Running loopback test, type: python regression.py -run loopback
'''))
parser.add_argument('-run', dest= "test_name",help="For running individual Testcases see the names in  below tabel or  for running regression on all testcases use : [all_tests] or  for running clean script use: [clean] ",required=True)


#Testnames
t1="loopback"
t2="missing_eop"
t3="missing_sop"
t4="oversize"
t5="undersize"
t6="zero_ipg"

#Runsim Commands
VCS_CMD = "vcs -timescale=1ps/1ps -full64 -R -sverilog -ntb_opts uvm-1.1 -debug_pp +ntb_random_seed_automatic "
#COV_OPTIONS     = "-cm line+cond+branch+fsm+tgl -cm path -lca -cm_log ./coverage.log -cm_dir ./COVERAGE "
DESIGN_FILES    = "+incdir+../rtl/include ../rtl/verilog/*.v "
TESTBENCH_FILES = "+incdir+../testbench ../testbench/verilog/testcase.sv ../testbench/verilog/testbench.sv ../testbench/verilog/xge_interface.sv "

args = parser.parse_args()
if (args.test_name == "all_tests" or args.test_name == "clean"):
    testcases = [t1,t2,t3,t4,t5,t6]
else:
    testcases = args.test_name.split(",")

pass_count = 0;
fail_count = 0;
seed = 0;
data = dict()
test_pass = dict()
test_fail = dict()

if args.test_name != "clean":
    for testcase in testcases:
        path = ("../testcases/" + testcase + "/")
#        print path #debugging
  
        #Executing Testcase
        subprocess.call(VCS_CMD + DESIGN_FILES + TESTBENCH_FILES + \
        "-l ../testcases/" + testcase + "/vcs.log " "+UVM_TESTNAME=test_" + testcase  +" +UVM_VERBOSITY=HIGH" , shell = True)
      
        #Generating summary
        file_name = (path + "vcs.log")
        #file_name = (path + "vcs_log.txt")   #Debugging
        try:
            inp = open(file_name,"r")
        except:
            print("File not present")
            exit()

        for line in inp:
            line = line.rstrip()
            if re.search('^UVM_INFO.*PASS',line):
                pass_count = pass_count + 1
                test_pass[testcase] = "PASSED"
#                print line
            if re.search('^UVM_FATAL.*FAIL',line):
                fail_count = fail_count + 1
                test_fail[testcase] = "FAILED"
#                print line
            seed = re.findall('^NOTE:.*: ([0-9]+)',line)
            if len(seed) > 0:
	        data[testcase] = seed

    #Print summary
    print ""
    print ""
    print ""
    print ""
    print "=====================================================SUMMARY============================================"
    print "Number of passed tests: ",pass_count,test_pass.keys() 
    print "Number of failed tests: ",fail_count,test_fail.keys()
    print "Total number of testcases: ",pass_count+fail_count
    print "Random Seed used are:"
    print data
    print "========================================================================================================="
    inp.close()

#Clean
if args.test_name == "clean":
    for testcase in testcases:
        subprocess.call("rm -rf ../testcases/"+testcase+"/vcs.log csrc simv* summary.log ucli.key vcdplus.vpd dump.vcd coverage.log COVERAGE.vdb urgReport", shell = True)

