#!/bin/bash
f_disable_users=cluster_users_to_disable.txt
export PATH=${PATH}:/home/inb/lconcha/fmrilab_software/tools

function disable ()
{
    u=$1
    doDisable=0
    read  -p "Disable user $u ?  [Y/N] : " i
    case $i in
        [yY]*)
            echolor orange "  Will disable user $u"
            doDisable=1
            ;;
        [nN]*)
            echolor green  "  Keeping user $u"
            doDisable=0
            ;;
        *)
            echo "  Invalid Option, try again."
            disable $u
            ;;
    esac

  if [ $doDisable -eq 1 ]
  then
   echolor red "chage -E0 -u"
   chage -E0 $u
  fi
}



for u in $(cat $f_disable_users)
do
   disable $u
done
