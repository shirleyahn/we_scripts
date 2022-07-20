#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

cd $WEST_SIM_ROOT

RMSD=$(mktemp)
COM=$(mktemp)
COMMAND="           parm $WEST_SIM_ROOT/CONFIG/closed.prmtop \n"
COMMAND="${COMMAND} trajin $WEST_STRUCT_DATA_REF \n"
COMMAND="${COMMAND} autoimage \n"
COMMAND="${COMMAND} parm $WEST_SIM_ROOT/CONFIG/6VSB_equil.pdb [open] \n"
COMMAND="${COMMAND} reference $WEST_SIM_ROOT/CONFIG/6VSB_equil.pdb parm $WEST_SIM_ROOT/CONFIG/6VSB_equil.pdb [open] \n"
COMMAND="${COMMAND} rmsd @CA&(:851-888,1050-1071,1090-1138,2151-2188,2350-2371,2390-2438,3439-3476,3638-3659,3678-3726) ref [open] @CA&(@14090-14668,17137-17478,17747-18525,35525-36103,38572-38913,39182-39960,56640-57218,59687-60028,60297-61075) \n"
COMMAND="${COMMAND} rmsd RMSDA @CA&(:363-368,382-392,419-426,496-505) ref [open] @CA&(@5683-5780,5959-6135,6533-6646,7712-7883) nofit out $RMSD \n"
COMMAND="${COMMAND} distance RBD_COMA @CA&(:851-888,1050-1071,1090-1138,2151-2188,2350-2371,2390-2438,3439-3476,3638-3659,3678-3726) @CA&(:363-368,382-392,419-426,496-505) out $COM \n"
COMMAND="${COMMAND} go"

echo -e "${COMMAND}" | $CPPTRAJ
#cat $RMSD | tail -n 1 | awk '{print $2}' > $WEST_PCOORD_RETURN
paste <(cat $COM | tail -n 1 | awk {'print $2'}) <(cat $RMSD | tail -n 1 | awk {'print $2'})>$WEST_PCOORD_RETURN

if [ -n "$SEG_DEBUG" ] ; then
    head -v $WEST_PCOORD_RETURN
fi
