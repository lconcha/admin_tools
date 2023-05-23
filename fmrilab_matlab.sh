#!/bin/bash


local="/usr/local/Matlab13-alt/bin/matlab"
shared="/home/inb/lconcha/fmrilab_software/MATLAB/Matlab13-alt/bin/matlab"


if [ -f $local ]
then
  echo "Running Local matlab"
  echo "  $local $@"
  $local $@
elif [ -f $shared ] 
then
  echo "Running shared matlab"
  echo "  $shared $@"
  $shared $@
else
  echo "ERROR: Could not find a matlab binary."
fi
