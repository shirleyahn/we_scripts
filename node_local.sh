#!/bin/bash -l

set -x
umask g+r
cd $1; shift
source env.sh
export NODENAME=$1; shift
export CUDA_VISIBLE_DEVICES_ALLOCATED=$1; shift
echo "starting WEST client processes on: "; hostname
echo "current directory is $PWD"
echo "environment is: "
env | sort

export CUDA_VISIBLE_DEVICES=0,1,2,3,4
echo "CUDA_VISIBLE_DEVICES = " $CUDA_VISIBLE_DEVICES
w_run "$@" &> west-$NODENAME-node.log
echo "Shutting down.  Hopefully this was on purpose?"
