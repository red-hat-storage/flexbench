# Log data generation

Using random_object_generation/generate.sh:
  * -sf 1k - scale factor is set to 1000.
  * -m 10 - mappers is set to 10 for 10 files per day.
  * -c X - number of records per mapper. A value of 1M generated a ~100MB file.
  * -d 1000 - number of days (partitions)
  * -p 10 - number of threads, each running -m number of mappers.

#### For 10tb log dataset:

  * 1000 days of log data  
  * each day is a partition containing 10 files  
  * each file of 1GB size  
  * located in Ceph at /rog/log-sf1k-10tb  

`random_object_generation/generate.sh -sf=1k -m=10 -c=10M -o=s3a://rog/log-sf1k-10tb -sd=2014-02-21 -d=1000 -p=10`

To double-check log generation results:  

`~/s3cmd/s3cmd ls s3://rog/log-sf1k-10tb/`

To create external Hive table:  

`hive -f create_table.sql --hivevar table=rog.log_sf1k_10tb --hivevar location=s3a://rog/log-sf1k-10tb`

#### For 100tb log dataset:

  * 1000 days of log data  
  * each day is a partition containing 10 files  
  * each file of 10GB size  
  * located in Ceph at /rog/log-sf1k-100tb  

`random_object_generation/generate.sh -sf=1k -m=10 -c=100M -o=s3a://rog/log-sf1k-100tb -sd=2014-02-21 -d=1000 -p=10`

To double-check log generation results:  

`~/s3cmd/s3cmd ls s3://rog/log-sf1k-100tb/`

To create external Hive table:  

`hive -f create_table.sql --hivevar table=rog.log_sf1k_100tb --hivevar location=s3a://rog/log-sf1k-100tb`

# UC2/3 enrichment test

`random_object_generation/enrichment.sh [ hive | spark-sql ] [ 10tb | 100tb ] <optional suffix output directory name>`  

#### _1tb tpc_ data against _10tb log_ data

`nohup ./enrichment.sh spark-sql 10tb "" &`  
`nohup ./enrichment.sh hive 10tb "" &`  

#### _10tb tpc_ data against _100tb log_ data

`nohup ./enrichment.sh spark-sql 100tb "" &`  
`nohup ./enrichment.sh hive 100tb "" &`  

Timings will be in nohup.out. Look for "^Time". There will be timings for each stage of the enrichment test. For example, if using YARN, there will be the resource check wait time, then create table query and finally the enrichment query. If using Hive, there will be timings for the individual MR stage jobs.

# ETL test

Generate 17 dim and 7 fact tables in parallel.  

`hive-testbench/tpcds-setup.sh <parallel jobs> <scale factor> [ parquet | orc ] <s3a work directory>`  

`nohup ./tpcds-setup.sh 24 1000 parquet s3a://etl/tpcds-1k-parallel-test &`  
`nohup ./tpcds-setup.sh 24 10000 parquet s3a://etl/tpcds-1k-parallel-test &`  

Timings will be in nohup.out. The total run time will be near the end of the file.

# UC11 concurrent test

Run N number of TPCDS queries in parallel.  

`hive-testbench/tpcds-concurrent-run.sh <queries directory> <scale factor> <parallel jobs>`  

`nohup ./tpcds-concurrent-run.sh UC11 1000 10 &`  
`nohup ./tpcds-concurrent-run.sh UC11 10000 10 &`  

Look for timing information in the UC11 (queries directory). The files will be tpc\_stats\_\*.log. They are csv formatted.

# Mega concurrent test

* UC11 (10tb tpc) concurrent test with 10 threads.
* ETL (text to parquet) test with 17 tables in parallel.
* UC2/3 (1tb tpc against 10tb log) enrichment test using spark.

`big_concurrent_tests/mega_concurrent.sh`

See individual test sections above for timing information.

# Giga concurrent test

* UC11 (10tb tpc) concurrent test with 10 threads.
* UC11 (100tb tpc) concurrent test with 5 threads.
* ETL (text to parquet) test with 17 tables in parallel.
* UC2/3 (10tb tpc against 100tb log) enrichment test using spark.

`big_concurrent_tests/giga_concurrent.sh`

See individual test sections above for timing information.
