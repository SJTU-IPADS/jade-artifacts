

DACAPO_PATH="../dacapo/dacapo-evaluation-git-b00bfa9.jar"
LOG_PATH="../results/dacapo/"

BENCH_NAMES=("cassandra" "h2" "lusearch" "tomcat" "avrora" "batik" "biojava" "eclipse" "fop" "graphchi" "h2o" "jython" "luindex" "pmd" "sunflow" "xalan" "zxing")
BENCH_HEAP=(263 1191 53 71 7  1076 191 534 73 255 3689 325 41 637 87 43 153)
for((BENCH_ID=0;BENCH_ID<=16;BENCH_ID+=1))
do
    # echo bench name: ${BENCH_NAMES[BENCH_ID]}
    # echo bench size: ${BENCH_HEAP[BENCH_ID]}
    BENCH_NAME=${BENCH_NAMES[BENCH_ID]}
    HEAP_MIN=${BENCH_HEAP[BENCH_ID]}

    mkdir $LOG_PATH/$BENCH_NAME -p

    HEAP_CONFIGS=($((HEAP_MIN * 3 / 2)) $((HEAP_MIN * 2)) $((HEAP_MIN * 4)))
    HEAP_CONFIG_NAMES=("1.5" "2.0" "4.0")

    # heap config id = 1 means 2x heap size
    for HEAP_ID in 1
    do
        echo bench name: $BENCH_NAME
        echo heap config size: ${HEAP_CONFIGS[HEAP_ID]}
        echo heap config name: ${HEAP_CONFIG_NAMES[HEAP_ID]}

        HEAPCONFIG=${HEAP_CONFIGS[HEAP_ID]}
        HEAPCONFIGNAME=${HEAP_CONFIG_NAMES[HEAP_ID]}

        echo "Start G1 test"
        numactl -C 0-7 -m0 ../jdk/jdk-11/bin/java -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65 -XX:+UseG1GC -jar $DACAPO_PATH $BENCH_NAME -n 6 &> $LOG_PATH/$BENCH_NAME/gclog_g1_heap${HEAPCONFIGNAME}.txt 
        
        echo "Start Shenandoah test"
        numactl -C 0-7 -m0 ../jdk/jdk-11/bin/java -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65 -XX:+UseShenandoahGC -jar $DACAPO_PATH $BENCH_NAME -n 6 &> $LOG_PATH/$BENCH_NAME/gclog_shen_heap${HEAPCONFIGNAME}.txt 

        echo "Start ZGC test"
        numactl -C 0-7 -m0 ../jdk/jdk-11/bin/java -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65 -XX:+UnlockExperimentalVMOptions -XX:+UseZGC -jar $DACAPO_PATH $BENCH_NAME -n 6 &> $LOG_PATH/$BENCH_NAME/gclog_zgc_heap${HEAPCONFIGNAME}.txt 

        echo "Start LXR test"
        MMTK_PLAN=Immix TRACE_THRESHOLD2=10 LOCK_FREE_BLOCKS=32 MAX_SURVIVAL_MB=256 SURVIVAL_PREDICTOR_WEIGHTED=1 numactl -C 0-7 -m0 ../jdk/jdk-lxr/bin/java -XX:+UseThirdPartyHeap -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65  -jar $DACAPO_PATH $BENCH_NAME -n 6 &> $LOG_PATH/$BENCH_NAME/gclog_lxr_heap${HEAPCONFIGNAME}.txt 
        

        echo "Start generational shenandoah test"
        numactl -C 0-7 -m0 ../jdk/jdk-genshen/bin/java   -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65  -XX:+UseShenandoahGC -XX:+UnlockExperimentalVMOptions -XX:ShenandoahGCMode=generational  -jar $DACAPO_PATH $BENCH_NAME -n 6 &> $LOG_PATH/$BENCH_NAME/gclog_gen_shen_heap${HEAPCONFIGNAME}.txt 

        echo "Start GENZ test"
        numactl -C 0-7 -m0 ../jdk/jdk-21-genz/bin/java   -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65   -XX:+UseZGC -XX:+ZGenerational   -jar $DACAPO_PATH $BENCH_NAME -n 6 &> $LOG_PATH/$BENCH_NAME/gclog_gen_zgc_heap${HEAPCONFIGNAME}.txt 

        echo "Start Jade test"
        numactl -C 0-7 -m0 ../jdk/jdk-jade/bin/java -XX:+JadeEnableChasingMode  -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:+UseJadeGC -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65   -XX:JadeConcEvacGCThreads=1 -jar $DACAPO_PATH $BENCH_NAME -n 6 &> $LOG_PATH/$BENCH_NAME/gclog_jade_chasing_heap${HEAPCONFIGNAME}.txt 
    done
done 

bash get-report-dacapo.sh
