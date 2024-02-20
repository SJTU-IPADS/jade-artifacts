# Artifact Description
Currently Jade is not ready for open-source. However, we have set up a machine and installed a pre-compiled Jade binary executable on it. Additionally, we have prepared the corresponding testing application and automation scripts for reproducing the experiments described in the paper. The following is the directory structure of our artifact.
```
./jade-ae/
├── README.md
├── dacapo
├── hbase-2.4.14
├── specjbb2015
├── ycsb-hbase2-binding-0.18.0-SNAPSHOT
├── jdk
│   ├── jdk-11
│   ├── jdk-21-genz
│   ├── jdk-genshen
│   ├── jdk-jade
│   └── jdk-lxr
├── results
│   ├── dacapo
│   ├── specjbb
│   └── hbase
└── scripts
    ├── run-dacapo.sh
    ├── run-hbase.sh
    └── run-specjbb.sh
```
**Test applications** including DaCapo, SPECjbb2015, HBase & YCSB can be found at `./jade-ae/`root directory.

**JDKs** of Jade and other baselines can be found at `./jade-ae/jdk`. This artifact includes jdk-jade(pre-compiled jdk with Jade), jdk11 (which is the base of Jade development), jdk-lxr (which is the state-of-the-art STW GC), jdk-genshen (a special version jdk supporting generational Shenandoah), and jdk-21-genz (the latest version of jdk21 supporting generational ZGC).

**Scripts** can be found at `./jade-ae/scripts` and can be used to automatically run experiments, process outputs, and reproduce the results of our paper.

**Results** will be generated at `./jade-ae/results`, and the following documentation will explain how to utilize these results.


# DaCapo Benchmarks
Run the following script to evaluate baseline and jade.
```
$ cd /home/jadetest/jade-ae/scripts
$ bash ./run-dacapo.sh
```
Results will be automatically generated at `/home/jadetest/jade-ae/results/dacapo/report.csv` and should be consistent with **Table 4**.
# SPECjbb 2015
Run the following script to evaluate baseline and jade.
```
$ cd /home/jadetest/jade-ae/scripts
$ bash ./run-specjbb.sh
```
Reports will be automatically generated in the following folder: `/home/jadetest/jade-ae/results/specjbb`

For example, the SPECjbb 2015 report with g1 and 4x heap size can be found at `/home/jadetest/jade-ae/results/specjbb/g1-heap4.0/report-00001/specjbb2015-C-XXXXXX-XXXXXX.html`. The majority of the crucial data from the report is located at `/home/jadetest/jade-ae/results/specjbb/g1-heap4.0/report-00001/data/rt-curve/specjbb2015-C-XXXXXX-XXXXXX-overall-throughput-rt.txt`. The maximum-jops and critical-jops of SPECjbb-g1-4xHeap testcase in **Table 3** can be found at the beginning of this txt file, along with the throughput-p99 data of **Figure 4** following it.

**NOTE:** Please note that each run of Specjbb2015 will take approximately 2-3 hours. This set of experiments includes testing 21 test points, so it may take up to 63 hours in total. Please make sure to allocate enough time for the experiments.


# HBase
Run the following script to evaluate baseline and jade.
```
$ cd /home/jadetest/jade-ae/scripts
$ bash ./run-hbase.sh
```
Reports will be automatically generated in the following folder: `/home/jadetest/jade-ae/results/hbase`

For instance, you can locate the HBase report for the YCSB mix workload with a 4x heap size (4400m) in the following file `/home/jadetest/jade-ae/results/hbase/4400m-mix.csv`. You may have to sort this table by hand in order to reproduce **Figure 5**.

