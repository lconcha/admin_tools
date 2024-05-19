#!/bin/bash

echo "Begin backup to two places"
date

fmrilab_backup_homes_in_server.sh
fmrilab_backup_homes_in_sesamo.sh

date
echo "Finished backup to two places"
