#!/bin/bash

set -x
export WEST_SIM_ROOT=$PWD
cd $WEST_SIM_ROOT
source ~/.bashrc
conda activate westpa
source env.sh || exit 1
env | sort
SERVER_INFO=$WEST_SIM_ROOT/west_zmq_info.json

#TODO: set num_gpu_per_node
num_gpu_per_node=5

# start server
w_run --work-manager=zmq --n-workers=0 --zmq-mode=master --zmq-write-host-info=$SERVER_INFO --zmq-comm-mode=tcp &> west-local.log &

# wait on host info file up to 1 min
for ((n=0; n<60; n++)); do
    if [ -e $SERVER_INFO ] ; then
        echo "== server info file $SERVER_INFO =="
        cat $SERVER_INFO
        break
    fi
    sleep 1
done

# exit if host info file doesn't appear in one minute
if ! [ -e $SERVER_INFO ] ; then
    echo 'server failed to start'
    exit 1
fi

export node=0
export CUDA_VISIBLE_DEVICES=0,1,2,3,4
$WEST_SIM_ROOT/node.sh $WEST_SIM_ROOT $node $CUDA_VISIBLE_DEVICES --work-manager=zmq --n-workers=$num_gpu_per_node --zmq-mode=client --zmq-read-host-info=$SERVER_INFO --zmq-comm-mode=tcp &
wait
