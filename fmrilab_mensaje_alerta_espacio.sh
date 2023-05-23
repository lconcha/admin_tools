#!/bin/bash
#touch tamaños.txt
df -hl | head -n 1  >> tamaños.txt
for i in $(awk  '{print $1}' /home/inb/cluster/configuracion/hosts) ; do
      ping -c 1 -q $i  > /dev/null #&& this_ping_OK=1
      echo $i >> tamaños.txt
 ssh soporte@$i df -hl | tail -n +2  >> tamaños.txt
done



