#query_canary.py
The query_canary script performs a set number of S3 bucket and object
operations. Each operation is recorded to a timestamped log file, allowing
the elapsed time for each of the operations to be monitored over time.

##How to run
As root
1. define your runtime environment using the parms.conf file
2. run the canary
```  
   > python query_canary.py
```



##query_canary supports
- runtime overrides (use -h to see available options)
- logging (activity is logged to /var/log/query_canary.log)
- different run times
- different iteration durations
- user defined object sizes
- multiple objects per test iteration


##Example Console output  

```
[root@rh7-client bigdata-coe]# python new_query_canary.py 

Run time parameters are:
access_key   : <bla>  
interval     : 15
object_count : 10
object_size  : 65536
rgw          : my-gw.storage.lab:8080
secret_key   : <wah>  
time_limit   : 300

Running

```


##Example Log file output
  
```
2017-02-21 23:51:47,163 [DEBUG       ] - waiting for next test iteration
2017-02-21 23:52:02,169 [DEBUG       ] - create bucket starting
2017-02-21 23:52:02,957 [INFO        ] - Test:create_bucket, secs=0.787929058075
2017-02-21 23:52:02,958 [DEBUG       ] - create bucket complete
2017-02-21 23:52:02,958 [DEBUG       ] - create objects starting - for 10 objects
2017-02-21 23:52:02,958 [DEBUG       ] - creating 82PM47BF
2017-02-21 23:52:03,402 [DEBUG       ] - creating NOPCZS65
2017-02-21 23:52:03,679 [DEBUG       ] - creating DE5X3QPT
2017-02-21 23:52:04,004 [DEBUG       ] - creating 6KT1TNWR
2017-02-21 23:52:04,215 [DEBUG       ] - creating 3MWXMT74
2017-02-21 23:52:04,398 [DEBUG       ] - creating UBLNDP1Z
2017-02-21 23:52:04,697 [DEBUG       ] - creating I37EKDKL
2017-02-21 23:52:05,014 [DEBUG       ] - creating 9F82AXOQ
2017-02-21 23:52:05,158 [DEBUG       ] - creating LKXVBIXC
2017-02-21 23:52:05,638 [DEBUG       ] - creating B49B9N5Y
2017-02-21 23:52:06,355 [INFO        ] - Test:create_object, count=10, bytes=655360, secs=3.39650297165
2017-02-21 23:52:06,355 [DEBUG       ] - create object(s) complete
2017-02-21 23:52:06,355 [DEBUG       ] - read object starting - 10 object(s)
2017-02-21 23:52:06,355 [DEBUG       ] - reading object 82PM47BF
2017-02-21 23:52:06,367 [DEBUG       ] - reading object NOPCZS65
2017-02-21 23:52:06,377 [DEBUG       ] - reading object DE5X3QPT
2017-02-21 23:52:06,389 [DEBUG       ] - reading object 6KT1TNWR
2017-02-21 23:52:06,402 [DEBUG       ] - reading object 3MWXMT74
2017-02-21 23:52:06,411 [DEBUG       ] - reading object UBLNDP1Z
2017-02-21 23:52:06,421 [DEBUG       ] - reading object I37EKDKL
2017-02-21 23:52:06,431 [DEBUG       ] - reading object 9F82AXOQ
2017-02-21 23:52:06,442 [DEBUG       ] - reading object LKXVBIXC
2017-02-21 23:52:06,451 [DEBUG       ] - reading object B49B9N5Y
2017-02-21 23:52:06,459 [INFO        ] - Test:read_object(s), count=10, bytes=655360, secs=0.104422092438
2017-02-21 23:52:06,460 [DEBUG       ] - read object(s) complete
2017-02-21 23:52:06,460 [DEBUG       ] - deleting objects from bucket
2017-02-21 23:52:06,460 [DEBUG       ] - deleting 82PM47BF
2017-02-21 23:52:06,757 [DEBUG       ] - deleting NOPCZS65
2017-02-21 23:52:07,153 [DEBUG       ] - deleting DE5X3QPT
2017-02-21 23:52:07,786 [DEBUG       ] - deleting 6KT1TNWR
2017-02-21 23:52:08,461 [DEBUG       ] - deleting 3MWXMT74
2017-02-21 23:52:08,949 [DEBUG       ] - deleting UBLNDP1Z
2017-02-21 23:52:09,395 [DEBUG       ] - deleting I37EKDKL
2017-02-21 23:52:09,763 [DEBUG       ] - deleting 9F82AXOQ
2017-02-21 23:52:10,161 [DEBUG       ] - deleting LKXVBIXC
2017-02-21 23:52:10,670 [DEBUG       ] - deleting B49B9N5Y
2017-02-21 23:52:11,030 [INFO        ] - Test:delete_objects, count=10, secs=4.56994509697
2017-02-21 23:52:11,030 [DEBUG       ] - delete object(s) complete
2017-02-21 23:52:11,030 [DEBUG       ] - delete bucket starting
2017-02-21 23:52:11,731 [DEBUG       ] - canary bucket deleted
2017-02-21 23:52:11,731 [INFO        ] - Test:delete_bucket, secs=0.70044708252
2017-02-21 23:52:11,731 [DEBUG       ] - delete bucket complete
2017-02-21 23:52:11,731 [DEBUG       ] - waiting for next test iteration

```
