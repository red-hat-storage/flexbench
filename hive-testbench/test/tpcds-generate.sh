#!/bin/bash

TEXT_DIR=/tmp/tpc

#generate 1TB tables for orc and parquet
./tpcds-setup.sh 2 orc $TEXT_DIR
./tpcds-setup.sh 2 parquet $TEXT_DIR

#generate 10TB tables for orc and parquet
./tpcds-setup.sh 3 orc $TEXT_DIR
#./tpcds-setup.sh 3 parquet $TEXT_DIR

#generate 100TB tables for orc and parquet
#./tpcds-setup.sh 4 orc $TEXT_DIR
#./tpcds-setup.sh 4 parquet $TEXT_DIR
