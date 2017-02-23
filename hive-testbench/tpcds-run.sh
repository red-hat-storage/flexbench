#!/bin/bash

QUERY_DIR=$1

#run 1TB queries
perl runSuite.pl $QUERY_DIR 1 presto orc 1000
perl runSuite.pl $QUERY_DIR 1 spark parquet 1000
perl runSuite.pl $QUERY_DIR 1 hive orc 1000
perl runSuite.pl $QUERY_DIR 1 hive-spark orc 1000

#run 10TB queries
perl runSuite.pl $QUERY_DIR 1 presto orc 10000
perl runSuite.pl $QUERY_DIR 1 spark parquet 10000
perl runSuite.pl $QUERY_DIR 1 hive orc 10000
perl runSuite.pl $QUERY_DIR 1 hive-spark orc 10000

#run 100TB queries
perl runSuite.pl $QUERY_DIR 1 presto orc 100000
perl runSuite.pl $QUERY_DIR 1 spark parquet 100000
perl runSuite.pl $QUERY_DIR 1 hive orc 100000
perl runSuite.pl $QUERY_DIR 1 hive-spark orc 100000
