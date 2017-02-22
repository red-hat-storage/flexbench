#!/usr/bin/perl

use strict;
use warnings;
use File::Basename;

# PROTOTYPES
sub dieWithUsage(;$);

# GLOBALS
my $SCRIPT_NAME = basename( __FILE__ );
my $SCRIPT_PATH = dirname( __FILE__ );
my $PRESTO_SERVER = "ip-172-31-22-200.us-west-2.compute.internal:8500";
my $PRESTO_EXECUTABLE = "/home/ubuntu/presto-cli/presto-cli-0.152-executable.jar";

# MAIN
dieWithUsage("one or more parameters not defined") unless @ARGV >= 3;
my $query_dir = shift;
my $engine = shift;
my $format = shift;
my $scale = shift || 2;
dieWithUsage("suite name required") unless $engine eq "hive" or $engine eq "hive-spark" or $engine eq "spark" or $engine eq "presto";
dieWithUsage("suite name required") unless $format eq "orc" or $format eq "parquet";

chdir $SCRIPT_PATH;
chdir $query_dir;

my @queries = glob '*.sql';

my $db = "tpcds_bin_partitioned_${format}_$scale",

print "filename,status,time,rows\n";
for my $query ( @queries ) {
	my $logname = "${engine}_${format}_${scale}_${query}";

        my $cmd = {
                'hive' => "echo 'use $db; source $query;' | hive -i ../testbench.settings 2>&1  | tee $logname.log",
                'hive-spark' => "echo 'use $db; source $query;' | hive -i ../testbench_hive-spark.settings 2>&1  | tee $logname.log",
                'spark' => "/data1/spark-2.1.0-bin-hadoop2.7/bin/spark-sql --master=yarn --database $db -f $query -i ../testbench_spark.settings 2>&1 1>$logname.out | tee $logname.log",
	        'presto' => "$PRESTO_EXECUTABLE --server $PRESTO_SERVER --catalog hive --schema $db --file $query 2>&1 1>$logname.out | tee $logname.log"
        };

	my $hiveStart = time();

	my @hiveoutput=`$cmd->{${engine}}`;
	die "${SCRIPT_NAME}:: ERROR:  command unexpectedly exited \$? = '$?', \$! = '$!'" if $?;

	my $hiveEnd = time();
	my $hiveTime = $hiveEnd - $hiveStart;
        if ($engine eq 'hive' or $engine eq "hive-spark" or $engine eq "spark") {
                my $output = '';
	        foreach my $line ( @hiveoutput ) {
		        if( $line =~ /Time taken:\s+([\d\.]+)\s+seconds,\s+Fetched:*\s+(\d+)\s+row/ ) {
			        $output = "$logname,success,$hiveTime,$2\n"; 
		        } # end if
	        } # end while
	        if ( $output eq '' ) {
		        $output = "$logname,failed,$hiveTime\n"; 
                }
	        print $output;
        } else {
                my $rows = `wc -l $logname.out`;
                my @row = split(/\s/, $rows);
                if (not(@hiveoutput)) {
                        print "$logname,success,$hiveTime,$row[0]\n";
                } else {
                        print "$logname,failed,$hiveTime\n";
                }
        }
} # end for


sub dieWithUsage(;$) {
	my $err = shift || '';
	if( $err ne '' ) {
		chomp $err;
		$err = "ERROR: $err\n\n";
	} # end if

	print STDERR <<USAGE;
${err}Usage:
	perl ${SCRIPT_NAME} [query_dir] [hive|hive-spark|spark|presto] [orc|parquet] [scale] 

Description:
	This script runs the sample queries and outputs a CSV file of the time it took each query to run.  Also, all hive output is kept as a log file named '[hive|hive-spark|spark|presto]_[orc|parquet]_[scale]_queryXX.sql.log' for each query file of the form 'queryXX.sql'. Defaults to scale of 2.
USAGE
	exit 1;
}

