#!/bin/bash



unset FREESURFER_HOME

# removemos cualquier otra version de fsl en el PATH
PATH=$(IFS=':';p=($PATH);unset IFS;p=(${p[@]%%*freesurfer*});IFS=':';echo "${p[*]}";unset IFS)
export PATH

export FREESURFER_HOME=/home/inb/soporte/lanirem_software/freesurfer_7.0
source $FREESURFER_HOME/SetUpFreeSurfer.sh
