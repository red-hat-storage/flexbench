#!/usr/bin/env bash

START_DATE="2014-02-21"
DAYS=7
RUNS=3

ENGINE="spark"

# Use "s3cmd ls s3://rog/log-sf1k-10tb/" to check for start and end dates.
# 2014-02-21 2016-11-16

START_TIME="$(date +%s)"

for RUN in `seq 1 ${RUNS}`; do
    END_DATE=$(date +%Y-%m-%d -d "${START_DATE} + $(( ${DAYS} - 1 )) day")
    echo "Loop ${RUN} - ${START_DATE} to ${END_DATE}"

    if [ "${ENGINE}" == "hive" ]; then
        hive \
        -f enrichment.sql \
        --hivevar tpcdsdb=tpcds_bin_partitioned_orc_10000 \
        --hivevar log_table=rog.log_sf10k_10tb \
        --hivevar output_table=rog.log_sf10k_10tb_hive_enriched \
        --hivevar format=ORC \
        --hivevar start_date=${START_DATE} \
        --hivevar end_date=${END_DATE}
        hive -e "MSCK REPAIR TABLE rog.log_sf10k_10tb_hive_enriched;"
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
        --hivevar start_date=${START_DATE} \
        --hivevar end_date=${END_DATE}
        hive -e "MSCK REPAIR TABLE rog.log_sf10k_10tb_spark_enriched;"
    fi

    START_DATE=$(date +%Y-%m-%d -d "${START_DATE} + ${DAYS} day")
    echo ""
done

TOTAL_RUN_TIME=$(($(date +%s) - ${START_TIME}))
if [ ${TOTAL_RUN_TIME} -gt 1 ]; then
    echo "Total run time ${TOTAL_RUN_TIME} seconds."
fi

echo "Done!"
