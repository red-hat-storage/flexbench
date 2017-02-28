#!/bin/bash

DATABASE=$1
SIZE=$2
LOCATION=s3a://tmp/msck/$DATABASE/$SIZE/msck

hive -hiveconf location="$LOCATION" -hiveconf size=$SIZE --database $DATABASE -f msck.sql > msck_stats_$SIZE.log.`date "+%F-%T"`
