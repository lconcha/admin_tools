#!/bin/bash


# This script checks if the mount points are truly nfs by traversing /misc and checking each subfolder.
# It also makes a check to see if a test file can be read, the ultimate test for file system integrity.
#   such a file is in /misc/HOST/.testDir/.testFile and contains only the word "OK" (it is cat to prove that nfs is working)
#   (if installing a new hard drive, make sure you create that file!)


verbose=0
for arg in "$@"
do
  case "$arg" in
    -V)
      verbose=1
    ;;
    esac
    i=$[$i+1]
done


reset="\e[0m"
colorerror="\e[38;5;202m"
colorinfo="\e[33m"
colorOK="\e[32m"



tmpFile=/tmp/check_NFS_$$.txt
Errors=""


fmrilab_misc_file=/home/inb/soporte/configs/fmrilab_auto.misc
grep datos $fmrilab_misc_file | \
  grep --invert-match "#" | \
  awk  '{OFS = ";"} {print $1}' | \
  uniq | sort  > $tmpFile

# first we check /misc
d=1
while read h
do

  if [ $verbose -eq 1 ]
  then
    printf "${colorinfo} ${h}: $reset"
  fi

 if [[ "$h" == "lost+found" ]]
 then
   continue
 fi


 #if [[ $h == `uname -n`* ]]
#then
#  continue
# fi


whiteList=`cat /home/inb/lconcha/fmrilab_software/tools/inb_cluster_whiteList.txt`
isWhite=0
for w in $whiteList
do
  if [[ "$h" == "$w" ]]
    then
    if [ $verbose -eq 1 ]
    then
       printf " %s\n" "W"
    else
       printf "%s" "W"
    fi
    isWhite=1
  fi
done
if [ $isWhite -eq 1 ]
then
  continue
fi




 d=$(($d+1))
 mPoint=/misc/$h
 #fSystem=`stat -f -L -c %T $mPoint`
 #if [[ ! "$fSystem" == "nfs" ]]
 #then
 # Errors="$Errors $mPoint"
 #fi

 testFile=/misc/${h}/.testDir/.testFile
 if [[ ! -f $testFile ]]
 then
  Errors="$Errors ( cannot find $testFile )"
  if [ $verbose -eq 0 ]
  then
    printf "%s" "E"
  else
    printf "${colorerror} ERROR\n$reset"
  fi
else
  if [ $verbose -eq 0 ]
  then
    printf "%s" "."
  else
    printf "${colorOK} OK\n$reset"
  fi
fi
done < $tmpFile



# and now we check /home/inb, unless in tesla
if [[ ! `uname -n` == "tesla" ]]
then
  mPoint=/home/inb
  fSystem=`stat -f -L -c %T $mPoint`
  if [[ ! "$fSystem" == "nfs" ]]
  then
    Errors="$Errors $mPoint"
  fi
fi





# and spit out some results
if [ ! -z "$Errors" ]
then
  echo "THERE ARE MOUNTING ERRORS:"
  echo "    $Errors"
else
  cat $testFile
  #echo -e "\e[32m  OK \e[0m"
fi

rm $tmpFile
