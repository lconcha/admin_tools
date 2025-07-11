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


rsync -ax --inplace --delete \
    --info=progress2 --stats --no-compress --partial \
    --exclude=.docker/ \
    --exclude=*-tmp-*/ \
    --exclude=tmp/ \
    --exclude=TMP/ \
    --exclude=temporal/ \
    --exclude=nobackup/ \
    --exclude=*.old/ \
    --exclude=*.bak/ \
    --exclude=.cache/ \
    --exclude=.Cache/ \
    --exclude=Trash/ \
   --exclude=Downloads/ \
   --exclude=Code/logs/ \
  /mnt/SSD0/homevol \
  /mnt/SSD1/