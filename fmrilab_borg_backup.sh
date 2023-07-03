#!/bin/bash


# Only root can run this script
u=$(whoami)
if [[ ! "${u}" == "root" ]]
then
  echo "ERROR. Only root can run this script."
  exit 0
fi


# https://borgbackup.readthedocs.io/en/stable/quickstart.html

echo "start of script"
date

# Setting this, so the repo does not need to be given on the commandline:
export BORG_REPO=admin@sesamo8:/volume1/NetBackup/borg_repo
#export BORG_PASSPHRASE='borgensesamo8'
export BORG_PASSPHRASE=$(cat `dirname $0`/private/borg_passphrase)
export BORG_EXCLUDEFILE='/home/inb/soporte/admin_tools/fmrilab_borg_exclude.txt'
#export RSYNC_EXCLUDEFILE='/home/inb/soporte/admin_tools/fmrilab_backup_exclude.txt'
#export BORG_EXCLUDEFILE=/tmp/borg.exclude
#chmod 777 $BORG_EXCLUDEFILE
#sed 's/- /\*\//g' $RSYNC_EXCLUDEFILE > $BORG_EXCLUDEFILE


## Tis is how I initialized the repo:
# root@mansfield$ borg init --encryption=repokey admin@sesamo8:/volume1/NetBackup/borg_repo --remote-path=/usr/local/bin/borg
# admin@sesamo8:/volume1/NetBackup/$ borg config borg_repo additional_free_space 2G
## And I created an rsh key for user root in mansfield, which I then copied to sesamo
# root@mansfield:~# ssh-keygen 
# ssh-copy-id admin@sesamo8


# some helpers and error handling:
echo() { printf "\n%s %s\n\n" "$( date )" "$*" >&2; }
trap 'echo $( date ) Backup interrupted >&2; exit 2' INT TERM

echo "Starting backup"

# Backup the most important directories into an archive named after
# the machine this script is currently running on:

PATHS_TO_BACKUP=/misc/${HOSTNAME}*


# wake up the autofs
cat /misc/${HOSTNAME}*/.testDir/.testFile
ls /misc/${HOSTNAME}*/.testDir/.testFile
for d in /misc/${HOSTNAME}*
do
  if [ ! -f ${d}/.testDir/.testFile ]
  then
   echo "ERROR. Cannot find ${d}/.testDir/.testFile"
   exit 2
  fi
done


borg create                         \
    --remote-path=/usr/local/bin/borg \
    --verbose                       \
    --filter AME                    \
    --list                          \
    --stats                         \
    --show-rc                       \
    --compression lz4               \
    --exclude-caches                \
    --one-file-system               \
    --exclude-from=$BORG_EXCLUDEFILE \
    ::'{hostname}-{now}'            \
    $PATHS_TO_BACKUP

backup_exit=$?

echo "Pruning repository"

# Use the `prune` subcommand to maintain 3 daily, 1 weekly and 2 monthly
# archives of THIS machine. The '{hostname}-*' matching is very important to
# limit prune's operation to this machine's archives and not apply to
# other machines' archives also:

borg prune                          \
    --remote-path=/usr/local/bin/borg \
    --list                          \
    --glob-archives '{hostname}-*'  \
    --show-rc                       \
    --keep-daily    3               \
    --keep-weekly   1               \
    --keep-monthly  2

prune_exit=$?

# actually free repo disk space by compacting segments

echo "Compacting repository"

borg compact --remote-path=/usr/local/bin/borg

compact_exit=$?

# use highest exit code as global exit code
global_exit=$(( backup_exit > prune_exit ? backup_exit : prune_exit ))
global_exit=$(( compact_exit > global_exit ? compact_exit : global_exit ))

if [ ${global_exit} -eq 0 ]; then
    echo "Backup, Prune, and Compact finished successfully"
elif [ ${global_exit} -eq 1 ]; then
    echo "Backup, Prune, and/or Compact finished with warnings"
else
    echo "Backup, Prune, and/or Compact finished with errors"
fi

echo "End of script"
date
exit ${global_exit}

