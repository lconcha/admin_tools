#!/bin/bash
# Checar si soy sudo
# if [ ! $(id -u) -eq 0 ]; then
# 	echo "Only sudo can do this."
# 	exit 2
# fi

###########################################
# Check for known hosts
echo ""
echo " --> Checking if known hosts are up (from /etc/hosts)"
hosts_OK=1
grep inb.unam.mx /etc/hosts | while read line
do
  if [[ "${line:0:1}" == "#" ]]
  then
    continue
  else
    this_ping_OK=0
    host_ip=`echo $line | awk '{print $1}'`
    host_long=`echo $line | awk '{print $2}'`
    host_short=`echo $line | awk '{print $3}'`
    #echo "Pinging $host_short ($host_long) at $host_ip"
    ping -c 1 -q $host_ip > /dev/null && echo "${host_short} is up" && this_ping_OK=1
    if [ $this_ping_OK -eq 0 ]
    then
      echo "FATAL ERROR: $host_short ($host_ip) is DOWN!" && hosts_OK=0
    fi
  fi
done



###########################################
# Check if all nfs mounts are in good state
NFS_OK=1
echo ""
echo " --> Checking NFS mounted directories defined in /etc/fstab ..."
grep nfs /etc/fstab | while read line
do
  if [[ "${line:0:1}" == "#" ]]
  then
    continue
  else
    mPoint=`echo $line | awk '{print $2}'`
    fSystem=`timeout 2 stat -f -L -c %T $mPoint`
    if [[ "$fSystem" == "nfs" ]]
    then
      echo "OK          : Mountpoint $mPoint is $fSystem"
    else
      echo "FATAL ERROR : $mPoint is not mounted as NFS!" | tee -a $logfile
      NFS_OK=0
    fi
  fi
done

if [ $NFS_OK -eq 0 ]
then
  echo "  Something is wrong with some NFS mount points. Try sudo mount -a"
fi


########################################
# Check if the cluster is OK
cluster_OK=1
echo ""
echo " --> Checking if the cluster is OK"
host_name=`uname -n`
if [[ $host_name == "talairach" ]]
then
  echo "This is talairach, which is the SGE master. Will look for sge_qmaster now."
  pid_sge_qmaster=`ps aux | grep sge_qmaster | grep sgeadmin | awk '{print $2}'`
  if [ -z $pid_sge_qmaster ]
  then
    echo "ERROR: Cannot find a sge_qmaster process running"
    cluster_OK=0
  else
    echo "OK:    SGE master is running with PID $pid_sge_qmaster"
  fi 
fi
echo "Looking for sge_execd"
pid_sge_execd=`ps aux | grep sge_execd | grep sgeadmin | awk '{print $2}'`
if [ -z $pid_sge_execd ]
then
  echo "ERROR: Cannot find a sge_execd process running"
  cluster_OK=0
else
  echo "OK:    sge_execd is running with PID $pid_sge_execd"
fi 

if [ $cluster_OK -eq 1 ]
then
  ./fmrilab_cluster_status.sh
fi


########################################
# Backups
echo ""
echo " --> Last backup information"
lastBackup=`echo -n "$(ls -t /var/log/rsync-backup/ | head -n 1)"`
echo "Last backup log file is $lastBackup"
grep ERROR /var/log/rsync-backup/$lastBackup
