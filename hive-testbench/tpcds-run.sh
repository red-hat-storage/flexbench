#!/bin/bash

QUERY_DIR=$1

#run 1TB queries
perl runSuite.pl $QUERY_DIR hive orc 2
perl runSuite.pl $QUERY_DIR hive-spark orc 2
perl runSuite.pl $QUERY_DIR spark parquet 2
perl runSuite.pl $QUERY_DIR presto orc 2

#run 10TB queries
perl runSuite.pl $QUERY_DIR hive orc 3
perl runSuite.pl $QUERY_DIR hive-spark orc 3
perl runSuite.pl $QUERY_DIR spark parquet 3
perl runSuite.pl $QUERY_DIR presto orc 3

#run 100TB queries
perl runSuite.pl $QUERY_DIR hive orc 4
perl runSuite.pl $QUERY_DIR hive-spark orc 4
perl runSuite.pl $QUERY_DIR spark parquet 4
perl runSuite.pl $QUERY_DIR presto orc 4
