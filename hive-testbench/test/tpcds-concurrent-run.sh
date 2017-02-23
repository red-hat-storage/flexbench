#!/bin/bash

QUERY_DIR=$1
CONCURRENCY=$2

echo "query_set,run_id,engine,format,scale_factor,query,status,start,end,tot_time,query_time,rows" > $1/tpc_stats_$2.log

for scale in 2 3 4 
do
   for engine_format in "presto orc" "spark parquet" "hive orc" "hive-spark orc" 
   do
      for x in `seq 1 $CONCURRENCY`
      do
      perl runSuite.pl $QUERY_DIR $x $engine_format $scale &
      done
      wait
   done
done
