#!/bin/bash



unset FREESURFER_HOME

# removemos cualquier otra version de fsl en el PATH
PATH=$(IFS=':';p=($PATH);unset IFS;p=(${p[@]%%*freesurfer*});IFS=':';echo "${p[*]}";unset IFS)
export PATH

<<<<<<< HEAD
export FREESURFER_HOME=/home/inb/lconcha/fmrilab_software/freesurfer_7.4.1
=======
export FREESURFER_HOME=/home/inb/soporte/lanirem_software/freesurfer_7.0
>>>>>>> a505965638801416058fb443e430cbf9ec69ddd0
source $FREESURFER_HOME/SetUpFreeSurfer.sh
