#!/bin/bash


# Configuramos mrtrix3
unset mrtrixDir

# removemos cualquier otra version de fsl en el PATH
PATH=$(IFS=':';p=($PATH);unset IFS;p=(${p[@]%%*mrtrix*});IFS=':';echo "${p[*]}";unset IFS)
export PATH

export mrtrixDir=/home/inb/lconcha/fmrilab_software/mrtrix3
export PATH=${mrtrixDir}/bin:${mrtrixDir}/scripts:${mrtrixDir}/lib:${PATH}
export LD_LIBRARY_PATH=${mrtrixDir}/lib:${LD_LIBRARY_PATH}

#echo ""
#echo "Ha sido configurado mrtrix version 3"
#echo "  mrtrixDir = ${mrtrixDir}"
#echo "  (para regresar a la version 2 abre una nueva terminal."
#echo ""

