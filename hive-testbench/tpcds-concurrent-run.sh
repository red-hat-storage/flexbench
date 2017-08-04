#!/bin/bash

QUERY_DIR=${1}
CONCURRENCY=${2}

for X in `seq 1 ${CONCURRENCY}`; do
   echo "query_set,run_id,engine,format,scale_factor,query,status,start,end,tot_time,query_time,rows" > ${QUERY_DIR}/tpc_stats_${X}.log
done

# for SCALE in 1000 10000 100000 
for SCALE in 1000; do
   # for ENGINE_FORMAT in "presto orc" "spark parquet" "hive orc" "hive-spark orc" 
   for ENGINE_FORMAT in "spark parquet"; do
      for X in `seq 1 ${CONCURRENCY}`; do
	  perl runSuite.pl ${QUERY_DIR} ${X} ${ENGINE_FORMAT} ${SCALE} &
      done
      wait
   done
done

echo "Done!"
