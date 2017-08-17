#!/bin/bash

QUERY_DIR=${1}

# SCALE 1000 10000 100000
SCALE=${2}

CONCURRENCY=${3}

# ENGINE_FORMAT "presto orc" "spark parquet" "hive orc" "hive-spark orc"
ENGINE_FORMAT="spark parquet"

for X in `seq 1 ${CONCURRENCY}`; do
    echo "query_set,run_id,engine,format,scale_factor,query,status,start,end,tot_time,query_time,rows" > ${QUERY_DIR}/tpc_stats_${X}.log
done

for X in `seq 1 ${CONCURRENCY}`; do
    perl runSuite.pl ${QUERY_DIR} ${X} ${ENGINE_FORMAT} ${SCALE} &
done
wait

echo "Done!"
