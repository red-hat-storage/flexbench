#Streaming Ingestion

This module tests streaming ingest of log structured data in the same format as [random object generation](../random_object_generation) using Kafka and Secor. This covers UC4 (streaming ingestion) and UC5 (streaming ingesiton concurrent with compaction).

##How to Use

Prerequisites: Kafka 0.8.2.x and Zookeeper (assumed to both be on local host for instructions but they can be external and/or have multiple hosts).

### Get Secor
Clone [Secor](https://github.com/pinterest/secor), build, and install
```
git clone https://github.com/pinterest/secor.git
cd secor
mvn package
tar -zxvf target/secor-*-bin.tar.gz -C ${SECOR_INSTALL_DIR}
```

###Create Kafka topic
Setting appropriate replication (at most number of kafka brokers) and partitions (limit on parallelism for reads)
```
TOPIC=logs
kafka-topics.sh --zookeeper localhost:2181 --create --replication-factor 1 --partitions 2 --topic $TOPIC
```

###Setup Secor
* Copy `secor.properties` to `${SECOR_INSTALL_DIR}` and edit first section as needed.
* Start Secor with this command.
```
cd ${SECOR_INSTALL_DIR}
java -Dlog4j.configuration=log4j.docker.properties -Dconfig=secor.properties \
  -cp secor-0.23-SNAPSHOT.jar:lib/* com.pinterest.secor.main.ConsumerMain &> secor.log &
```

###Start generating data to kafka
Run stream generation script as many times in parallel as required for needed throuput. Arguments are `<kafka-broker-list> <topic> <tpc-ds-sf> <count>`.
```
cd ${THIS_DIR}
./stream-gen.sh localhost:9092 $TOPIC 10k 1G &
```
This will generate 1 billion records (about 100GB) before exiting, quit early with ctrl-c

###Kafka debug commands
Some of these might be useful
```
#General
kafka-topics.sh --zookeeper localhost:2181 --list
kafka-topics.sh --zookeeper localhost:2181 --describe
kafka-topics.sh --zookeeper localhost:2181 --delete --topic $TOPIC

#Verify that data is in kafka
kafka-console-consumer.sh --zookeeper localhost:2181 --topic $TOPIC --from-beginning | less

#Check progress of secor consumer group
kafka-consumer-offset-checker.sh --group secor_backup --topic $TOPIC --zookeeper localhost:2181

#Latest offsets for topic
kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic $TOPIC --time -1

#Oldest available offsets for topic
kafka-run-class.sh kafka.tools.GetOffsetShell --broker-list localhost:9092 --topic $TOPIC --time -2
```

###Create Hive table for ingested log files
Secor creates files under the path `s3a://${secor.s3.bucket}/${secor.s3.path}/${TOPIC}/offset=*/`. We can create a partitioned hive table refering to this data as below, setting appropriate name and location (w/o `/offset=*` suffex)
```
hive -f create_table.sql \
--hivevar table=stream.log-sf10k \
--hivevar location=s3a://mybucket/stream-log-sf10k \
```

###Compaction Query
For UC5 we run this query concurrently with streaming ingestion. Note this query appends to the output table so it should be run on non overlapping offset partition ranges or there will be duplicate data in the output table. The value of `end_offset_partition` should be less than the partition currently being written to by Secor.
```
hive -f compaction.sql \
--hivevar output_table=stream.log-sf10k-compacted \
--hivevar format=ORC \
--hivevar stream_table=stream.log-sf10k \
--hivevar start_offset_partition=0 \
--hivevar end_offset_partition=1000000000
```
