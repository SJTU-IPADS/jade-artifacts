import re
import sys
import math

log_path = sys.argv[1]
report_path = sys.argv[2]
rt_path = sys.argv[3]
log_file=open(log_path,"r")
report_file=open(report_path, "a")
rt_file=open(rt_path, "a")

gc_name = log_path.split("/")[3].split("-")[0]
heap_name = log_path.split("/")[3].split("-")[1]


lines = log_file.read().split("\n")
for line in lines:
    if("critical-jOPS" in line):
        cjops=line.split(";")[2]
    if("max-jOPS" in line):
        mjops=line.split(";")[2]
    try:
        jops=float(line.split(";")[0])
        p99=float(line.split(";")[5])
        if(not math.isnan(p99)):
            print(heap_name, gc_name, jops, p99, sep=",", file=rt_file)
    except ValueError:
        jops=0
        p99=0
print(heap_name, gc_name, cjops, mjops, sep=",", file=report_file)