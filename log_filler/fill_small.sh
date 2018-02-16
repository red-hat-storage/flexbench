#!/usr/bin/env bash

DATES=(
"2014-02-21"
"2014-02-22"
"2014-02-23"
"2014-02-24"
"2014-02-25"
"2014-02-26"
"2014-02-27"
"2014-02-28"
"2014-03-01"
"2014-03-02"
"2014-03-03"
"2014-03-04"
"2014-03-05"
"2014-03-06"
"2014-03-07"
"2014-03-08"
"2014-03-09"
"2014-03-10"
"2014-03-11"
"2014-03-12"
"2014-03-13"
"2014-03-14"
"2014-03-15"
"2014-03-16"
"2014-03-17"
"2014-03-18"
"2014-03-19"
"2014-03-20"
"2014-03-21"
"2014-03-22"
"2014-03-23"
"2014-03-24"
"2014-03-25"
"2014-03-26"
"2014-03-27"
"2014-03-28"
"2014-03-29"
"2014-03-30"
"2014-03-31"
"2014-04-01"
"2014-04-02"
"2014-04-03"
"2014-04-04"
"2014-04-05"
"2014-04-06"
"2014-04-07"
"2014-04-08"
"2014-04-09"
"2014-04-10"
"2014-04-11"
"2014-04-12"
"2014-04-13"
"2014-04-14"
"2014-04-15"
"2014-04-16"
"2014-04-17"
"2014-04-18"
"2014-04-19"
"2014-04-20"
"2014-04-21"
"2014-04-22"
"2014-04-23"
"2014-04-24"
"2014-04-25"
"2014-04-26"
"2014-04-27"
"2014-04-28"
"2014-04-29"
"2014-04-30"
"2014-05-01"
"2014-05-02"
"2014-05-03"
"2014-05-04"
"2014-05-05"
"2014-05-06"
"2014-05-07"
"2014-05-08"
"2014-05-09"
"2014-05-10"
"2014-05-11"
"2014-05-12"
"2014-05-13"
"2014-05-14"
"2014-05-15"
"2014-05-16"
"2014-05-17"
"2014-05-18"
"2014-05-19"
"2014-05-20"
"2014-05-21"
"2014-05-22"
"2014-05-23"
"2014-05-24"
"2014-05-25"
"2014-05-26"
"2014-05-27"
"2014-05-28"
"2014-05-29"
"2014-05-30"
"2014-05-31"
"2014-06-01"
"2014-06-02"
"2014-06-03"
"2014-06-04"
"2014-06-05"
"2014-06-06"
"2014-06-07"
"2014-06-08"
"2014-06-09"
"2014-06-10"
"2014-06-11"
"2014-06-12"
"2014-06-13"
"2014-06-14"
"2014-06-15"
"2014-06-16"
"2014-06-17"
"2014-06-18"
"2014-06-19"
"2014-06-20"
"2014-06-21"
"2014-06-22"
"2014-06-23"
"2014-06-24"
"2014-06-25"
"2014-06-26"
"2014-06-27"
"2014-06-28"
"2014-06-29"
"2014-06-30"
"2014-07-01"
"2014-07-02"
"2014-07-03"
"2014-07-04"
"2014-07-05"
"2014-07-06"
"2014-07-07"
"2014-07-08"
"2014-07-09"
"2014-07-10"
"2014-07-11"
"2014-07-12"
"2014-07-13"
"2014-07-14"
"2014-07-15"
"2014-07-16"
"2014-07-17"
"2014-07-18"
"2014-07-19"
"2014-07-20"
"2014-07-21"
"2014-07-22"
"2014-07-23"
"2014-07-24"
"2014-07-25"
"2014-07-26"
"2014-07-27"
"2014-07-28"
"2014-07-29"
"2014-07-30"
"2014-07-31"
"2014-08-01"
"2014-08-02"
"2014-08-03"
"2014-08-04"
"2014-08-05"
"2014-08-06"
"2014-08-07"
"2014-08-08"
"2014-08-09"
"2014-08-10"
"2014-08-11"
"2014-08-12"
"2014-08-13"
"2014-08-14"
"2014-08-15"
"2014-08-16"
"2014-08-17"
"2014-08-18"
"2014-08-19"
"2014-08-20"
"2014-08-21"
"2014-08-22"
"2014-08-23"
"2014-08-24"
"2014-08-25"
"2014-08-26"
"2014-08-27"
"2014-08-28"
"2014-08-29"
"2014-08-30"
"2014-08-31"
"2014-09-01"
"2014-09-02"
"2014-09-03"
"2014-09-04"
"2014-09-05"
"2014-09-06"
"2014-09-07"
"2014-09-08"
"2014-09-09"
"2014-09-10"
"2014-09-11"
"2014-09-12"
"2014-09-13"
"2014-09-14"
"2014-09-15"
"2014-09-16"
"2014-09-17"
"2014-09-18"
"2014-09-19"
"2014-09-20"
"2014-09-21"
"2014-09-22"
"2014-09-23"
"2014-09-24"
"2014-09-25"
"2014-09-26"
"2014-09-27"
"2014-09-28"
"2014-09-29"
"2014-09-30"
"2014-10-01"
"2014-10-02"
"2014-10-03"
"2014-10-04"
"2014-10-05"
"2014-10-06"
"2014-10-07"
"2014-10-08"
"2014-10-09"
"2014-10-10"
"2014-10-11"
"2014-10-12"
"2014-10-13"
"2014-10-14"
"2014-10-15"
"2014-10-16"
"2014-10-17"
"2014-10-18"
"2014-10-19"
"2014-10-20"
"2014-10-21"
"2014-10-22"
"2014-10-23"
"2014-10-24"
"2014-10-25"
"2014-10-26"
"2014-10-27"
"2014-10-28"
"2014-10-29"
"2014-10-30"
"2014-10-31"
"2014-11-01"
"2014-11-02"
"2014-11-03"
"2014-11-04"
"2014-11-05"
"2014-11-06"
"2014-11-07"
"2014-11-08"
"2014-11-09"
"2014-11-10"
"2014-11-11"
"2014-11-12"
"2014-11-13"
"2014-11-14"
"2014-11-15"
"2014-11-16"
"2014-11-17"
"2014-11-18"
"2014-11-19"
"2014-11-20"
"2014-11-21"
"2014-11-22"
"2014-11-23"
"2014-11-24"
"2014-11-25"
"2014-11-26"
"2014-11-27"
"2014-11-28"
"2014-11-29"
"2014-11-30"
"2014-12-01"
"2014-12-02"
"2014-12-03"
"2014-12-04"
"2014-12-05"
"2014-12-06"
"2014-12-07"
"2014-12-08"
"2014-12-09"
"2014-12-10"
"2014-12-11"
"2014-12-12"
"2014-12-13"
"2014-12-14"
"2014-12-15"
"2014-12-16"
"2014-12-17"
"2014-12-18"
"2014-12-19"
"2014-12-20"
"2014-12-21"
"2014-12-22"
"2014-12-23"
"2014-12-24"
"2014-12-25"
"2014-12-26"
"2014-12-27"
"2014-12-28"
"2014-12-29"
"2014-12-30"
"2014-12-31"
"2015-01-01"
"2015-01-02"
"2015-01-03"
"2015-01-04"
"2015-01-05"
"2015-01-06"
"2015-01-07"
"2015-01-08"
"2015-01-09"
"2015-01-10"
"2015-01-11"
"2015-01-12"
"2015-01-13"
"2015-01-14"
"2015-01-15"
"2015-01-16"
"2015-01-17"
"2015-01-18"
"2015-01-19"
"2015-01-20"
"2015-01-21"
"2015-01-22"
"2015-01-23"
"2015-01-24"
"2015-01-25"
"2015-01-26"
"2015-01-27"
"2015-01-28"
"2015-01-29"
"2015-01-30"
"2015-01-31"
"2015-02-01"
"2015-02-02"
"2015-02-03"
"2015-02-04"
"2015-02-05"
"2015-02-06"
"2015-02-07"
"2015-02-08"
"2015-02-09"
"2015-02-10"
"2015-02-11"
"2015-02-12"
"2015-02-13"
"2015-02-14"
"2015-02-15"
"2015-02-16"
"2015-02-17"
"2015-02-18"
"2015-02-19"
"2015-02-20"
"2015-02-21"
"2015-02-22"
"2015-02-23"
"2015-02-24"
"2015-02-25"
"2015-02-26"
"2015-02-27"
"2015-02-28"
"2015-03-01"
"2015-03-02"
"2015-03-03"
"2015-03-04"
"2015-03-05"
"2015-03-06"
"2015-03-07"
"2015-03-08"
"2015-03-09"
"2015-03-10"
"2015-03-11"
"2015-03-12"
"2015-03-13"
"2015-03-14"
"2015-03-15"
"2015-03-16"
"2015-03-17"
"2015-03-18"
"2015-03-19"
"2015-03-20"
"2015-03-21"
"2015-03-22"
"2015-03-23"
"2015-03-24"
"2015-03-25"
"2015-03-26"
"2015-03-27"
"2015-03-28"
"2015-03-29"
"2015-03-30"
"2015-03-31"
"2015-04-01"
"2015-04-02"
"2015-04-03"
"2015-04-04"
"2015-04-05"
"2015-04-06"
"2015-04-07"
"2015-04-08"
"2015-04-09"
"2015-04-10"
"2015-04-11"
"2015-04-12"
"2015-04-13"
"2015-04-14"
"2015-04-15"
"2015-04-16"
"2015-04-17"
"2015-04-18"
"2015-04-19"
"2015-04-20"
"2015-04-21"
"2015-04-22"
"2015-04-23"
"2015-04-24"
"2015-04-25"
"2015-04-26"
"2015-04-27"
"2015-04-28"
"2015-04-29"
"2015-04-30"
"2015-05-01"
"2015-05-02"
"2015-05-03"
"2015-05-04"
"2015-05-05"
"2015-05-06"
"2015-05-07"
"2015-05-08"
"2015-05-09"
"2015-05-10"
"2015-05-11"
"2015-05-12"
"2015-05-13"
"2015-05-14"
"2015-05-15"
"2015-05-16"
"2015-05-17"
"2015-05-18"
"2015-05-19"
"2015-05-20"
"2015-05-21"
"2015-05-22"
"2015-05-23"
"2015-05-24"
"2015-05-25"
"2015-05-26"
"2015-05-27"
"2015-05-28"
"2015-05-29"
"2015-05-30"
"2015-05-31"
"2015-06-01"
"2015-06-02"
"2015-06-03"
"2015-06-04"
"2015-06-05"
"2015-06-06"
"2015-06-07"
"2015-06-08"
"2015-06-09"
"2015-06-10"
"2015-06-11"
"2015-06-12"
"2015-06-13"
"2015-06-14"
"2015-06-15"
"2015-06-16"
"2015-06-17"
"2015-06-18"
"2015-06-19"
"2015-06-20"
"2015-06-21"
"2015-06-22"
"2015-06-23"
"2015-06-24"
"2015-06-25"
"2015-06-26"
"2015-06-27"
"2015-06-28"
"2015-06-29"
"2015-06-30"
"2015-07-01"
"2015-07-02"
"2015-07-03"
"2015-07-04"
"2015-07-05"
"2015-07-06"
"2015-07-07"
"2015-07-08"
"2015-07-09"
"2015-07-10"
"2015-07-11"
"2015-07-12"
"2015-07-13"
"2015-07-14"
"2015-07-15"
"2015-07-16"
"2015-07-17"
"2015-07-18"
"2015-07-19"
"2015-07-20"
"2015-07-21"
"2015-07-22"
"2015-07-23"
"2015-07-24"
"2015-07-25"
"2015-07-26"
"2015-07-27"
"2015-07-28"
"2015-07-29"
"2015-07-30"
"2015-07-31"
"2015-08-01"
"2015-08-02"
"2015-08-03"
"2015-08-04"
"2015-08-05"
"2015-08-06"
"2015-08-07"
"2015-08-08"
"2015-08-09"
"2015-08-10"
"2015-08-11"
"2015-08-12"
"2015-08-13"
"2015-08-14"
"2015-08-15"
"2015-08-16"
"2015-08-17"
"2015-08-18"
"2015-08-19"
"2015-08-20"
"2015-08-21"
"2015-08-22"
"2015-08-23"
"2015-08-24"
"2015-08-25"
"2015-08-26"
"2015-08-27"
"2015-08-28"
"2015-08-29"
"2015-08-30"
"2015-08-31"
"2015-09-01"
"2015-09-02"
"2015-09-03"
"2015-09-04"
"2015-09-05"
"2015-09-06"
"2015-09-07"
"2015-09-08"
"2015-09-09"
"2015-09-10"
"2015-09-11"
"2015-09-12"
"2015-09-13"
"2015-09-14"
"2015-09-15"
"2015-09-16"
"2015-09-17"
"2015-09-18"
"2015-09-19"
"2015-09-20"
"2015-09-21"
"2015-09-22"
"2015-09-23"
"2015-09-24"
"2015-09-25"
"2015-09-26"
"2015-09-27"
"2015-09-28"
"2015-09-29"
"2015-09-30"
"2015-10-01"
"2015-10-02"
"2015-10-03"
"2015-10-04"
"2015-10-05"
"2015-10-06"
"2015-10-07"
"2015-10-08"
"2015-10-09"
"2015-10-10"
"2015-10-11"
"2015-10-12"
"2015-10-13"
"2015-10-14"
"2015-10-15"
"2015-10-16"
"2015-10-17"
"2015-10-18"
"2015-10-19"
"2015-10-20"
"2015-10-21"
"2015-10-22"
"2015-10-23"
"2015-10-24"
"2015-10-25"
"2015-10-26"
"2015-10-27"
"2015-10-28"
"2015-10-29"
"2015-10-30"
"2015-10-31"
"2015-11-01"
"2015-11-02"
"2015-11-03"
"2015-11-04"
"2015-11-05"
"2015-11-06"
"2015-11-07"
"2015-11-08"
"2015-11-09"
"2015-11-10"
"2015-11-11"
"2015-11-12"
"2015-11-13"
"2015-11-14"
"2015-11-15"
"2015-11-16"
"2015-11-17"
"2015-11-18"
"2015-11-19"
"2015-11-20"
"2015-11-21"
"2015-11-22"
"2015-11-23"
"2015-11-24"
"2015-11-25"
"2015-11-26"
"2015-11-27"
"2015-11-28"
"2015-11-29"
"2015-11-30"
"2015-12-01"
"2015-12-02"
"2015-12-03"
"2015-12-04"
"2015-12-05"
"2015-12-06"
"2015-12-07"
"2015-12-08"
"2015-12-09"
"2015-12-10"
"2015-12-11"
"2015-12-12"
"2015-12-13"
"2015-12-14"
"2015-12-15"
"2015-12-16"
"2015-12-17"
"2015-12-18"
"2015-12-19"
"2015-12-20"
"2015-12-21"
"2015-12-22"
"2015-12-23"
"2015-12-24"
"2015-12-25"
"2015-12-26"
"2015-12-27"
"2015-12-28"
"2015-12-29"
"2015-12-30"
"2015-12-31"
"2016-01-01"
"2016-01-02"
"2016-01-03"
"2016-01-04"
"2016-01-05"
"2016-01-06"
"2016-01-07"
"2016-01-08"
"2016-01-09"
"2016-01-10"
"2016-01-11"
"2016-01-12"
"2016-01-13"
"2016-01-14"
"2016-01-15"
"2016-01-16"
"2016-01-17"
"2016-01-18"
"2016-01-19"
"2016-01-20"
"2016-01-21"
"2016-01-22"
"2016-01-23"
"2016-01-24"
"2016-01-25"
"2016-01-26"
"2016-01-27"
"2016-01-28"
"2016-01-29"
"2016-01-30"
"2016-01-31"
"2016-02-01"
"2016-02-02"
"2016-02-03"
"2016-02-04"
"2016-02-05"
"2016-02-06"
"2016-02-07"
"2016-02-08"
"2016-02-09"
"2016-02-10"
"2016-02-11"
"2016-02-12"
"2016-02-13"
"2016-02-14"
"2016-02-15"
"2016-02-16"
"2016-02-17"
"2016-02-18"
"2016-02-19"
"2016-02-20"
"2016-02-21"
"2016-02-22"
"2016-02-23"
"2016-02-24"
"2016-02-25"
"2016-02-26"
"2016-02-27"
"2016-02-28"
"2016-02-29"
"2016-03-01"
"2016-03-02"
"2016-03-03"
"2016-03-04"
"2016-03-05"
"2016-03-06"
"2016-03-07"
"2016-03-08"
"2016-03-09"
"2016-03-10"
"2016-03-11"
"2016-03-12"
"2016-03-13"
"2016-03-14"
"2016-03-15"
"2016-03-16"
"2016-03-17"
"2016-03-18"
"2016-03-19"
"2016-03-20"
"2016-03-21"
"2016-03-22"
"2016-03-23"
"2016-03-24"
"2016-03-25"
"2016-03-26"
"2016-03-27"
"2016-03-28"
"2016-03-29"
"2016-03-30"
"2016-03-31"
"2016-04-01"
"2016-04-02"
"2016-04-03"
"2016-04-04"
"2016-04-05"
"2016-04-06"
"2016-04-07"
"2016-04-08"
"2016-04-09"
"2016-04-10"
"2016-04-11"
"2016-04-12"
"2016-04-13"
"2016-04-14"
"2016-04-15"
"2016-04-16"
"2016-04-17"
"2016-04-18"
"2016-04-19"
"2016-04-20"
"2016-04-21"
"2016-04-22"
"2016-04-23"
"2016-04-24"
"2016-04-25"
"2016-04-26"
"2016-04-27"
"2016-04-28"
"2016-04-29"
"2016-04-30"
"2016-05-01"
"2016-05-02"
"2016-05-03"
"2016-05-04"
"2016-05-05"
"2016-05-06"
"2016-05-07"
"2016-05-08"
"2016-05-09"
"2016-05-10"
"2016-05-11"
"2016-05-12"
"2016-05-13"
"2016-05-14"
"2016-05-15"
"2016-05-16"
"2016-05-17"
"2016-05-18"
"2016-05-19"
"2016-05-20"
"2016-05-21"
"2016-05-22"
"2016-05-23"
"2016-05-24"
"2016-05-25"
"2016-05-26"
"2016-05-27"
"2016-05-28"
"2016-05-29"
"2016-05-30"
"2016-05-31"
"2016-06-01"
"2016-06-02"
"2016-06-03"
"2016-06-04"
"2016-06-05"
"2016-06-06"
"2016-06-07"
"2016-06-08"
"2016-06-09"
"2016-06-10"
"2016-06-11"
"2016-06-12"
"2016-06-13"
"2016-06-14"
"2016-06-15"
"2016-06-16"
"2016-06-17"
"2016-06-18"
"2016-06-19"
"2016-06-20"
"2016-06-21"
"2016-06-22"
"2016-06-23"
"2016-06-24"
"2016-06-25"
"2016-06-26"
"2016-06-27"
"2016-06-28"
"2016-06-29"
"2016-06-30"
"2016-07-01"
"2016-07-02"
"2016-07-03"
"2016-07-04"
"2016-07-05"
"2016-07-06"
"2016-07-07"
"2016-07-08"
"2016-07-09"
"2016-07-10"
"2016-07-11"
"2016-07-12"
"2016-07-13"
"2016-07-14"
"2016-07-15"
"2016-07-16"
"2016-07-17"
"2016-07-18"
"2016-07-19"
"2016-07-20"
"2016-07-21"
"2016-07-22"
"2016-07-23"
"2016-07-24"
"2016-07-25"
"2016-07-26"
"2016-07-27"
"2016-07-28"
"2016-07-29"
"2016-07-30"
"2016-07-31"
"2016-08-01"
"2016-08-02"
"2016-08-03"
"2016-08-04"
"2016-08-05"
"2016-08-06"
"2016-08-07"
"2016-08-08"
"2016-08-09"
"2016-08-10"
"2016-08-11"
"2016-08-12"
"2016-08-13"
"2016-08-14"
"2016-08-15"
"2016-08-16"
"2016-08-17"
"2016-08-18"
"2016-08-19"
"2016-08-20"
"2016-08-21"
"2016-08-22"
"2016-08-23"
"2016-08-24"
"2016-08-25"
"2016-08-26"
"2016-08-27"
"2016-08-28"
"2016-08-29"
"2016-08-30"
"2016-08-31"
"2016-09-01"
"2016-09-02"
"2016-09-03"
"2016-09-04"
"2016-09-05"
"2016-09-06"
"2016-09-07"
"2016-09-08"
"2016-09-09"
"2016-09-10"
"2016-09-11"
"2016-09-12"
"2016-09-13"
"2016-09-14"
"2016-09-15"
"2016-09-16"
"2016-09-17"
"2016-09-18"
"2016-09-19"
"2016-09-20"
"2016-09-21"
"2016-09-22"
"2016-09-23"
"2016-09-24"
"2016-09-25"
"2016-09-26"
"2016-09-27"
"2016-09-28"
"2016-09-29"
"2016-09-30"
"2016-10-01"
"2016-10-02"
"2016-10-03"
"2016-10-04"
"2016-10-05"
"2016-10-06"
"2016-10-07"
"2016-10-08"
"2016-10-09"
"2016-10-10"
"2016-10-11"
"2016-10-12"
"2016-10-13"
"2016-10-14"
"2016-10-15"
"2016-10-16"
"2016-10-17"
"2016-10-18"
"2016-10-19"
"2016-10-20"
"2016-10-21"
"2016-10-22"
"2016-10-23"
"2016-10-24"
"2016-10-25"
"2016-10-26"
"2016-10-27"
"2016-10-28"
"2016-10-29"
"2016-10-30"
"2016-10-31"
"2016-11-01"
"2016-11-02"
"2016-11-03"
"2016-11-04"
"2016-11-05"
"2016-11-06"
"2016-11-07"
"2016-11-08"
"2016-11-09"
"2016-11-10"
"2016-11-11"
"2016-11-12"
"2016-11-13"
"2016-11-14"
"2016-11-15"
"2016-11-16"
)

S3_LOCATION="s3://rog/log-sf1k-100tb"
FILE_PARTS="9"

for DATE in "${DATES[@]}"; do
    for COUNT in `seq 0 ${FILE_PARTS}`; do
        ~/s3cmd/s3cmd put "./part-0000${COUNT}" "${S3_LOCATION}/ds=${DATE}/part-0000${COUNT}"
    done
    ~/s3cmd/s3cmd put "./_SUCCESS" "${S3_LOCATION}/ds=${DATE}/_SUCCESS"
done

echo "Done!"