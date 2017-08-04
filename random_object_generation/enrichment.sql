SET hive.exec.dynamic.partition.mode=nonstrict;

-- set hivevar:output_table=default.part_log_test3_enriched;
-- set hivevar:format=ORC;
-- set hivevar:log_table=default.part_log_test3;
-- set hivevar:tpcdsdb=tpcds_bin_partitioned_orc_2;
-- set hivevar:start_date=2017-02-21;
-- set hivevar:end_date=2017-02-23;
 
-- testing only
-- drop table if exists ${output_table};

CREATE TABLE IF NOT EXISTS ${output_table} (
  ip STRING,
  ts STRING,
  tz STRING,
  verb STRING,
  resource_type STRING,
  resource_fk INT,
  response INT,
  browser STRING,
  os STRING,
  customer INT,
  d_day_name STRING,
  i_current_price DECIMAL,
  i_category STRING,
  c_preferred_cust_flag STRING
)
PARTITIONED BY(ds STRING)
STORED AS ${format};

insert overwrite table ${output_table} partition (ds)
select
  ip,
  ts,
  tz,
  verb,
  resource_type,
  resource_fk,
  response,
  browser,
  os,
  customer,
  d_day_name,
  i_current_price,
  i_category,
  c_preferred_cust_flag,
  ds
from ${log_table} log
  join ${tpcdsdb}.item i on log.resource_fk = i.i_item_sk
  join ${tpcdsdb}.customer c on log.customer = c.c_customer_sk
  join ${tpcdsdb}.date_dim d on log.ds = d.d_date
where
  log.resource_type = 'item'
  and log.ds between '${start_date}' and '${end_date}'
;
