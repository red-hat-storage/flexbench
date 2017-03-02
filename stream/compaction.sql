SET hive.exec.dynamic.partition.mode=nonstrict;

-- set hivevar:output_table=default.logs;
-- set hivevar:format=ORC;
-- set hivevar:stream_table=default.stream;
-- set hivevar:start_offset_partition=0;
-- set hivevar:end_offset_partition=1;

-- testing only
-- drop table ${output_table};


CREATE TABLE IF NOT EXISTS ${output_table}(
  ip STRING,
  ts STRING,
  tz STRING,
  verb STRING,
  resource_type STRING,
  resource_fk INT,
  response INT,
  browser STRING,
  os STRING,
  customer INT
)
PARTITIONED BY(ds STRING)
STORED AS ${format};

MSCK REPAIR TABLE ${stream_table};

insert into table ${output_table} partition (ds)
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
  substr(ts,0,10) as ds
from ${stream_table}
where
  offset between '${start_offset_partition}' and '${end_offset_partition}'
;
