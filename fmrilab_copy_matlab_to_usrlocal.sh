#!/bin/bash

tarfile=/misc/mansfield/lconcha/TMP/my_matlab13.tar

if [ -d /usr/local/Matlab13-alt ]
then
  echo "Already copied. Bye"
  exit 0
fi


# Checar si soy sudo
if [ ! $(id -u) -eq 0 ]; then
	echo "Only sudo can do this"
	exit 2
fi





cd /usr/local

tar xvf $tarfile