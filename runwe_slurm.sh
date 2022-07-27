#!/bin/bash
#SBATCH -p development
#SBATCH -J original
#SBATCH -o original.%j.%N.out
#SBATCH -e original.%j.%N.err
#SBATCH -N 1
#SBATCH -n 100
#SBATCH -t 2:00:00
#SBATCH -A MCB20024
#SBATCH --mail-type=all
#SBATCH --mail-user=s3ahn@ucsd.edu

set -x
cd $SLURM_SUBMIT_DIR
source ~/.profile
export MY_SPECTRUM_OPTIONS="--gpu"
export PATH=$PATH:$HOME/bin

module purge
module load launcher_gpu/1.1
module load cuda/10.2
module load xl/16.1.1
module load mvapich2-gdr/2.3.4
module load gcc/7.3.0
module load amber/20
module load conda
conda activate westpa
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
export WEST_SIM_ROOT=$SLURM_SUBMIT_DIR
export PYTHONPATH=/scratch/07418/s3ahn/mdtraj/lib/python3.7/site-packages:/scratch/07418/s3ahn/conda_local/envs/westpa/bin/python

source env.sh || exit 1
env | sort

SERVER_INFO=$WEST_SIM_ROOT/west_zmq_info-$SLURM_JOBID.json

#TODO: set num_gpu_per_node
num_gpu_per_node=4
rm -rf nodefilelist.txt
scontrol show hostname $SLURM_JOB_NODELIST > nodefilelist.txt

# start server
w_run --work-manager=zmq --n-workers=0 --zmq-mode=master --zmq-write-host-info=$SERVER_INFO --zmq-comm-mode=tcp &> west-$SLURM_JOBID-local.log &

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
export CUDA_VISIBLE_DEVICES=0,1,2,3
for node in $(cat nodefilelist.txt); do
    ssh -o StrictHostKeyChecking=no $node $PWD/node.sh $SLURM_SUBMIT_DIR $SLURM_JOBID $node $CUDA_VISIBLE_DEVICES --work-manager=zmq --n-workers=$num_gpu_per_node --zmq-mode=client --zmq-read-host-info=$SERVER_INFO --zmq-comm-mode=tcp &
done
wait
