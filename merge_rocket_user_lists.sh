#!/bin/bash

f_channel_list=donclusterio_channel_users.csv
f_rocket_list=rocket_users.csv
f_merged=cluster_rocket_merged.csv
f_check=cluster_check_users.csv
f_cusers=donclusterio_users_emails.txt
f_keep_users=cluster_active_users.txt
f_disable_users=cluster_users_to_disable.txt

for f in $f_merged $f_check $f_keep_users
do
  if [ -f $f ]; then rm $f; fi
done

specialusers="soporte,timeshift,cluster"


cat $f_channel_list | while read line
do
  ruser=$(echo  $line | awk -F, '{print $2}')
  remail=$(grep -w '"'$ruser'"' $f_rocket_list | awk -F, '{print $10}' | sed s/\"//g)
  cuser=$(grep -w $remail /home/inb/*/.email | awk -F: '{print $1}' | awk -F/ '{print $4}')
  if [ -z "$cuser" ]; then echolor orange $ruser;echo "$ruser,$remail" | tee -a $f_check; continue;fi
  str=$(grep -w "$cuser" $f_cusers)
  if [ ! -z "$str" ]; then active=1;else active=0;fi
  echo $ruser,$remail,$cuser,$active | tee -a $f_merged
done



echo "======================"
cat $f_cusers | while read line
do
  cuser=$(echo $line | awk -F, '{print $1}')
  echolor cyan "cluster user: $cuser"
  str=$(grep -w $cuser $f_merged)
  echo $str
  if [ -z "$str" ]; then echolor orange "  $cuser $str";continue;fi
  isactive=$(echo $str | awk -F, '{print $4}')
  if [ $isactive -eq 1 ]; then thiscolor=green; else thiscolor=cyan;fi
  echolor $thiscolor "  $str"
done


echo "+++++++++++++++++++++++++++"
for d in /home/inb/*
do
  u=$(basename $d)
  str=$(grep -w "${u,}" $f_merged)

  str2=$(echo $specialusers | grep $u)
  if [ ! -z "$str2" ]; then echolor yellow "$u is a special user";echo $u >> $f_keep_users;continue;fi
  
  if [ -z "$str" ]
  then
    echolor orange "$u is not in don_clusterio"
    echo $u >> $f_disable_users
    continue
  fi

  ruser==$(echo $str | awk -F, '{print $1}')
  email=$(echo $str | awk -F, '{print $2}')
  rcuser=$(echo $str | awk -F, '{print $3}')
  isactive=$(echo $str | awk -F, '{print $4}')

  if [[ ! "$u" == "$rcuser" ]]
  then
   echolor red "User name mismatch. $u in cluster $rcuser in $f_merged"
   continue
  fi


  if [ $isactive -eq 1 ]
  then
    echolor green "$u is in don_clusterio and is active" 
    echo $u >> $f_keep_users
  else
    echolor orange "$u is in don_clusterio but is INACTIVE"
    echo $u >> $f_disable_users
  fi

done

echolor bold "-----------------"
for d in /home/inb/*
do
  u=$(basename $d)
  inkeep=$(grep -w $u $f_keep_users | sed s/\n//g)
  indisable=$(grep -w $u $f_disable_users | sed s/\n//g)

  if [ ${#inkeep} -gt 0 ]; then echolor green "$u : keep"; fi
  if [ ${#indisable} -gt 0 ]; then echolor orange "$u : disable"; fi
  if [ ${#inkeep} -gt 0 -a ${#indisable} -gt 0 ]; then echolor yellow "$u is in both lists, wtf?"; fi
  if [ ${#inkeep} -lt 1 -a ${#indisable} -lt 1 ]; then echolor yellow "$u is in none of the lists, wtf? "; fi
done
