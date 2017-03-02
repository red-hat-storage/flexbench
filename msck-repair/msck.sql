set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.max.dynamic.partitions=1000000;
set hive.exec.max.dynamic.partitions.pernode=1000000;

create external table msckrepair_test (c_customer_id string) partitioned by (c_customer_sk bigint) LOCATION '${hiveconf:location}';

create external table msckrepair_test_new (c_customer_id string) partitioned by (c_customer_sk bigint) LOCATION '${hiveconf:location}';

insert into msckrepair_test partition(c_customer_sk) select c_customer_id,c_customer_sk from customer limit ${hiveconf:size};

msck repair table msckrepair_test_new;

