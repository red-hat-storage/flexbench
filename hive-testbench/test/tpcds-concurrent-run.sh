#!/bin/bash

QUERY_DIR=$1
CONCURRENCY=$2


for scale in 2 3 4 
do
   for engine_format in "presto orc" "hive orc" "hive-spark orc" "spark parquet"
   do
      for x in `seq 1 $CONCURRENCY`
      do
      perl runSuite.pl $QUERY_DIR $x $engine_format $scale &
      done
      wait
   done
done
