#!/bin/bash

DATABASE=$1
SIZE=$2

hive -hiveconf location="hdfs://nameservice1/user/hive/warehouse/tpcds_bin_partitioned_orc_2.db/msckrepair" -hiveconf size=$SIZE --database $DATABASE -f msck.sql
