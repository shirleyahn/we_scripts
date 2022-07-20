# we_scripts

Originally prepared by Terra Sztain and Surl-Hee Ahn for spike WE simulations with Amber simulation engine\
Has been further revised/adapted for minimal adaptive binning (MAB) scheme and WESTPA 2.0 by Surl-Hee Ahn\
These scripts can be used and adapted for other WE simulations\
\
CONFIG: contains files needed to start the simulation for each segment/walker\
bstates: contains initial starting structures for the WE simulation\
BASIS_STATES lists bstates with probabilities/weights\ 
analysis.cpptraj is used during runseg.sh to extract progress coordinate and auxdata values at each iteration\
env.sh sets up the computing environment\
get_pcoord.sh extracts the progress coordinate values for the initial starting structures (only used for the very first iteration)\
init.sh is used to initialize the WE simulation (only used for the very first iteration)\
node.sh is used to run the simulations for each node\
post_iter.sh is used at the post-processing step of each iteration (usually to tar and compress seg_logs and traj_segs)\
runseg.sh is used to run each segment/walker at each iteration\
runwe.sh is the main script to submit on the supercomputer cluster to execute the WE simulation\
west.cfg is the main configuration file for the WE simulation that sets up the number of progress coordinates, number of iterations, etc.
