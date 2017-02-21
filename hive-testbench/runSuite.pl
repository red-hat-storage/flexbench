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
my $engine = "hive";
#my $engine = "presto";

# MAIN
dieWithUsage("one or more parameters not defined") unless @ARGV >= 2;
my $suite = shift;
my $format = shift;
my $scale = shift || 2;
dieWithUsage("suite name required") unless $suite eq "tpcds" or $suite eq "tpch";
dieWithUsage("suite name required") unless $format eq "orc" or $format eq "parquet";

chdir $SCRIPT_PATH;
if( $suite eq 'tpcds' ) {
	chdir "sample-queries-tpcds";
} else {
	chdir 'sample-queries-tpch';
} # end if
my @queries = glob '*.sql';

my $db = { 
	'tpcds' => "tpcds_bin_partitioned_${format}_$scale",
	'tpch' => "tpch_flat_${format}_$scale"
};

print "filename,status,time,rows\n";
for my $query ( @queries ) {
	my $logname = "$query.log";
	#my $cmd="echo 'use $db->{${suite}}; source $query;' | hive -i testbench.settings 2>&1  | tee ${format}_${scale}_${query}.log";
	my $cmd="echo 'use $db->{${suite}}; source $query;' | hive -i testbench_hive-spark.settings 2>&1  | tee ${format}_${scale}_${query}.log";
	#my $cmd="$PRESTO_EXECUTABLE --server $PRESTO_SERVER --catalog hive --schema $db->{${suite}} --file $query 2>&1 1>${format}_${scale}_${query}.out | tee ${format}_${scale}_${query}.log";
#	my $cmd="cat ${format}_${scale}_${query}.log";
	#print $cmd ; exit;
	
	my $hiveStart = time();

	my @hiveoutput=`$cmd`;
	die "${SCRIPT_NAME}:: ERROR:  command unexpectedly exited \$? = '$?', \$! = '$!'" if $?;

	my $hiveEnd = time();
	my $hiveTime = $hiveEnd - $hiveStart;
        if ($engine eq 'hive') {
	        foreach my $line ( @hiveoutput ) {
		        if( $line =~ /Time taken:\s+([\d\.]+)\s+seconds,\s+Fetched:\s+(\d+)\s+row/ ) {
			        print "$query,success,$hiveTime,$2\n"; 
		        } elsif( 
			        $line =~ /^FAILED: /
			        # || /Task failed!/ 
			        ) {
			        print "$query,failed,$hiveTime\n"; 
		        } # end if
	        } # end while
        } else {
                my $rows = `wc -l ${format}_${scale}_${query}.out`;
                my @row = split(/\s/, $rows);
                if (not(@hiveoutput)) {
                        print "$query,success,$hiveTime,$row[0]\n";
                } else {
                        print "$query,failed,$hiveTime\n";
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
	perl ${SCRIPT_NAME} [tpcds|tpch] [orc|parquet] [scale] 

Description:
	This script runs the sample queries and outputs a CSV file of the time it took each query to run.  Also, all hive output is kept as a log file named '[orc|parquet]_[scale]_queryXX.sql.log' for each query file of the form 'queryXX.sql'. Defaults to scale of 2.
USAGE
	exit 1;
}

