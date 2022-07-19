# This file defines where WEST and GROMACS can be found
# Modify to taste
source ~/.profile
module purge
module load launcher_gpu/1.1
module load cuda/10.2
module load xl/16.1.1
module load mvapich2-gdr/2.3.4
module load gcc/7.3.0
module load amber/20
module load conda
#module unload python
conda activate westpa
export MY_SPECTRUM_OPTIONS="--gpu"
export PATH=$PATH:$HOME/bin
#export WEST_PYTHON=/scratch/07418/s3ahn/conda_local/bin/python3.8
export PYTHONPATH=/scratch/07418/s3ahn/mdtraj/lib/python3.7/site-packages:/scratch/07418/s3ahn/conda_local/envs/westpa/bin/python
#export WEST_ROOT=/scratch/07418/s3ahn/conda_local/westpa
#source /scratch/07418/s3ahn/conda_local/westpa/westpa.sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH
#export LD_PRELOAD=/opt/apps/gcc7_3/mvapich2-gdr/2.3.4/lib64/libmpi.so
#export MV2_ENABLE_AFFINITY=0
# Inform WEST where to find Python and our other scripts where to find WEST
#if [[ -z "$WEST_ROOT" ]]; then
    #echo "Must set environ variable WEST_ROOT"
    #exit
#fi
# Explicitly name our simulation root directory
if [[ -z "$WEST_SIM_ROOT" ]]; then
    export WEST_SIM_ROOT="$PWD"
fi
export SIM_NAME=$(basename $WEST_SIM_ROOT)
#export WEST_ROOT=$WEST_ROOT
echo "simulation $SIM_NAME root is $WEST_SIM_ROOT"

export NODELOC=/scratch/07418/s3ahn
export USE_LOCAL_SCRATCH=1

export WM_ZMQ_MASTER_HEARTBEAT=100
export WM_ZMQ_WORKER_HEARTBEAT=100
export WM_ZMQ_TIMEOUT_FACTOR=300
export BASH=$SWROOT/bin/bash
export PERL=$SWROOT/usr/bin/perl
export ZSH=$SWROOT/bin/zsh
export IFCONFIG=$SWROOT/bin/ifconfig
export CUT=$SWROOT/usr/bin/cut
export TR=$SWROOT/usr/bin/tr
export LN=$SWROOT/bin/ln
export CP=$SWROOT/bin/cp
export RM=$SWROOT/bin/rm
export SED=$SWROOT/bin/sed
export CAT=$SWROOT/bin/cat
export HEAD=$SWROOT/bin/head
export TAR=$SWROOT/bin/tar
export AWK=$SWROOT/usr/bin/awk
export PASTE=$SWROOT/usr/bin/paste
export GREP=$SWROOT/bin/grep
export SORT=$SWROOT/usr/bin/sort
export UNIQ=$SWROOT/usr/bin/uniq
export HEAD=$SWROOT/usr/bin/head
export MKDIR=$SWROOT/bin/mkdir
export ECHO=$SWROOT/bin/echo
export DATE=$SWROOT/bin/date
export SANDER=$AMBERHOME/bin/sander
export PMEMD=$AMBERHOME/bin/pmemd.cuda
export CPPTRAJ=$AMBERHOME/bin/cpptraj
