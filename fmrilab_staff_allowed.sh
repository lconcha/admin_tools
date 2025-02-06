#!/bin/bash

# Only root can run this script
u=$(whoami)
if [[ ! "${u}" == "root" ]]
then
  echo "ERROR. Only root can run this script."
  exit 0
fi


case "$1" in
    restart_sge)
      /home/inb/soporte/admin_tools/fmrilab_restart_sgeexecd.sh
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