#!/usr/bin/env bash

ENGINE="spark"

# Use "s3cmd ls s3://rog/log-sf1k-10tb/" to check for start and end dates.

START_TIME="$(date +%s)"

if [ "${ENGINE}" == "hive" ]; then
    hive \
    -f enrichment.sql \
    --hivevar tpcdsdb=tpcds_bin_partitioned_orc_10000 \
    --hivevar log_table=rog.log_sf10k_10tb \
    --hivevar output_table=rog.log_sf10k_10tb_hive_enriched \
    --hivevar format=ORC \
    --hivevar start_date=2014-02-21 \
    --hivevar end_date=2016-11-16
elif [ "${ENGINE}" == "spark" ]; then
    spark-sql \
    -f enrichment.sql \
    --master=yarn \
    --properties-file ../hive-testbench/testbench_spark.settings \
    --database rog \
    --hivevar tpcdsdb=tpcds_bin_partitioned_parquet_10000 \
    --hivevar log_table=rog.log_sf10k_10tb \
    --hivevar output_table=rog.log_sf10k_10tb_spark_enriched \
    --hivevar format=parquet \
    --hivevar start_date=2014-02-21 \
    --hivevar end_date=2014-02-22
fi

TOTAL_RUN_TIME=$(($(date +%s) - ${START_TIME}))
if [ ${TOTAL_RUN_TIME} -gt 1 ]; then
    echo "Total run time ${TOTAL_RUN_TIME} seconds."
fi

echo "Done!"
