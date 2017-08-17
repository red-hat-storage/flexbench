# Log data generation

Using random_object_generation/generate.sh:
  *-sf 1k - scale factor is set to 1000.
  *-m 10 - mappers is set to 10 for 10 files per day.
  *-c X - number of records per mapper. A value of 1M generated a ~100MB file.
  *-d 1000 - number of days (partitions)
  *-p 10 - number of threads, each running -m number of mappers.

For 10tb log dataset:

1000 days of log data, each day is a partition containing 10 files, each file of 1GB size, located in Ceph at /rog/log-sf1k-10tb:
random_object_generation/generate.sh -sf=1k -m=10 -c=10M -o=s3a://rog/log-sf1k-10tb -sd=2014-02-21 -d=1000 -p=10

To double-check log generation results:
~/s3cmd/s3cmd ls s3://rog/log-sf1k-10tb/

To create external Hive table:
hive -f create_table.sql --hivevar table=rog.log_sf1k_10tb --hivevar location=s3a://rog/log-sf1k-10tb

For 100tb log dataset:

1000 days of log data, each day is a partition containing 10 files, each file of 10GB size, located in Ceph at /rog/log-sf1k-100tb:
random_object_generation/generate.sh -sf=1k -m=10 -c=100M -o=s3a://rog/log-sf1k-100tb -sd=2014-02-21 -d=1000 -p=10

To double-check log generation results:
~/s3cmd/s3cmd ls s3://rog/log-sf1k-100tb/

To create external Hive table:
hive -f create_table.sql --hivevar table=rog.log_sf1k_100tb --hivevar location=s3a://rog/log-sf1k-100tb

* Second step - UC2/3 enrichment test

random_object_generation/enrichment.sh [ hive | spark-sql ] [ 10tb | 100tb ] <optional suffix output directory name>

The following calls will run 1tb tpc data against 10tb of log data:
nohup ./enrichment.sh spark-sql 10tb "" &
nohup ./enrichment.sh hive 10tb "" &

The following calls will run 10tb tpc data against 100tb of log data:
nohup ./enrichment.sh spark-sql 100tb "" &
nohup ./enrichment.sh hive 100tb "" &

Using nohup, the output of the calls will be in nohup.out. You can find the timings in this file. Look for "^Time".

