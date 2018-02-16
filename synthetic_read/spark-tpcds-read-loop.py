import sys
from pyspark.sql import SparkSession

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print "Usage: {} <tpcds-database>".format(sys.argv[0])
        exit(1)
    db = sys.argv[1]
    spark = SparkSession \
        .builder \
        .appName("Spark Synthetic Read Tool") \
        .enableHiveSupport() \
        .getOrCreate()
    try:
        while True:
            spark.sql("""
            select
              count(*) as total,
              count(ss_sold_date_sk) as not_null_total,
              count(distinct ss_sold_date_sk) as unique_days,
              max(ss_sold_date_sk) as max_ss_sold_date_sk,
              max(ss_sold_time_sk) as max_ss_sold_time_sk,
              max(ss_item_sk) as max_ss_item_sk,
              max(ss_customer_sk) as max_ss_customer_sk,
              max(ss_cdemo_sk) as max_ss_cdemo_sk,
              max(ss_hdemo_sk) as max_ss_hdemo_sk,
              max(ss_addr_sk) as max_ss_addr_sk,
              max(ss_store_sk) as max_ss_store_sk,
              max(ss_promo_sk) as max_ss_promo_sk
            from {}.store_sales
            """.format(db)).show()
    except KeyboardInterrupt:
        spark.stop()
