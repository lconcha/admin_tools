#!/bin/bash


# Defaults #####################
mountPoint=~/mnt/kanbalam
localUser=`whoami`
remoteDir=/global/home/lconcha_g/$1
server=kanbalam.supercomputo.unam.mx
################################3

remoteUser=$1

print_help()
{
echo "
`basename $0` remoteUser

Options:

-remoteUser   <user>   Default: $localUser

-mountPoint  </some/local/path/where/I/Have/write/permissions>
                      Default: $mountPoint

-remoteDir   <remotePath>
                      Default: ${remoteDir}/user
-server      <address>
                      Default: $server


Luis Concha
INB
2012
"

}


if [ $# -lt 1 ] 
then
	echo " ERROR: Need more arguments..."
	print_help
	exit 1
fi



declare -i i
i=1
for arg in "$@"
do
  case "$arg" in
  -h|-help) 
    print_help
    exit 1
  ;;
  -remoteUser)
    nextarg=`expr $i + 1`
    eval remoteUser=\${${nextarg}}
  ;;
  -mountPoint)
    nextarg=`expr $i + 1`
    eval mountPoint=\${${nextarg}}
  ;;
  -remoteDir)
    nextarg=`expr $i + 1`
    eval remoteDir=\${${nextarg}}
  ;;
  -server)
    nextarg=`expr $i + 1`
    eval server=\${${nextarg}}
  ;;
  esac
  i=$[$i+1]
done



if [ -d $mountPoint ]
then
	echo "Mounting to $mountPoint ..."
else
	echo "$mountPoint does not exist. Create then try again. Bye."
	exit 1
fi

echo "--> sshfs -o reconnect $remoteUser@$server:$remoteDir $mountPoint"
sshfs -o reconnect $remoteUser@$server:$remoteDir $mountPoint


echo "
to unmount type:
  fusermount -u $mountPoint
"
