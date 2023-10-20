#!/bin/bash

# Enlista las sesiones de x2go abiertas en este nodo.
# Este script solo imprime bonito la info de x2golistsessions_root

# Robada del internet y modificada por Ricardo Rios


# Checar si soy sudo
if [ ! $(id -u) -eq 0 ]; then
	echo "Only sudo can do this"
	exit 2
fi

for ll in `sudo x2golistsessions_root`; do
  #Get the date of last use of the session
  lastd=`echo $ll | awk -F \| '{print $11}' | awk -F T '{print $1}';`
  #Date in seconds
  lastsec=`date -d "$lastd" +%s`
  #Current date in seconds
  now=`date +%s`
  days=`echo $(( ($now - $lastsec) /60/60/24 ))`
  

  sid=`echo $ll | awk -F \| '{print $2}'`
  echo "session: $sid, $days days old, lastd: $lastd"


done
