--Example rows
--250.192.77.148 - - [2017-02-24 22:19:53 -0800] "GET /item/39 HTTP/1.1" 200 Mobile win8 "CUSTOMER=3801322"
--96.75.73.51 - - [2017-02-24 19:01:29 -0800] "GET /item/81 HTTP/1.1" 200 Chrome xp "CUSTOMER=7485755"
--Note regex is a Java escaped string hence the extra \\\

-- example usage in shell:
-- set hivevar:table=default.part_log_test3;
-- set hivevar:location=/user/andrew/part_log_test3;

-- example usage at cli:
-- hive -f create_table.sql --hivevar table=default.part_log_test3 --hivevar location=/user/andrew/part_log_test3

DROP TABLE IF EXISTS ${table};

CREATE EXTERNAL TABLE ${table}(
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
PARTITIONED BY(offset BIGINT)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
  'input.regex' = '^([\\d\\.]+) - - \\[([\\d-]+ [\\d:]+) ([+\\-\\d]+)\\] \\\"(\\w+) /(\\w+)/(\\d+) HTTP/1.1\\\" (\\d+) (\\w+) (\\w+) \\\"CUSTOMER=(\\d+)\\\".*'
)
STORED AS TEXTFILE
LOCATION '${location}';

MSCK REPAIR TABLE ${table};

select * from ${table} limit 1;
