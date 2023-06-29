#!/bin/bash

# Only root can run this script
u=$(whoami)
if [[ ! "${u}" == "root" ]]
then
  echo "ERROR. Only root can run this script."
  exit 0
fi


while getopts "brt" options
do
  case "${options}" in
    b)
      /home/inb/soporte/admin_tools/fmrilab_borg_backup.sh
    ;;
    r)
      echo "rsync not implemented yet"
      exit 0
    ;;
    t)
      echo "This is a test"
      exit 0
    ;;
    *)
      echo "Option not recognized. Bye."
      exit 2
    ;;
  esac

done