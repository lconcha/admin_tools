#!/bin/bash

# Only root can run this script
u=$(whoami)
if [[ ! "${u}" == "root" ]]
then
  echo "ERROR. Only root can run this script."
  exit 0
fi


case "$1" in
    backup_borg)
      /home/inb/soporte/admin_tools/fmrilab_borg_backup.sh
    ;;
    backup_rsync)
      echo "rsync not implemented yet"
      exit 0
    ;;
    test)
      echo "This is a test"
      exit 0
    ;;
    *)
      echo "Option not recognized. Bye."
      exit 2
    ;;
  esac