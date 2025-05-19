#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


servername="hahn"
if [ "$HOSTNAME" != "$servername" ]
then
  echo "Can only run in $servername"
  exit
fi


rsync -avx --progress  --partial \
  /mnt/raidSSD/* \
  /mnt/home.bak/home/
