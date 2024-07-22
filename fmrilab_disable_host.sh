
#!/bin/bash

H=$1


if [[ ! `whoami` == "root" ]]
	then
	echo "Only user root can do that. Farewell, `whoami`"
	exit 2
fi

echo " Will disable host -- $H -- from all cluster queues and whitelist its mount points."



# remove it from all queues
qmod -d *@${H}



# whitelist this host
whiteList=/home/inb/soporte/inb_cluster_whiteList.txt
WL=`cat $whiteList`
catted=`grep "$H" $whiteList`
if [ -z $catted ]
then
	echo "  Adding $H to whitelist: $whiteList"
	echo "$H" >> $whiteList
else
    echo "  $H already in whitelist: $whiteList"
fi


echo "Showing whitelisted nodes:"
cat $whiteList





echo "

To re-enable this host:
  qmod -e *@${H}
(and cleanup the file $whiteList)
"
