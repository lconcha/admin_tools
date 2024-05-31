#!/bin/bash

# Only root can run this script
u=$(whoami)
if [[ ! "${u}" == "root" ]]
then
  echo "ERROR. Only root can run this script."
  exit 0
fi


case "$1" in
    backup_borg_sesamo8)
      /home/inb/soporte/admin_tools/fmrilab_borg_backup_sesamo8.sh
    ;;
    backup_borg_sesamo5)
      /home/inb/soporte/admin_tools/fmrilab_borg_backup_sesamo5.sh
    ;;
    backup_borg_garza)
      /home/inb/soporte/admin_tools/fmrilab_borg_backup_garza.sh
    ;;
    backup_rsync)
      echo "rsync not implemented yet"
      exit 0
    ;;
    test)
      echo "This is a test"
      echo "User: $(whoami)"
      echo "Host: $(hostname)"
      date
      exit 0
    ;;
    *)
      echo "Option not recognized. Bye."
      exit 2
    ;;
  esac