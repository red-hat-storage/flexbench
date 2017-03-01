#Synthetic Read Tool

This too puts a synthetic read load on the cluster. It runs a query that selects the number of rows, number of non null dates, distinct date count, and max of each column in a loop.

###Usage:
```
spark-submit --master yarn --num-executors <executors> spark-tpcds-read-loop.py <tpcds-database>
```
Where <executors> is set to give the needed amount of read throughput and <tpcds-database> is the TPC-DS database to run on.

To quit use ctrl-c or kill via other method.

###Sample output
```
[root@qcttwcoehd80 andrew]# spark-submit --master yarn --num-executors 1000 spark-tpcds-read-loop.py tpcds_text_1000
17/03/01 14:36:48 INFO SparkUI: Bound SparkUI to 0.0.0.0, and started at http://10.102.46.80:4040
17/03/01 14:36:56 INFO JettyUtils: Adding filter: org.apache.hadoop.yarn.server.webproxy.amfilter.AmIpFilter
+----------+--------------+-----------+-------------------+-------------------+--------------+------------------+---------------+---------------+--------------+---------------+---------------+
|     total|not_null_total|unique_days|max_ss_sold_date_sk|max_ss_sold_time_sk|max_ss_item_sk|max_ss_customer_sk|max_ss_cdemo_sk|max_ss_hdemo_sk|max_ss_addr_sk|max_ss_store_sk|max_ss_promo_sk|
+----------+--------------+-----------+-------------------+-------------------+--------------+------------------+---------------+---------------+--------------+---------------+---------------+
|2879987999|    2750387156|       1823|            2452642|              75599|        300000|          12000000|        1920800|           7200|       6000000|           1000|           1500|
+----------+--------------+-----------+-------------------+-------------------+--------------+------------------+---------------+---------------+--------------+---------------+---------------+

+----------+--------------+-----------+-------------------+-------------------+--------------+------------------+---------------+---------------+--------------+---------------+---------------+
|     total|not_null_total|unique_days|max_ss_sold_date_sk|max_ss_sold_time_sk|max_ss_item_sk|max_ss_customer_sk|max_ss_cdemo_sk|max_ss_hdemo_sk|max_ss_addr_sk|max_ss_store_sk|max_ss_promo_sk|
+----------+--------------+-----------+-------------------+-------------------+--------------+------------------+---------------+---------------+--------------+---------------+---------------+
|2879987999|    2750387156|       1823|            2452642|              75599|        300000|          12000000|        1920800|           7200|       6000000|           1000|           1500|
+----------+--------------+-----------+-------------------+-------------------+--------------+------------------+---------------+---------------+--------------+---------------+---------------+

[Stage 6:==========>                                      (2829 + 1000) / 13000]
```
