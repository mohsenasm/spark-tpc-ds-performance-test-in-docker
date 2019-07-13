#!/bin/bash

cleanup() {
  if [ -n "$1" ]; then
    rm -rf $1/*.log
    find $1 ! -name 'runlist.txt' -name '*.txt' -type f -exec rm -f {} +
    rm -rf $1/*.sql
    rm -rf $1/*.properties
    rm -rf $1/*.out
    rm -rf $1/*.res
    rm -rf $1/*.dat
    rm -rf $1/*.rrn
    rm -rf $1/*.tpl
    rm -rf $1/*.lst
    rm -rf $1/README
  fi
}

set_environment() {
  bin_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  script_dir="$(dirname "$bin_dir")"

  if [ -z "$TPCDS_ROOT_DIR" ]; then
     TPCDS_ROOT_DIR=${script_dir}
  fi
  if [ -z "$TPCDS_LOG_DIR" ]; then
     TPCDS_LOG_DIR=${script_dir}/log
  fi
  if [ -z "$TPCDS_DBNAME" ]; then
     TPCDS_DBNAME="TPCDS"
  fi
  if [ -z "$TPCDS_GENDATA_DIR" ]; then
     TPCDS_GENDATA_DIR=${TPCDS_ROOT_DIR}/src/data
  fi
  if [ -z "$TPCDS_GEN_QUERIES_DIR" ]; then
     TPCDS_GENQUERIES_DIR=${TPCDS_ROOT_DIR}/src/queries
  fi
  if [ -z "$TPCDS_WORK_DIR" ]; then
     TPCDS_WORK_DIR=${TPCDS_ROOT_DIR}/work
  fi
}

template(){
    # usage: template file.tpl
    while read -r line ; do
            line=${line//\"/\\\"}
            line=${line//\`/\\\`}
            line=${line//\$/\\\$}
            line=${line//\\\${/\${}
            eval "echo \"$line\"";
    done < ${1}
}

function run_tpcds_common {
  output_dir=$TPCDS_WORK_DIR
  cp ${TPCDS_GENQUERIES_DIR}/*.sql $TPCDS_WORK_DIR

  ${TPCDS_ROOT_DIR}/bin/runqueries.sh $SPARK_HOME $TPCDS_WORK_DIR  > ${TPCDS_WORK_DIR}/runqueries.out 2>&1
}

function run_subset_tpcds_queries {
  output_dir=$TPCDS_WORK_DIR
  cleanup $TPCDS_WORK_DIR
  for i in `ls ${TPCDS_ROOT_DIR}/src/properties/*`
  do
    baseName="$(basename $i)"
    template $i > ${output_dir}/$baseName
  done
  for i in `ls ${TPCDS_ROOT_DIR}/src/ddl/*.sql`
  do
    baseName="$(basename $i)"
    template $i > ${output_dir}/$baseName
  done

  run_tpcds_common
}

function run_all_tpcds_queries {
  output_dir=$TPCDS_WORK_DIR
  cleanup $TPCDS_WORK_DIR
  touch ${TPCDS_WORK_DIR}/runlist.txt
  for i in `seq 1 99`
  do
    echo "$i" >> ${TPCDS_WORK_DIR}/runlist.txt
  done

  run_subset_tpcds_queries
}

set_env() {
  # read -n1 -s
  TEST_ROOT=`pwd`
  set_environment
  . $TPCDS_ROOT_DIR/bin/tpcdsenv.sh
  echo "SPARK_HOME is " $SPARK_HOME
  set_environment
}

main() {
  set_env
  run_subset_tpcds_queries
}

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main
