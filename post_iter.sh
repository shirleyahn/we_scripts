#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
    set -x
    env | sort
fi

cd $WEST_SIM_ROOT || exit 1

ITER=$(printf "%06d" $WEST_CURRENT_ITER)
TAR=$(($WEST_CURRENT_ITER-1))
TAR_DIR=$(printf "%06d" $TAR)
echo $ITER
echo $TAR
echo $TAR_DIR
if [ ! -e seg_logs/$ITER.tar ]; then
    tar -cf seg_logs/$ITER.tar seg_logs/$ITER-*.log
    rm  -f  seg_logs/$ITER-*.log
fi
#if [ -d traj_segs/$TAR_DIR ]; then
#  tar -cf traj_segs/$TAR_DIR.tar traj_segs/$TAR_DIR
#  rm -rf traj_segs/$TAR_DIR
#fi
