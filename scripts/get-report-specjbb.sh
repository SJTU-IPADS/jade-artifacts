# rm -f ../results/specjbb/report.csv
REPORT_FILE="../results/specjbb/report.csv"
RT_FILE="../results/specjbb/rt_curve.csv "
rm $REPORT_FILE $RT_FILE -f

echo "heap-size,GC-name,critical-jOPS,max-jOPS" > $REPORT_FILE
echo "heap-size,GC-name,jOPS, p99" > $RT_FILE

for path in $(find ../results/specjbb | grep "overall-throughput-rt.txt")
do
    echo $path
    python3 parse-specjbb.py $path $REPORT_FILE $RT_FILE
done