import re
import sys

def process_log_file(file_path):
    bench_name = file_path.split("/")[-2]
    gc_name = file_path.split("/")[-1].split("_")[1]
    if(gc_name == "gen"):
        gc_name += file_path.split("/")[-1].split("_")[2]
    heap_name = file_path.split("/")[-1].split("_")[-1][:-4]
    
    with open(file_path, 'r') as file:
        text = file.read()
        pattern = r'in (\d+) msec'
        matches = re.findall(pattern, text)
        if(len(matches)==6):
            numbers = [int(num) for num in matches]
            average = sum(numbers[1:6]) / 5
            print(bench_name, gc_name, heap_name, matches[-1], sep = ", ")
        else:
            print(bench_name, gc_name, heap_name, "N/A", sep = ", ")

if len(sys.argv) != 2:
    print("require argv=2")
    sys.exit(1)

arg1 = sys.argv[1]
file_path = arg1
process_log_file(file_path)