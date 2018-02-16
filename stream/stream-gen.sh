#!/usr/bin/env bash

if [ $# -ne 4 ]; then
    echo "stream-gen.sh <kafka-broker-list> <topic> <tpc-ds-sf> <count>"
    exit 1
fi

brokers=$1
topic=$2
tpcdssf=$3
count=$4

java -Xmx1028m -Dlog4j.configuration=file:../random_object_generation/log4j.properties \
  -jar ../random_object_generation/log-synth-0.1-SNAPSHOT-jar-with-dependencies.jar \
  -schema sf${tpcdssf}.json -template apache_log.template -count $count | \
  kafka-console-producer.sh --broker-list $brokers --topic $topic --property parse.key=true
