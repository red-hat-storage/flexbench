#!/usr/bin/env bash

(cd ../hive-testbench && ./tpcds-concurrent-run.sh 1000 UC11 10 >/root/svds-paul/mega_uc11.log 2>&1) &
(cd ../random_object_generation && ./enrichment.sh spark-sql 10tb _concurrent >/root/svds-paul/mega_uc23.log 2>&1) &
(cd ../hive-testbench && ./tpcds-setup.sh 24 1000 parquet s3a://etl2/tpcds-parallel >/root/svds-paul/mega_etl.log 2>&1) &
wait

echo "Done!"
