#!/usr/bin/env bash

(cd ../hive-testbench && ./tpcds-concurrent-run.sh 1000 UC11 10 >/root/svds-paul/giga_uc11_1.log 2>&1) &
(cd ../hive-testbench && ./tpcds-concurrent-run.sh 10000 UC11 5 >/root/svds-paul/giga_uc11_2.log 2>&1) &
(cd ../random_object_generation && ./enrichment.sh spark-sql 100tb _concurrent >/root/svds-paul/giga_uc23.log 2>&1) &
(cd ../hive-testbench && ./tpcds-setup.sh 24 10000 parquet s3a://etl/tpcds-parallel >/root/svds-paul/giga_etl.log 2>&1) &
wait

echo "Done!"
