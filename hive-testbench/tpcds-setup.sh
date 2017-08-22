#!/bin/bash

function usage {
    echo "Usage: tpcds-setup.sh parallel_jobs scale_factor format [temp_directory]"
    exit 1
}

function runcommand {
    if [ "X$DEBUG_SCRIPT" != "X" ]; then
        $1
    else
        $1 2>/dev/null
    fi
}

function generate {
    hdfs dfs -mkdir -p ${DIR}
    hdfs dfs -ls ${DIR}/${SCALE} > /dev/null
    if [ $? -ne 0 ]; then
        echo "Generating data at scale factor $SCALE."
        (cd tpcds-gen; hadoop jar target/*.jar -d ${DIR}/${SCALE}/ -s ${SCALE})
    fi
    hdfs dfs -ls ${DIR}/${SCALE} > /dev/null
    if [ $? -ne 0 ]; then
        echo "Data generation failed, exiting."
        exit 1
    fi
    echo "TPC-DS text data generation complete."
}

function etl {
    SRC_DATABASE=tpcds_${SCALE}_text
    DATABASE=tpcds_${SCALE}_${FORMAT}

    # Create the text/flat tables as external tables. These will be later be converted.
    echo "Loading text data into external tables."
    runcommand "hive -i settings/load-flat.sql -f ddl-tpcds/text/alltables.sql -d DB=${SRC_DATABASE} -d LOCATION=${DIR}/${SCALE}"

    # Create the partitioned and bucketed tables.

    LOAD_FILE="load_${SCALE}_${FORMAT}.mk"
    SILENCE="2> /dev/null 1> /dev/null" 
    if [ "X$DEBUG_SCRIPT" != "X" ]; then
        SILENCE=""
    fi

    echo -e "all: ${DIMS} ${FACTS}" > $LOAD_FILE

    i=1
    total=24

    # Populate the smaller tables.
    for t in ${DIMS}; do
        COMMAND="hive -i settings/load-partitioned.sql \
                      -f ddl-tpcds/bin_partitioned/${t}.sql \
                      -d DB=${DATABASE} \
                      -d SOURCE=${SRC_DATABASE}\
                      -d SCALE=${SCALE} \
                      -d FILE=${FORMAT}"
        echo -e "${t}:\n\t@$COMMAND $SILENCE && echo 'Optimizing table $t ($i/$total).'" >> $LOAD_FILE
        i=`expr $i + 1`
    done

    for t in ${FACTS}; do
        COMMAND="hive -i settings/load-partitioned.sql \
                      -f ddl-tpcds/bin_partitioned/${t}.sql \
                      -d DB=${DATABASE} \
                      -d SCALE=${SCALE} \
                      -d SOURCE=${SRC_DATABASE}\
                      -d FILE=${FORMAT}"
        echo -e "${t}:\n\t@$COMMAND $SILENCE && echo 'Optimizing table $t ($i/$total).'" >> $LOAD_FILE
        i=`expr $i + 1`
    done

    make -j $PARALLEL_JOBS -f $LOAD_FILE
}

which hive > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Script must be run where Hive is installed"
    exit 1
fi

if [ ! -f tpcds-gen/target/tpcds-gen-1.0-SNAPSHOT.jar ]; then
    echo "Please build the data generator with ./tpcds-build.sh first"
    exit 1
fi

# Get the parameters.
PARALLEL_JOBS=$1
SCALE=$2
FORMAT=$3
DIR=$4

# Sanity checking.
if [ X"$SCALE" = "X" ]; then
    usage
fi
if [ X"$FORMAT" = "X" ]; then
    usage
fi
if [ X"$DIR" = "X" ]; then
    DIR=/tmp/tpcds-generate
fi
if [ $SCALE -eq 1 ]; then
    echo "Scale factor must be greater than 1"
    exit 1
fi

if [ "X$DEBUG_SCRIPT" != "X" ]; then
    set -x
fi

# Tables in the TPC-DS schema.
DIMS="date_dim time_dim item customer customer_demographics household_demographics customer_address store promotion warehouse ship_mode reason income_band call_center web_page catalog_page web_site"
FACTS="store_sales store_returns web_sales web_returns catalog_sales catalog_returns inventory"


if [ "$FORMAT" = "text" ];then
    generate
elif [ "$FORMAT" = "orc" ] || [ "$FORMAT" = "parquet" ];then
    START_TIME="$(date +%s)"
    etl
    TOTAL_RUN_TIME=$(($(date +%s) - ${START_TIME}))
    if [ ${TOTAL_RUN_TIME} -gt 1 ]; then
        echo "Total run time ${TOTAL_RUN_TIME} seconds."
    fi
else
    echo "Format must be set to [text|orc|parquet]"
    usage
fi

echo "Done!"
