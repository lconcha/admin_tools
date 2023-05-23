#!/bin/bash


fullHosts=/home/inb/lconcha/fmrilab_hosts.txt

tmphosts=/tmp/tmphosts_$$

echo "127.0.0.1	localhost" > $tmphosts
#echo "127.0.1.1	`uname -n`.inb.unam.mx	`uname -n`" >> $tmphosts
cat $fullHosts >> $tmphosts 

echo ""
cat $tmphosts

sudo cp /etc/hosts /etc/hosts.old
sudo mv $tmphosts /etc/hosts
