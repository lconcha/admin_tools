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
  disable_sge_host <host>
  enable_sge_host <host>
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
    disable_sge_host)
      the_host=$2
      if [[ "$(hostname)" = "hahn" ]]
      then
        echo "Will disable $the_host in all queues"
        /home/inb/soporte/admin_tools/fmrilab_disable_host.sh $the_host
      else 
        echo "This command must be run in the SGE server (hahn)"
      fi
    ;;
    enable_sge_host)
      the_host=$2
      if [[ "$(hostname)" = "hahn" ]]
      then
        whitelist=/home/inb/soporte/inb_cluster_whiteList.txt
        echo "Will reactivate $the_host in all queues"
        qmod -e *@${the_host}
        sed -i "/${the_host}/d" $whitelist
        echo "Contents of whitelist ($whitelist):"
        cat $whitelist
        echo "Done".
      else 
        echo "This command must be run in the SGE server (hahn)"
      fi
    ;;
    fix_misc)
      /home/inb/soporte/admin_tools/fmrilab_fix_misc.sh
      echo "Done."
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