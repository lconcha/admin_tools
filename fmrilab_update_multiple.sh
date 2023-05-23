#!/bin/bash

machineList=~/tools/fmrilab_machines


# # Checar si soy sudo
# if [ ! $(id -u) -eq 0 ]; then
# 	echo "Only sudo can do this"
# 	exit 2
# fi

cat $machineList | while read machine
do
  echo ssh $machine 
done