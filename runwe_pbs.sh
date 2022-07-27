#!/bin/bash
#PBS -N chignolin
#PBS -e chignolin.err
#PBS -o chignolin.out
#PBS -k oe
#PBS -m aeb
#PBS -M s3ahn@ucsd.edu
#PBS -l nodes=1:ppn=9:gpu
#PBS -l walltime=168:00:00
#PBS -A mccammon-gpu
#PBS -q home-mccammon
#PBS -V

set -x
cd $PBS_O_WORKDIR
source /home/sahn/.condainit
source /home/sahn/.bashrc
conda activate westpa
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export WEST_SIM_ROOT=$PBS_O_WORKDIR
export PYTHONPATH=/home/sahn/anaconda2/envs/westpa/bin/python

#./init.sh
source env.sh || exit 1
env | sort

SERVER_INFO=$WEST_SIM_ROOT/west_zmq_info-$PBS_JOBID.json

#TODO: set num_gpu_per_node
num_gpu_per_node=3
rm -rf nodefilelist.txt
cat $PBS_NODEFILE | sort -u > nodefilelist.txt

# start server
w_run --work-manager=zmq --n-workers=0 --zmq-mode=master --zmq-write-host-info=$SERVER_INFO --zmq-comm-mode=tcp &> west-$PBS_JOBID.log &

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

for node in $(cat nodefilelist.txt); do
    ssh -o StrictHostKeyChecking=no $node $PWD/node.sh $PBS_O_WORKDIR $PBS_JOBID $node $CUDA_VISIBLE_DEVICES --work-manager=zmq --n-workers=$num_gpu_per_node --zmq-mode=client --zmq-read-host-info=$SERVER_INFO --zmq-comm-mode=tcp &
done
wait
