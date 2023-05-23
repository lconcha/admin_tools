#!/bin/bash
#===============================================================================
#
#          FILE:  espaciodisco.sh
# 
#         USAGE:  ./espaciodisco.sh 
#   DESCRIPTION:  Revisar el espacio del disco en todas las unidades
#       VERSION:  1.0
#       CREATED:  01/24/2014 05:35:30 PM CST
#===============================================================================

# Inserta la linea de encabezados
# df -hl | awk 'NR==1' > espacios.txt

for line in $(cat configuracion/sge-hosts)
do 
 	echo "$line"
#	Extraer solo los dispositivos locales, genera error por el gvfs
#	ssh soporte@"$line" df -lh | grep /dev/ | awk '{$1=""; print $0}' 
#	En este caso se guarda la salida en un archivo
	ssh soporte@"$line" df -lh >> espacios.txt 
done
