#Random Object Generation

## How to run
###Log generation
To generate ~10TB of ~1GB log files joinable to TPC-DS SF 10000 (10k) run:
```
./generate.sh -sf=10k -m=10000 -c=10M -o=output_dir
```
Runtime will be ~3 min per mapper, so on a decent cluster with ~1000 map slots 30min.

###Create table
```
hive -f create_table.sql \
--hivevar table=part_log_test3 \
--hivevar location=/user/andrew/part_log_test3 \
--database default
```

###Enrichment query
```
hive -f enrichment.sql \
--hivevar output_table=default.part_log_test3_enriched \
--hivevar format=ORC \
--hivevar log_table=default.part_log_test3 \
--hivevar tpcdsdb=tpcds_bin_partitioned_orc_2 \
--hivevar start_date=2017-02-21 \
--hivevar end_date=2017-02-23
```


##Notes
log-synth-0.1-SNAPSHOT-jar-with-dependencies.jar is built from https://github.com/tdunning/log-synth with patch from https://github.com/tdunning/log-synth/pull/31 that is required for use with hadoop-streaming.
