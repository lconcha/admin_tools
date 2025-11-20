#!/bin/bash


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


if [ $# -ne 1 ]
then
  echo "Usage: $0 <host_shortname>"
  echo "Example: $0 sesamo8"
  exit 2
fi


h=$1

remotekey=$(readlink -f $(dirname $0)/private/${h}_id_rsa.pub)
echo "Remote key is $remotekey"

if [ ! -f ${remotekey} ]
then
  echo "FATAL ERROR. Public key file not found: ${remotekey}"
  exit 2
fi



authorized_keys=~/.ssh/authorized_keys
echo "Authorized keys file is $authorized_keys"

nfound=$(grep -c $h $authorized_keys)

echo "Number of keys found for $h in authorized_keys: $nfound"


if [ $nfound -gt 0 ]
then
  echo "Removing old keys for $h from authorized_keys ..."
  cp -v $authorized_keys ${authorized_keys}.bak_$(date +%Y%m%d_%H%M%S)
  sed -i "/${h}/d" $authorized_keys
fi


echo "Adding key for $h to authorized_keys ..."
keycontent=$(cat "$remotekey")
echo "restrict,command=\"/home/inb/soporte/admin_tools/fmrilab_sshroot_allowed.sh \$SSH_ORIGINAL_COMMAND\" $keycontent" >> "$authorized_keys"


# Remove empty lines
sed -i '/^$/d' $authorized_keys
echo "Done."



