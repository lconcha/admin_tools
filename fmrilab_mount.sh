#!/bin/bash
if [ $# -eq 0 ]
        then
        echo "Falta punto de montaje"
        exit 0
fi
sudo mount /datos/$1
