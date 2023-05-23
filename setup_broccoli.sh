#!/bin/bash



export BROCCOLI_DIR=/home/inb/adeleon/BROCCOLI/BROCCOLI-master/
export PATH=$PATH:${BROCCOLI_DIR}compiled/Bash/Linux/Release
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${BROCCOLI_DIR}/code/BROCCOLI_LIB/clBLASLinux

echolor cyan "  Setting up BROCCOLI."
echolor cyan "  BROCCOLI_DIR is $BROCCOLI_DIR"
