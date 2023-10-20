#!/bin/bash

# Cierra las sesiones de x2go abiertas por mas de N días.
# Puede recibir un argumento N para definir el numero de dias limite de sesiones abiertas.
# Si no hay argumentos usa el default (hardcoded en 10)

# Robada del internet y modificada por Ricardo Rios

# Checar si soy sudo
if [ ! $(id -u) -eq 0 ]; then
	echo "Only sudo can do this"
	exit 2
fi

# hardcoded limit days
DEFAULT_LIMIT_DAYS=7

# Magia negra de bash para asignar variable default si no hay argumento de entrada en $1
LIMIT_DAYS="${1:-$DEFAULT_LIMIT_DAYS}"

for ll in `sudo x2golistsessions_root`; do
  #Get the date of last use of the session
  lastd=`echo $ll | awk -F \| '{print $11}' | awk -F T '{print $1}';`
  #Date in seconds
  lastsec=`date -d "$lastd" +%s`
  #Current date in seconds
  now=`date +%s`
  days=`echo $(( ($now - $lastsec) /60/60/24 ))`
  if [[ $days -gt $LIMIT_DAYS ]]; then
    sid=`echo $ll | awk -F \| '{print $2}'`
    echo "terminating session: $sid, $days days old, lastd: $lastd, lastsec: $lastsec, now: $now"
    sudo x2goterminate-session $sid
  fi
done
