#!/bin/bash

cd hive-testbench

#generate 1TB tables for orc and parquet
./tpcds-setup.sh 1000 orc /tmp/orc_1000
./tpcds-setup.sh 1000 parquet /tmp/parquet_1000

#generate 10TB tables for orc and parquet
./tpcds-setup.sh 10000 orc /tmp/orc_10000
./tpcds-setup.sh 10000 parquet /tmp/parquet_10000

#generate 100TB tables for orc and parquet
./tpcds-setup.sh 100000 orc /tmp/orc_100000
./tpcds-setup.sh 100000 parquet /tmp/parquet_100000
