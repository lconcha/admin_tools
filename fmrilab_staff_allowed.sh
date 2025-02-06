#!/bin/bash

# Only root can run this script
u=$(whoami)
if [[ ! "${u}" == "root" ]]
then
  echo "ERROR. Only root can run this script."
  exit 0
fi


help() {
  echo "
  Available options:

  restart_sge
  restart_autofs
  test
  help

  "

}


case "$1" in
    help)
      help
    ;;
    restart_sge)
      /home/inb/soporte/admin_tools/fmrilab_restart_sgeexecd.sh
    ;;
    restart_autofs)
      echo "Force unmounting everything inside /misc"
      umount -flv /misc/*
      echo "Restarting autofs"
      service autofs restart
      echo "Done".
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
      help
      exit 2
    ;;
  esac