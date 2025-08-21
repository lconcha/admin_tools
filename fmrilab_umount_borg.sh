#!/bin/bash





# Checar si soy sudo
if [ ! $(id -u) -eq 0 ]; then
        echo "FATAL ERROR. Only sudo can do this"
        exit 2
fi



if [[ "${HOSTNAME}" == "tesla" ]]
then
  echo "This is tesla"
else
  echo "FATAL ERROR. Can only mount on tesla"
  exit 2

fi




export BORG_REPO=admin@sesamo:/volume1/fmrilab/backup/borg_repo
export BORG_PASSPHRASE=$(cat `dirname $0`/private/borg_passphrase_sesamo5)
if [ -z "$BORG_REPO" ] || [ -z "$BORG_PASSPHRASE" ]; then
  echo "FATAL ERROR. BORG_REPO or BORG_PASSPHRASE not set."
  exit 2
fi




local_mount_point=/bak.misc

if [ ! -d $local_mount_point ]
then
  echo "FATAL ERROR. Local mount point does not exist: $local_mount_point"
  exit 2
fi


# Unmount
echo "Unmounting $local_mount_point ..."
umount -fl $local_mount_point

