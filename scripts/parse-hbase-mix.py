import sys

with open(sys.argv[1], 'r') as file:
    throughtput = file.read().split("\n")[1].split(", ")[-1]
    # print(throughtput)

latency_list = []
with open(sys.argv[2], 'r') as file:
    lines = file.read().split("\n")
    for line in lines:
        latency = line.split(",")[-1]
        try:
            int(latency)
            latency_list.append(int(latency))
            # print(latency)
        except ValueError:
            continue

# print(latency_list)
latency_list.sort() 
n = len(latency_list)
index = int(n * 0.99)  
# print(latency_list)
# print(index)
print(sys.argv[3], throughtput, latency_list[index], sep=", ")
