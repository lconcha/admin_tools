#!/bin/bash


fmrilab_misc=/home/inb/lconcha/fmrilab_auto.misc

tmpMisc=/tmp/tmpMisc_$$


sudo cp /etc/auto.misc /etc/auto.misc.bak
sudo cp $fmrilab_misc /etc/auto.misc

sudo service autofs restart
