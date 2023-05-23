#!/bin/bash

# grep soft /etc/auto.misc | awk '{print $1}' | sort | while read h;
# do
#   if [[ ${h:0:1} = "#" ]]
#     then
#     continue
#   fi
#
#   host_group="@allhosts"
#   hosts=`qconf -shgrp_resolved $host_group`
#   whiteList=`cat /home/inb/lconcha/fmrilab_software/tools/inb_cluster_whiteList.txt`
#
# done


host_group="@allhosts"
hosts=`qconf -shgrp_resolved $host_group | uniq | sort`
whiteList=`cat /home/inb/lconcha/fmrilab_software/tools/inb_cluster_whiteList.txt`

grep soft /etc/auto.misc | awk '{print $1}' | sort | while read h;
do
  if [[ ! ${h:0:1} = "#" ]]
    then
    #echo $H $h
    echo "  $h `cat /misc/${h}/.testDir/.testFile`"
  fi

done


# for H in $hosts
# do
#   grep soft /etc/auto.misc | awk '{print $1}' | sort | while read h;
#   do
#     if [[ ! ${h:0:1} = "#" ]]
#       then
#       #echo $H $h
#       cmd="cat /misc/${h}/.testDir/.testFile"
#       echo ssh $H "$cmd"
#       #ssh $H "$cmd"
#     fi
#
#   done
# done
