#!/bin/bash
FMRILAB_CONFIGFILE=/home/inb/cluster/fmrilab_configfile
source $FMRILAB_CONFIGFILE  &> /dev/null

fmrilab_check_backups.sh
fmrilab_write_check_file_for_backups.sh
