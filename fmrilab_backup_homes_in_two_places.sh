#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


scripts_dir=$(dirname $0)
echo "scripts_dir : $scripts_dir"


echo "Begin backup to two places"
date

${scripts_dir}/fmrilab_backup_homes_in_server.sh
${scripts_dir}/fmrilab_backup_homes_in_sesamo.sh

date
echo "Finished backup to two places"
