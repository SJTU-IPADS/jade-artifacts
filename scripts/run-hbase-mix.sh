
export JAVA_HOME="../jdk/jdk-11"
export OUTPUT_DIR="../results/hbase"
export HBASE_HOME="../hbase-2.4.14"
export YCSB_HOME="../ycsb-hbase2-binding-0.18.0-SNAPSHOT"
heap=("4400m" "2200m" "1650m")
gc=("g1" "zgc" "shen" "jade" "genz" "genshen")

mkdir -p $OUTPUT_DIR 
for heap_size in ${heap[@]}
do
    REPORT_FILE=$OUTPUT_DIR/$heap_size-mix.csv
    echo "gc-type,thoughput,p99" >> $REPORT_FILE
    for gc_name in ${gc[@]}
    do  
        mkdir $OUTPUT_DIR/logs-mix/$gc_name/$heap_size -p
        for((thoughtput=400;thoughtput<=2000;thoughtput+=200))
        do
            echo thoughtput: $thoughtput
            # restart hbase
            sh $HBASE_HOME/bin/stop-hbase.sh
            rm -rf ../results/hbase/hbase-data ../results/hbase/zookeeper-data
            sh $HBASE_HOME/bin/start-hbase.sh $gc_name $heap_size
            # clear db
            sh $HBASE_HOME/recreate_db.sh
            # restart hbase
            sh $HBASE_HOME/bin/restart-hbase.sh $gc_name $heap_size
            # load data
            numactl -C 32-63 -m 0 $YCSB_HOME/bin/ycsb load hbase2 -P $YCSB_HOME/workloads/workload-mix-full -threads 15 -s -p exportfile=$OUTPUT_DIR/logs-mix/hbase-ycsb-target-run.out -p columnfamily=cf -p hdrhistogram.percentiles=90,99,99.9,99.99 -p maxexecutiontime=600 > /dev/null
            # run warm up
            numactl -C 32-63 -m 0 $YCSB_HOME/bin/ycsb run hbase2 -P $YCSB_HOME/workloads/workload-mix-full -threads 15 -s -p exportfile=$OUTPUT_DIR/logs-mix/hbase-ycsb-target-run.out -p columnfamily=cf -p hdrhistogram.percentiles=90,99,99.9,99.99 -p maxexecutiontime=600 > /dev/null
            # run actual
            numactl -C 32-63 -m 0 $YCSB_HOME/bin/ycsb run hbase2 -P $YCSB_HOME/workloads/workload-mix-full -threads 15 -target $thoughtput -s -p exportfile=$OUTPUT_DIR/logs-mix/$gc_name/$heap_size/$thoughtput.log -p columnfamily=cf -p hdrhistogram.percentiles=90,99,99.9,99.99 -p maxexecutiontime=60  > $OUTPUT_DIR/logs-mix/$gc_name/$heap_size/$thoughtput.txt

            python3 parse-hbase-mix.py $OUTPUT_DIR/logs-mix/$gc_name/$heap_size/$thoughtput.log $OUTPUT_DIR/logs-mix/$gc_name/$heap_size/$thoughtput.txt $gc_name >>  $REPORT_FILE
        done
    done
done
