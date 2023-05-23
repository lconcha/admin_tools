#!/bin/bash

locationsFile=/sesamo/backup/datos_backup_locations.txt

printf "\n %s" "Writing backup check files to each host" 
awk '{print $2}' $locationsFile | while read loc
do
   ## Since May 2015 we do not mount /datos/HOST on the machines,
   # instead we use /misc/HOST. However, /datos/HOST is still used by the
   # backup script, as this is the physical location where the 
   # data is on each host. The backup script goes through each host
   # and pulls data from its physical hard drive mounted in /datos.
   # I do not want to change the behavior of the backup script, so instead
   # here I simply change /datos for /misc to look for the test file.
   localFile=${loc}/.testDir/.backup_check_file.txt
   localFile=${localFile/datos/misc}

   date "+%s %D %H:%M" > $localFile
   printf "%s" "."
done
printf "\n"

echo "Writing to /home/inb/lconcha"
date "+%s %D %H:%M" > /home/inb/lconcha/backup_check_file.txt
