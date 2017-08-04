#!/usr/bin/env bash

# [ hive | spark-sql ]
ENGINE="${1}"

# [ 10tb | 100tb ]
LOG_DATA_SIZE="${2}"

# Can be empty.
OUTPUT_TABLE_SUFFIX="${3}"

# Use "s3cmd ls s3://rog/log-sf1k-10tb/" to check for start and end dates.
# 2014-02-21 2016-11-16
START_DATE="2014-02-21"

# Days per job.
DAYS=7

# Number of jobs.
RUNS=3

START_TIME="$(date +%s)"

for RUN in `seq 1 ${RUNS}`; do
    END_DATE=$(date +%Y-%m-%d -d "${START_DATE} + $(( ${DAYS} - 1 )) day")
    echo "Loop ${RUN} - ${START_DATE} to ${END_DATE}"
    echo ""

    if [ "${ENGINE}" == "hive" ]; then
        hive \
        -f enrichment.sql \
        --hivevar tpcdsdb=tpcds_bin_partitioned_orc_1000 \
        --hivevar log_table=rog.log_sf10k_${LOG_DATA_SIZE} \
        --hivevar output_table=rog.log_sf10k_${LOG_DATA_SIZE}_hive_enriched${OUTPUT_TABLE_SUFFIX} \
        --hivevar format=ORC \
        --hivevar start_date=${START_DATE} \
        --hivevar end_date=${END_DATE}
        hive -e "MSCK REPAIR TABLE rog.log_sf10k_${LOG_DATA_SIZE}_hive_enriched${OUTPUT_TABLE_SUFFIX};"
    elif [ "${ENGINE}" == "spark-sql" ]; then
        spark-sql \
        -f enrichment.sql \
        --master=yarn \
        --properties-file /hadoop/hive-testbench/testbench_spark.settings \
        --database rog \
        --hivevar tpcdsdb=tpcds_bin_partitioned_parquet_1000 \
        --hivevar log_table=rog.log_sf10k_${LOG_DATA_SIZE} \
        --hivevar output_table=rog.log_sf10k_${LOG_DATA_SIZE}_spark_enriched${OUTPUT_TABLE_SUFFIX} \
        --hivevar format=parquet \
        --hivevar start_date=${START_DATE} \
        --hivevar end_date=${END_DATE}
        hive -e "MSCK REPAIR TABLE rog.log_sf10k_${LOG_DATA_SIZE}_spark_enriched${OUTPUT_TABLE_SUFFIX};"
    fi
    echo ""

    START_DATE=$(date +%Y-%m-%d -d "${START_DATE} + ${DAYS} day")
done

TOTAL_RUN_TIME=$(($(date +%s) - ${START_TIME}))
if [ ${TOTAL_RUN_TIME} -gt 1 ]; then
    echo "Total run time ${TOTAL_RUN_TIME} seconds."
fi

echo "Done!"
