#!/bin/bash
#
# This script is to be run in a synology.
# All clients (PCs with data to be backed up) should have root ssh keys setup.
# see https://hackmd.io/ZGXNbaW3T3WvBUfFADUcrw
# tl;dr :
# root@nyquist:~# nano /root/.ssh/authorized_keys
#
# # Forced command, disable PTY and all forwarding
# restrict,command="/home/inb/soporte/admin_tools/fmrilab_sshroot_allowed.sh $SSH_ORIGINAL_COMMAND" ssh-rsa ...
# Replace ... with the contents of:
# admin@sesamo8:/volume1/homes/admin/.ssh/id_rsa.pub
#
# This script ends up  calling fmrilab_borg_backup.sh so check that out
# to remember how to init the borg repo.
#
#
# In sesamo8, this file is in /volume1/NetBackup/scripts
#
# LU15 (0N(H4
# INB-UNAM
# July 2023

C13HOSTS="
brown
carr
ernst
fourier
mansfield
nyquist
penfield
rabi
rhesus
sherrington
tanner"
# bloch hahn # no tienen discos.

f_running=/volume1/NetBackup/logs.borg/borg_currently_running
f_thislog=/volume1/NetBackup/logs.borg/borg_$(date +%F-%H:%M:%S).log

for h in $C13HOSTS
do
  thisdate=$(date +%F-%H:%M:%S)
  f_thislog=/volume1/NetBackup/logs.borg/borg_${thisdate}_${h}.log
  echo $h > $f_running
  echo $thisdate >> $f_running
  ssh root@${h} backup_borg > $f_thislog 2>&1
  rm $f_running
done


# purge logs
find /volume1/NetBackup/logs.borg -type f -mtime +15 -delete
