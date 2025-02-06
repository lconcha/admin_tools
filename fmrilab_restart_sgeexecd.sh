#!/bin/bash

# Only root can run this script
u=$(whoami)
if [[ ! "${u}" == "root" ]]
then
  echo "ERROR. Only root can run this script."
  exit 0
fi

check() {
    str=$(ps aux | grep sge_execd | awk '{print $1}' | grep sge)
    if [ ! -z $str ]
    then
        #echo "sge_execd is running"
        echo "yes"
    else
        #echo "sge_execd is not running"
        echo "no"
    fi
}


status=$(check)
if [[ "$status" = "no" ]]
then
  echo "Starting sge_execd ..."
  export SGE_ROOT=/opt/sge
  source ${SGE_ROOT}/fmrilab/common/settings.sh
  /opt/sge/bin/lx-amd64/sge_execd
fi

check



