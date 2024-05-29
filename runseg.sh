#!/bin/bash

if [ -n "$SEG_DEBUG" ] ; then
  set -x
  env | sort
fi

cd $WEST_SIM_ROOT
mkdir -pv $WEST_CURRENT_SEG_DATA_REF
cd $WEST_CURRENT_SEG_DATA_REF

cp $WEST_SIM_ROOT/CONFIG/closed.prmtop .
cp $WEST_SIM_ROOT/analysis.cpptraj .

if [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_CONTINUES" ]; then
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/CONFIG/prod.in > prod.in
  cp $WEST_PARENT_DATA_REF/seg.rst ./parent.rst
elif [ "$WEST_CURRENT_SEG_INITPOINT_TYPE" = "SEG_INITPOINT_NEWTRAJ" ]; then
  sed "s/RAND/$WEST_RAND16/g" $WEST_SIM_ROOT/CONFIG/prod_init.in > prod.in
  cp $WEST_PARENT_DATA_REF ./parent.rst
fi

export CUDA_DEVICES=(`echo $CUDA_VISIBLE_DEVICES_ALLOCATED | tr , ' '`)
export CUDA_VISIBLE_DEVICES=${CUDA_DEVICES[$WM_PROCESS_INDEX]}

echo "RUNSEG.SH: CUDA_VISIBLE_DEVICES_ALLOCATED = " $CUDA_VISIBLE_DEVICES_ALLOCATED
echo "RUNSEG.SH: WM_PROCESS_INDEX = " $WM_PROCESS_INDEX
echo "RUNSEG.SH: CUDA_VISIBLE_DEVICES = " $CUDA_VISIBLE_DEVICES

while ! [grep -q "Final Performance Info" seg.log]; do 
  $PMEMD -O -i prod.in -o seg.log -p closed.prmtop -c parent.rst -r seg.rst -x seg.nc 
done

$CPPTRAJ -i analysis.cpptraj

#cat rbd_rmsdA.dat | tail -n +2 | awk '{print $2}' > $WEST_PCOORD_RETURN
paste <(cat rbd_comA.dat | tail -n +2 | awk {'print $2'}) <(cat rbd_rmsdA.dat | tail -n +2 | awk {'print $2'})>$WEST_PCOORD_RETURN

cat rbd_rmsdB.dat | tail -n +2 | awk {'print $2'} > $WEST_RBD_RMSDB_RETURN
cat rbd_rmsdC.dat | tail -n +2 | awk {'print $2'} > $WEST_RBD_RMSDC_RETURN

cat rbd_comB.dat | tail -n +2 | awk {'print $2'} > $WEST_RBD_COMB_RETURN
cat rbd_comC.dat | tail -n +2 | awk {'print $2'} > $WEST_RBD_COMC_RETURN

cat coreA_nb.dat | tail -n +2 | awk {'print $2'} > $WEST_COREA_VDW_RETURN
cat coreA_nb.dat | tail -n +2 | awk {'print $3'} > $WEST_COREA_ELEC_RETURN
cat coreB_nb.dat | tail -n +2 | awk {'print $2'} > $WEST_COREB_VDW_RETURN
cat coreB_nb.dat | tail -n +2 | awk {'print $3'} > $WEST_COREB_ELEC_RETURN
cat coreC_nb.dat | tail -n +2 | awk {'print $2'} > $WEST_COREC_VDW_RETURN
cat coreC_nb.dat | tail -n +2 | awk {'print $3'} > $WEST_COREC_ELEC_RETURN
cat rbdA_nb.dat | tail -n +2 | awk {'print $2'} > $WEST_RBDA_VDW_RETURN
cat rbdA_nb.dat | tail -n +2 | awk {'print $3'} > $WEST_RBDA_ELEC_RETURN
cat rbdB_nb.dat | tail -n +2 | awk {'print $2'} > $WEST_RBDB_VDW_RETURN
cat rbdB_nb.dat | tail -n +2 | awk {'print $3'} > $WEST_RBDB_ELEC_RETURN
cat rbdC_nb.dat | tail -n +2 | awk {'print $2'} > $WEST_RBDC_VDW_RETURN
cat rbdC_nb.dat | tail -n +2 | awk {'print $3'} > $WEST_RBDC_ELEC_RETURN

cat A.R457_B.D364_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_R457_B_D364_RETURN
cat A.D427_C.K986_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_D427_C_K986_RETURN
cat A.D427_C.R457_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_D427_C_R457_RETURN
cat A.R408_C.D427_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_R408_B_D427_RETURN
cat A.D427_C.R408_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_D427_C_R408_RETURN
cat A.D420_A.K458_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_D420_A_K458_RETURN
cat A.R408_C.D405_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_R408_C_D405_RETURN
cat A.R466_B.E132_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_R466_B_E132_RETURN
cat A.D428_C.R454_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_D428_C_R454_RETURN
cat C.K986_C.E748_min.dat | tail -n +2 | awk {'print $4'} > $WEST_C_K986_C_E748_RETURN
cat C.K986_C.E990_min.dat | tail -n +2 | awk {'print $4'} > $WEST_C_K986_C_E990_RETURN 

cat A.T415_A.D420_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_T415_A_D420_RETURN
cat A.T415_B.Y369_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_T415_B_Y369_RETURN
cat A.T415_A.Q414_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_T415_A_Q414_RETURN
cat A.T415_C.D985_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_T415_C_D985_RETURN
cat A.T415_C.K986_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_T415_C_K986_RETURN
cat A.T415_B.S383_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_T415_B_S383_RETURN
cat A.T415_B.T385_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_T415_B_T385_RETURN

cat A.S371_C.R457_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_S371_C_R457_RETURN
cat A.S375_C.R457_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_S375_C_R457_RETURN
cat A.Y369_C.R457_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_Y369_C_R457_RETURN
cat A.K462_B.D198_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_K462_B_D198_RETURN
cat A.D467_A.Y351_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_D467_A_Y351_RETURN
cat A.Y495_A.E406_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_Y495_A_E406_RETURN

cat A.F456_B.N343g_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_F456_B_N343_MIN_RETURN 
cat A.Y489_B.N343g_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_Y489_B_N343_MIN_RETURN
cat A.F490_B.N343g_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_F490_B_N343_MIN_RETURN
cat A.R457_B.N343g_min.dat | tail -n +2 | awk {'print $4'} > $WEST_A_R457_B_N343_MIN_RETURN

cat A.F456_B.N343g_com.dat | tail -n +2 | awk {'print $2'} > $WEST_A_F456_B_N343_COM_RETURN
cat A.Y489_B.N343g_com.dat | tail -n +2 | awk {'print $2'} > $WEST_A_Y489_B_N343_COM_RETURN
cat A.F490_B.N343g_com.dat | tail -n +2 | awk {'print $2'} > $WEST_A_F490_B_N343_COM_RETURN
cat A.R457_B.N343g_com.dat | tail -n +2 | awk {'print $2'} > $WEST_A_R457_B_N343_COM_RETURN

mv seg_nosolvent.nc seg.nc
rm -f prod.in closed.prmtop analysis.cpptraj
