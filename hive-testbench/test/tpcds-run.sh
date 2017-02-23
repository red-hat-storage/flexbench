#!/bin/bash

QUERY_DIR=$1
run_id=0

echo "query_set,run_id,engine,format,scale_factor,query,status,start,end,tot_time,query_time,rows" > $1/tpc_stats_${run_id}.log

#run 1TB queries
perl runSuite.pl $QUERY_DIR $run_id presto orc 2
perl runSuite.pl $QUERY_DIR $run_id spark parquet 2
perl runSuite.pl $QUERY_DIR $run_id hive orc 2
perl runSuite.pl $QUERY_DIR $run_id hive-spark orc 2

#run 10TB queries
perl runSuite.pl $QUERY_DIR $run_id presto orc 3
perl runSuite.pl $QUERY_DIR $run_id spark parquet 3
perl runSuite.pl $QUERY_DIR $run_id hive orc 3
perl runSuite.pl $QUERY_DIR $run_id hive-spark orc 3

#run 100TB queries
perl runSuite.pl $QUERY_DIR $run_id presto orc 4
perl runSuite.pl $QUERY_DIR $run_id spark parquet 4
perl runSuite.pl $QUERY_DIR $run_id hive orc 4
perl runSuite.pl $QUERY_DIR $run_id hive-spark orc 4
