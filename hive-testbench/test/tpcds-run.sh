#!/bin/bash

QUERY_DIR=$1

#run 1TB queries
perl runSuite.pl $QUERY_DIR 1 presto orc 2
perl runSuite.pl $QUERY_DIR 1 spark parquet 2
perl runSuite.pl $QUERY_DIR 1 hive orc 2
perl runSuite.pl $QUERY_DIR 1 hive-spark orc 2

#run 10TB queries
perl runSuite.pl $QUERY_DIR 1 presto orc 3
perl runSuite.pl $QUERY_DIR 1 spark parquet 3
perl runSuite.pl $QUERY_DIR 1 hive orc 3
perl runSuite.pl $QUERY_DIR 1 hive-spark orc 3

#run 100TB queries
perl runSuite.pl $QUERY_DIR 1 presto orc 4
perl runSuite.pl $QUERY_DIR 1 spark parquet 4
perl runSuite.pl $QUERY_DIR 1 hive orc 4
perl runSuite.pl $QUERY_DIR 1 hive-spark orc 4
