#!/bin/bash



df -hl | grep "\datos"
find /datos -type f -name core -exec file {} \; | \
  grep "core file " | \
  awk -F: '{print $1}' |
  while read f
  do
    ls -lh $f
    rm -f $f
  done


  df -hl | grep "\datos"
