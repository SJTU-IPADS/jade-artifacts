import sys
with open(sys.argv[3], 'r') as file:
    lines = file.readlines()

for line in lines:
    parts = line.split(', ')
    
    if 'Throughput' in parts[1]:
        thoughput = float(parts[2])

    if 'INSERT' in parts[0]:
        if 'AverageLatency' in parts[1]:
            avg = float(parts[2])
        elif '90thPercentileLatency' in parts[1]:
            p90 = float(parts[2])
        elif '99thPercentileLatency' in parts[1]:
            p99 = float(parts[2])
        elif '99.9PercentileLatency' in parts[1]:
            p999 = float(parts[2])
        elif '99.99PercentileLatency' in parts[1]:
            p9999 = float(parts[2])

print(sys.argv[2], thoughput, p99, sep=", ")