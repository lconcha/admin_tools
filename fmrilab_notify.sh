#!/bin/bash
msg=$1

hosts=$(qconf -sel)

hosts=lauterbur.inb.unam.mx

for h in $hosts
do
    echo "Sending message to $h"
    #continue
    #ssh -X soporte@${h} \
    #zenity \
    #    --notification \
    #    --text='"'${msg}'"'
    #ssh $h \
    wall "${msg}"
done





    # notify-send \
    #   \'Mensaje de Don Clusterio\' \
    #   '"'$msg'"' \
    #   --icon=dialog-information