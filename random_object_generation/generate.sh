#!/usr/bin/env bash

log()
{
  >&2 echo "$@"
}

basedir=$(dirname "$0")
logsynthjar="$basedir/log-synth-0.1-SNAPSHOT-jar-with-dependencies.jar"
synthjson=sf1k.json
template=apache_log.template
mappers=1
records_per_mapper=10M
log4j=log4j.properties
startdate=2017-02-21
days=1

usage()
{
  log "Usage: generate.sh -sf=1k -t=apache_log.template -m=10 -c=1M -o=s3a://mybucket/log-sf1k-10M -sd=2017-02-21 -d=14"
  log "  -sf|--scalefactor TPC-DS scale factor to be joined to, default 1k"
  log "  -t|--template Apache FreeMarker template to use for output, default apache_log.template."
  log "  -m|--mappers Number of mappers to use for parallel data generation per day, default 1"
  log "  -c|--count Number of records generated per mapper, default 10M. Allowed suffexes k, M, and G."
  log "  -o|--output Output path."
  log "  -sd|--startdate Starting date in ISO format, default 2017-02-21"
  log "  -d|--days number of days to generate for (each is a seperate mr job), default 1"
  exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

for i in "$@"
do
case $i in
    -sf=*|--scalefactor=*)
    synthjson=sf"${i#*=}".json
    [ ! -f "$synthjson" ] && log "Valid scale factors are 1k, 10k, and 100k" && usage
    ;;
    -t=*|--template=*)
    template="${i#*=}"
    [ ! -f "$template" ] && log "Template file $template does not exist" && usage
    ;;
    -m=*|--mappers=*)
    mappers="${i#*=}"
    if [[ ! $mappers =~ ^[1-9][0-9]*$ ]]; then
      log "Number of mappers must be a number" && usage
    fi
    ;;
    -c=*|--count=*)
    records_per_mapper="${i#*=}"
    if [[ ! $records_per_mapper =~ ^[1-9][0-9]*[kMG]?$ ]]; then
      log "Records per mappers must be a number optionaly with k, M, or G suffex" && usage
    fi
    ;;
    -o=*|--output=*)
    output="${i#*=}"
    ;;
    -sd=*|--startdate=*)
    startdate=$(date -I -d "${i#*=}") || { log 'Invalid start date' && usage; }
    ;;
    -d=*|--days=*)
    days="${i#*=}"
    if [[ ! $days =~ ^[1-9][0-9]*$ ]]; then
      log "Number of days must be a number" && usage
    fi
    ;;
    *)
    log "Invalid argument $i" && usage
    ;;
esac
done

[ ! -f "$synthjson" ] && log 'Unable to find required file $synthjson' && usage
[ ! -f "$template" ] && log 'Unable to find required file $template' && usage
[ -z "$records_per_mapper" ] && log 'Records per mapper is required' && usage
[ -z "$output" ] && log 'Output directory is required' && usage
[ -z "$HADOOP_HOME" ] && log '$HADOOP_HOME must be set' && exit 1

log 'Running with the following variables set'
log synthjson="$synthjson"
log template="$template"
log mappers="$mappers"
log records_per_mapper="$records_per_mapper"
log output="$output"
log startdate="$startdate"
log days="$days"


hadoop_cmd="$HADOOP_HOME/bin/hadoop"
log hadoop_cmd="$hadoop_cmd"

streaming_jar=$("$hadoop_cmd" classpath --glob | sed -e "s/:/\n/g" | grep hadoop-streaming | head -n1)
[ -z "$streaming_jar" ] && log 'Unable to find hadoop-streaming jar in hadoop classpath' && exit 1
log streaming_jar="$streaming_jar"

#make fake input file
inputfile=fake_input.$mappers
local_input="$basedir/$inputfile"
dfs_input="/user/$USER/$inputfile"
: > "$local_input"
for i in $(seq 1 $mappers); do
  echo $i >> "$local_input"
done
"$hadoop_cmd" fs -put "$local_input" "$dfs_input" && rm "$local_input"

date=$startdate
for i in $(seq 1 $days); do
  log "---"
  log "Building job for date $date"
  #make synth json file for date
  datesynthjson="tmp-$date-$synthjson"
  cat "$synthjson" | sed -e "s/DATE/$date/g" > "$datesynthjson"

  #make mapper script
  mapper_script="$basedir/tmp-$date-mapper.sh"
  cat << EOF > "$mapper_script"
java -Xmx1028m -Dlog4j.configuration=file:$log4j -jar $logsynthjar -schema $datesynthjson -template $template -count $records_per_mapper
EOF
  log "Using mapper script:" $(cat "$mapper_script")

  command=("$hadoop_cmd" jar "$streaming_jar" -D mapreduce.map.memory.mb=1536 -input "$dfs_input" -output "$output/ds=$date" -inputformat org.apache.hadoop.mapred.lib.NLineInputFormat -mapper $(basename "$mapper_script") -reducer org.apache.hadoop.mapred.lib.IdentityReducer -numReduceTasks 0)

  # add required files for execution
  for file in "$log4j" "$template" "$datesynthjson" "$mapper_script" "$logsynthjar"; do
    command+=(-file "$file")
  done

  logfile="mr-driver-log-$date.txt"

  log "Running command:" "${command[@]}"
  log "Output will be logged to $logfile"
  nohup "${command[@]}" &> "$logfile" &

  date=$(date -I -d "$date + 1 day")
done
