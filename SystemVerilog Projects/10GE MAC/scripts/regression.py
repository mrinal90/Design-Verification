import  argparse
import subprocess
import re

parser = argparse.ArgumentParser()
parser.add_argument('-run',help="For running individual Testcases use: [loopback],[missing_sop_packet],[missing_eop_packet], [oversize_packet],[undersize_packet],\
[zero_ipg_packet] or for running regression on all testcases use : [all_tests] or for running clean script use: [clean] ",required=True)


#Testnames
t1="loopback"
t2="missing_eop_packet"
t3="missing_sop_packet"
t4="oversize_packet"
t5="undersize_packet"
t6="zero_ipg_packet"

#Runsim Commands
VCS_CMD = "vcs -full64 +vcs+lic+wait -sverilog -R -override_timescale=1ps/1ps +ntb_random_seed_automatic "
COV_OPTIONS     = "-cm line+cond+branch+fsm+tgl -cm path -lca -cm_log ./coverage.log -cm_dir ./COVERAGE "
DESIGN_FILES    = "../rtl/verilog/*.v +incdir+../rtl/include "
TESTBENCH_FILES = "../testbench/verilog/testbench.sv "

args = parser.parse_args()
if (args.run == "all_tests" or args.run == "clean"):
    testcases = [t1,t2,t3,t4,t5,t6]
else:
    testcases = args.run.split(",")

pass_count = 0;
fail_count = 0;
seed = 0;
data = dict()
test_pass = dict()
test_fail = dict()

if args.run != "clean":
    for testcase in testcases:
        path = ("/home/sf100212/SV_Project/testcases/" + testcase + "/")
#        print path #debugging
  
        #Executing Testcase
        subprocess.call(VCS_CMD + COV_OPTIONS + DESIGN_FILES + TESTBENCH_FILES + \
         "../testcases/"+ testcase + "/testcase.sv -l ../testcases/" + testcase + "/vcs.log", shell = True)
      
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
            if re.search('^TESTCASE:.*PASSED',line):
                pass_count = pass_count + 1
                test_pass[testcase] = "PASSED"
#               print line
            if re.search('^TESTCASE:.*FAILED',line):
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
if args.run == "clean":
    for testcase in testcases:
        subprocess.call("rm -rf ../testcases/"+testcase+"/vcs.log csrc simv* summary.log ucli.key vcdplus.vpd dump.vcd coverage.log COVERAGE.vdb urgReport", shell = True)

