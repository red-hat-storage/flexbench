#!/bin/bash

cd ../hive-testbench

#generate 1TB tables for orc and parquet
./tpcds-setup.sh 2 orc /tmp/orc_2
./tpcds-setup.sh 2 parquet /tmp/parquet_2

#generate 10TB tables for orc and parquet
./tpcds-setup.sh 3 orc /tmp/orc_3
./tpcds-setup.sh 3 parquet /tmp/parquet_3

#generate 100TB tables for orc and parquet
./tpcds-setup.sh 4 orc /tmp/orc_4
./tpcds-setup.sh 4 parquet /tmp/parquet_4
