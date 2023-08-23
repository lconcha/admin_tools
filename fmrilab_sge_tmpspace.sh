#!/bin/sh
# Grid Engine will automatically start/stop this script on exec hosts, if
# configured properly.
# https://gridscheduler.sourceforge.net/howto/loadsensor.html

FS=/tmp

if [ "$SGE_ROOT" != "" ]; then
   root_dir=$SGE_ROOT
else
   echo "SGE_ROOT not set. Quitting"
   exit 2
fi

# invariant values
myarch=`$root_dir/util/arch`
myhost=`$root_dir/utilbin/$myarch/gethostname -name`

ende=false
while [ $ende = false ]; do

   # ---------------------------------------- 
   # wait for an input
   #
   read input
   result=$?
   if [ $result != 0 ]; then
      ende=true
      break
   fi
   
   if [ "$input" = "quit" ]; then
      ende=true
      break
   fi

   # ---------------------------------------- 
   # send mark for begin of load report
   # NOTE: for global consumable resources not attached
   # to each machine (ie. floating licenses), the load
   # sensor only needs to be run on one host. In that case,
   # echo the string 'global' instead of '$myhost'.
   echo "begin"

   dfoutput="`df -k $FS | tail -1`"
   tmptot=`echo $dfoutput | awk '{ print $2}'` 
   tmpfree=`echo $dfoutput | awk '{ print $4}'`
   tmpused=`echo $dfoutput | awk '{ print $3}'`


   echo "$myhost:tmpfree:${tmpfree}k"
   echo "$myhost:tmptot:${tmptot}k"
   echo "$myhost:tmpused:${tmpused}k"

   echo "end"
done

exit 0

