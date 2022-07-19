#!/bin/bash 

source env.sh

SFX=.d$$
mv traj_segs{,$SFX}
mv seg_logs{,$SFX}
mv istates{,$SFX}
rm -Rf traj_segs$SFX seg_logs$SFX istates$SFX & disown %1
rm -f system.h5 west.h5 seg_logs.tar 
rm -rf traj_segs seg_logs istates west.h5 west*.log *.json *txt *out *err
mkdir seg_logs traj_segs istates

BSTATE_ARGS="--bstate-file $WEST_SIM_ROOT/BASIS_STATES"
#TSTATE_ARGS="--tstate-file $WEST_SIM_ROOT/TSTATE"

# Run w_init
w_init \
  $BSTATE_ARGS \
  $TSTATE_ARGS \
  --segs-per-state 5 \
  --work-manager=threads "$@"
