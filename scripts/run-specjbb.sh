
cd ../specjbb2015

HEAP_CONFIGS=("2912" "3884" "7768")
HEAP_NAMES=("1.5" "2.0" "4.0")
mkdir ../results/specjbb -p
rm -rf ./result/specjbb2015*

for idx in 0 1 2
do
    echo test id: $idx
    echo heap config size: ${HEAP_CONFIGS[idx]}
    echo heap config name: ${HEAP_NAMES[idx]}

    HEAPCONFIG=${HEAP_CONFIGS[idx]}
    HEAPCONFIGNAME=${HEAP_NAMES[idx]}

    echo "Start G1 test"
    numactl -C 0-7 -m0 ../jdk/jdk-11/bin/java -XX:+UseG1GC -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65 -Dspecjbb.controller.port=38668 -Djava.io.tmpdir="../tmp/specjbb-tmpfile" -jar specjbb2015.jar -m COMPOSITE > logs/gclog_g1_chasing_heap${HEAPCONFIGNAME}.txt
    rm -rf ../results/specjbb/g1-heap${HEAPCONFIGNAME} 
    mv ./result/specjbb2015* ../results/specjbb/g1-heap${HEAPCONFIGNAME}

    echo "Start Shenandoah test"
    numactl -C 0-7 -m0 ../jdk/jdk-11/bin/java -XX:+UseShenandoahGC -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65 -Dspecjbb.controller.port=38668 -Djava.io.tmpdir="../tmp/specjbb-tmpfile" -jar specjbb2015.jar -m COMPOSITE > logs/gclog_shenandoah_chasing_heap${HEAPCONFIGNAME}.txt
    rm -rf ../results/specjbb/shenandoah-heap${HEAPCONFIGNAME} 
    mv ./result/specjbb2015* ../results/specjbb/shenandoah-heap${HEAPCONFIGNAME}

    echo "Start ZGC test"
    numactl -C 0-7 -m0 .../jdk/jdk-11/bin/java -XX:+UseZGC -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65 -Dspecjbb.controller.port=38668 -Djava.io.tmpdir="../tmp/specjbb-tmpfile" -jar specjbb2015.jar -m COMPOSITE > logs/gclog_zgc_chasing_heap${HEAPCONFIGNAME}.txt
    rm -rf ../results/specjbb/zgc-heap${HEAPCONFIGNAME} 
    mv ./result/specjbb2015* ../results/specjbb/zgc-heap${HEAPCONFIGNAME}


    echo "Start Jade test"
    numactl -C 0-7 -m0 ../jdk/jdk-jade/bin/java -XX:+JadeEnableChasingMode  -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:+UseJadeGC -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65   -XX:JadeConcEvacGCThreads=1 -XX:+UseJadeGC  -Dspecjbb.controller.port=38668 -Djava.io.tmpdir="../tmp/specjbb-tmpfile" -jar specjbb2015.jar -m COMPOSITE > logs/gclog_jade_chasing_heap${HEAPCONFIGNAME}.txt
    rm -rf ../results/specjbb/jade-heap${HEAPCONFIGNAME} 
    mv ./result/specjbb2015* ../results/specjbb/jade-heap${HEAPCONFIGNAME}


    echo "Start Jade test"
    numactl -C 0-7 -m0 ../jdk/jdk-jade/bin/java -XX:+JadeEnableChasingMode  -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:+UseJadeGC -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65   -XX:JadeConcEvacGCThreads=1 -XX:+UseJadeGC  -Dspecjbb.controller.port=38668 -Djava.io.tmpdir="../tmp/specjbb-tmpfile" -jar specjbb2015.jar -m COMPOSITE > logs/gclog_jade_chasing_heap${HEAPCONFIGNAME}.txt
    rm -rf ../results/specjbb/jade-heap${HEAPCONFIGNAME} 
    mv ./result/specjbb2015* ../results/specjbb/jade-heap${HEAPCONFIGNAME}

    echo "Start generational shenandoah test"
    numactl -C 0-7 -m0 ../jdk/jdk-genshen/bin/java   -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65  -XX:+UseShenandoahGC -XX:+UnlockExperimentalVMOptions -XX:ShenandoahGCMode=generational -Dspecjbb.controller.port=38668 -Djava.io.tmpdir="../tmp/specjbb-tmpfile" -jar specjbb2015.jar -m COMPOSITE > logs/gclog_gen_shen_heap${HEAPCONFIGNAME}.txt
    rm -rf ../results/specjbb/genshen-heap${HEAPCONFIGNAME} 
    mv ./result/specjbb2015* ../results/specjbb/genshen-heap${HEAPCONFIGNAME}

    echo "Start GENZ test"
    numactl -C 0-7 -m0 ../jdk/jdk-21-genz/bin/java   -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65   -XX:+UseZGC -XX:+ZGenerational -Dspecjbb.controller.port=38668 -Djava.io.tmpdir="../tmp/specjbb-tmpfile" -jar specjbb2015.jar -m COMPOSITE > logs/gclog_gen_zgc_heap${HEAPCONFIGNAME}.txt
    rm -rf ../results/specjbb/genz-heap${HEAPCONFIGNAME}
    mv ./result/specjbb2015* ../results/specjbb/genz-heap${HEAPCONFIGNAME}

    if [ $idx -ne 0 ] # 1.0x heap size leads to OOM when use lxr
    then
        echo "Start LXR test"
        MMTK_PLAN=Immix TRACE_THRESHOLD2=10 LOCK_FREE_BLOCKS=32 MAX_SURVIVAL_MB=256 SURVIVAL_PREDICTOR_WEIGHTED=1 numactl -C 0-7 -m0 ../jdk/jdk-lxr/bin/java -XX:+UseThirdPartyHeap -XX:MaxMetaspaceSize=1024m -XX:MetaspaceSize=1024m -Xmx${HEAPCONFIG}m -Xms${HEAPCONFIG}m -XX:ParallelGCThreads=8 -XX:ConcGCThreads=2 -XX:InitiatingHeapOccupancyPercent=65 -Dspecjbb.controller.port=38668 -Djava.io.tmpdir="../tmp/specjbb-tmpfile" -jar specjbb2015.jar -m COMPOSITE > logs/gclog_lxr_heap${HEAPCONFIGNAME}.txt
        rm -rf ../results/specjbb/lxr-heap${HEAPCONFIGNAME}
        mv ./result/specjbb2015* ../results/specjbb/lxr-heap${HEAPCONFIGNAME}
    fi

done