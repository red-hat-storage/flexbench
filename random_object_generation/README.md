#Random Object Generation

## How to run
###Log generation
Use the `generate.sh` script to create fake log files. Below are the available options.

```
-sf|--scalefactor TPC-DS scale factor to be joined to, default 1k
-t|--template Apache FreeMarker template to use for output, default apache_log.template.
-m|--mappers Number of mappers to use for parallel data generation per day, default 1
-c|--count Number of records generated per mapper, default 10M. Allowed suffexes k, M, and G.
-o|--output Output path.
-sd|--startdate Starting date in ISO format, default 2017-02-21
-d|--days number of days to generate for (each is a seperate mr job), default 1
```

####10TB
To generate ~10TB of ~1GB log files joinable to TPC-DS SF 1,000 (1k) spanning 1,000 days starting on 2014-02-21 run:
```
./generate.sh -sf=1k -m=10 -c=10M -o=s3a://mybucket/log-sf1k-10tb -sd=2014-02-21 -d=1000
```
Runtime will be ~2-3 min per mapper, so on a decent cluster with ~1000 map slots so about 20-30 minutes.

####100TB
To generate ~100TB of ~1GB log files joinable to TPC-DS SF 10,000 (10k) spanning 1,000 days starting on 2014-02-21 run:
```
./generate.sh -sf=10k -m=100 -c=10M -o=s3a://mybucket/log-sf10k-100tb -sd=2014-02-21 -d=1000
```
Runtime will be ~2-3 min per mapper, so on a decent cluster with ~1000 map slots so about 3-5 hours.

####1PB
To generate ~1PB of ~1GB log files joinable to TPC-DS SF 100,000 (100k) spanning 1,000 days starting on 2014-02-21 run:
```
./generate.sh -sf=100k -m=1000 -c=10M -o=s3a://mybucket/log-sf100k-1pb -sd=2014-02-21 -d=1000
```
Runtime will be ~2-3 min per mapper, so on a decent cluster with ~1000 map slots so about 2 days. This might be a bit much for one go in which case we can split it up by doing a smaller number of days at a time.

####Progress tracking and validation

Monitor job progress from the YARN resource manager UI. Job names will be of the form `ROG $i/$days $output/ds=$date`. Validate that all jobs succeeded either in the UI or with `grep 'completed successfully' mr-driver-log-* | wc -l` verifying that the count is as expected, failed jobs can be found with `grep 'failed' mr-driver-log-*`.

####Cleanup

If desired remove `tmp-*` and `mr-driver-log-*`.

###Create table

Hive DDL for this table is in `create_table.sql` it has two variables -- the table name (optionaly including db) and location. Example usage:

```
hive -f create_table.sql \
--hivevar table=rog.log-sf10k-100tb \
--hivevar location=s3a://mybucket/log-sf10k \
```

This script also runs `MSCK REPAIR TABLE` and will print the partitions that are added. We also select one row of the table to verify that everything works as expected.

###Enrichment query

The enrichment query joins the log data to TPC-DS tables to add additional data. Example usage:

```
hive -f enrichment.sql \
--hivevar output_table=rog.log-sf10k-100tb-enriched \
--hivevar format=ORC \
--hivevar log_table=rog.log-sf10k-100tb \
--hivevar tpcdsdb=tpcds-sf10k-orc \
--hivevar start_date=2014-02-21 \
--hivevar end_date=2016-11-16
```

I would be preudent to test first with a few days to validate that things are running as expected.

##Notes
log-synth-0.1-SNAPSHOT-jar-with-dependencies.jar is built from https://github.com/tdunning/log-synth with patch from https://github.com/tdunning/log-synth/pull/31 that is required for use with hadoop-streaming.
