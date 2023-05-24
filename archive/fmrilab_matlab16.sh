#!/bin/bash


local="/usr/local/Matlab16-alt/bin/matlab"
shared="/misc/mansfield/lconcha/software/MATLAB/R2016a/bin/matlab"


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
