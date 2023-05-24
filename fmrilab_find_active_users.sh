#!/bin/bash

ndays=365; # days since last acces to file
ftotest=.bashrc; # file to test


naughty_users=""
while read this_user;
do
 #echo "-- $this_user"
 f_email=/home/inb/${this_user}/.email
 if [ -f $f_email ]
 then
   this_email=`cat $f_email`
 else
   this_email="NOEMAIL"
   naughty_users="$naughty_users $this_user"
 fi
 echo "$this_user $this_email"
done < <(find /home/inb -maxdepth 2 -name $ftotest -atime -30 -print | \
  awk -F/ '{print $4}' | uniq | sort)


echolor orange "List of users who logged in in the last $ndays days, but have no .email"
echo $naughty_users
