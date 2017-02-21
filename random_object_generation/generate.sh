#!/usr/bin/env bash

log()
{
  >&2 echo "$@"
}

basedir=$(dirname "$0")
logsynthjar="$basedir/log-synth-0.1-SNAPSHOT-jar-with-dependencies.jar"
synthjson=sf1k.json
template=apache_log.template
mappers=0
records_per_mapper=1M
log4j=log4j.properties

usage()
{
  log "Usage: generate.sh -sf=1k -t=apache_log.template -m=10 -c=1M -o=s3a://mybucket/log-sf1k-10M"
  log "  -sf|--scalefactor TPC-DS scale factor to be joined to, default 1k"
  log "  -t|--template Apache FreeMarker template to use for output, default $template."
  log "  -m|--mappers Number of mappers to use for parallel data generation, if 0 it is run localy with output to local fs."
  log "  -c|--count Number of records generated per mapper. Allowed suffexes k, M, and G."
  log "  -o|--output Output path, optional for local mode."
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
    *)
    log "Invalid argument $i" && usage
    ;;
esac
done

[ -z "$synthjson" ] && log 'Scale factor is required' && usage
[ -z "$template" ] && log 'Template is required' && usage
[ -z "$records_per_mapper" ] && log 'Records per mapper is required' && usage

log 'Running with the following variables set'
log synthjson="$synthjson"
log template="$template"
log mappers="$mappers"
log records_per_mapper="$records_per_mapper"
log output="$output"

if [ "$mappers" -gt 0 ]; then #Only do map-reduce if greater than one mapper specified.
  [ -z "$output" ] && log 'Output directory is required for mapreduce mode' && usage
  [ -z "$HADOOP_HOME" ] && log '$HADOOP_HOME must be set to run with map reduce' && exit 1
  [ ! -f "$HADOOP_HOME"/hadoop-streaming*.jar ] && log 'Unable to find Hadoop streaming jar at $HADOOP_HOME/hadoop-streaming*.jar' && exit 1

  hadoop_cmd="$HADOOP_HOME/bin/hadoop"
  log hadoop_cmd="$hadoop_cmd"

  streaming_jar=$("$hadoop_cmd" classpath --glob | sed -e "s/:/\n/g" | grep hadoop-streaming | head -n1 | xargs echo -n)
  [ -z "$streaming_jar" ] && log 'Unable to find hadoop-streaming jar in hadoop classpath' && exit 1
  log streaming_jar="$streaming_jar"

  #make fake input file
  inputfile=fake_input.$RANDOM
  local_input="$basedir/$inputfile"
  dfs_input="/user/$USER/$inputfile"
  : > "$local_input"
  for i in $(seq 1 $mappers); do
    echo $i >> "$local_input"
  done
  "$hadoop_cmd" fs -put "$local_input" "$dfs_input" && rm "$local_input"

  #make mapper script
  mapper_script="$basedir/mapper.sh"
  cat << EOF > "$mapper_script"
java -Dlog4j.configuration=file:$log4j -jar $logsynthjar -schema $synthjson -template $template -count $records_per_mapper
EOF
  log "Using mapper script:" $(cat "$mapper_script")

  command=("$hadoop_cmd" jar "$streaming_jar" -input "$dfs_input" -output "$output" -inputformat org.apache.hadoop.mapred.lib.NLineInputFormat -reducer org.apache.hadoop.mapred.lib.IdentityReducer -numReduceTasks 0)

  # add required files for execution
  for file in "$log4j" "$template" "$synthjson" "$mapper_script" "$logsynthjar"; do
    command+=(-file "$file")
  done
  log "Running command:" "${command[@]}"
  "${command[@]}"

else
  command=(java -Dlog4j.configuration=file:"$log4j" -jar "$logsynthjar" -schema "$synthjson" -template "$template" -count "$records_per_mapper")
  [ ! -z "$output" ] && command+=(-output "$output")
  log "Running command:" "${command[@]}"
  "${command[@]}"
fi
