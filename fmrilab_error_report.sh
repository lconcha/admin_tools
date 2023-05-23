#!/bin/bash
Errors=""
for i in  $(awk  '{print $1}' /home/inb/cluster/configuracion/hosts) ; do 
########## Checa si la conexión es adecuada  
	ping -c 2 -q $i	2>&1 >/dev/null
	if [  $? -ne 0 ];then  Errors="$Errors No se encontro $i," && echo "No se encontro $i" ; continue;  fi
########## Probar cada directorio 
	for h in $(ssh $i "find  /datos/*/ -maxdepth 0 -type d"); do
		if [[ $i == "fourier" && $(echo $h | grep "/datos/fourier2") ]] || [[ $(echo $h | grep  "/datos/lost+found/") || $(echo $h | awk -F/ '{print $3}') == $i ]]; then continue; fi
		mPoint=$h
		fSystem=`ssh $i stat -f -L -c %T $mPoint`
		if [[ ! "$fSystem" == "nfs" ]]; then Errors="$Errors $i $mPoint," && echo "Error!! $mPoint no esta montado en $i" ; fi
	done 
########## Probamos /home/inb, cuando no es talairach talairach
	if [[ ! $i == "talairach" ]]
		then
		mPoint=/home/inb
		fSystem=`ssh $i stat -f -L -c %T $mPoint`
		if [[ ! "$fSystem" == "nfs" ]]
		then
		Errors="$Errors $i $mPoint," && echo "Error !! el directorio home no esta montado en $i"
		fi
        else
        	 if [[ $(qstat -u "*"   | grep Eqw | wc -l) > 0 ]]; then Errors="$Errors Trabajos con errores en el cluster" && echo "Existen trabajos con errores en el cluster" ;fi
	fi
done
########## And spit out some results
if [ ! -z "$Errors" ]
	then
	echo "THERE ARE MOUNTING ERRORS:"
	echo "$Errors"
	./fmrilab_aviso_correo.sh -c nekrum@gmail.com -m "$Errors" -e "Errores en el Cluster" 	
	else
	echo "Los puntos de montaje NFS no presentan problemas"
#	./fmrilab_aviso_correo.sh -c nekrum@gmail.com -m "$(date)" -e "No se encontraron errores en el cluster ni en el sistema NFS" 	
fi
