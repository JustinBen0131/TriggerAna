#!/usr/bin/env bash
export USER="$(id -u -n)"
export LOGNAME=${USER}
export HOME=/sphenix/user/${LOGNAME}
export MYINSTALL="$HOME/install"

source /opt/sphenix/core/bin/sphenix_setup.sh -n
source /opt/sphenix/core/bin/setup_local.sh $MYINSTALL

events=$1
filename=$2
outname="CaloOutput_${filename%.*}.root"  # Strip the extension from the filename and append

root -b -l -q "macros/Fun4All_Calo_Emulator.C($events, \"$filename\", \"$outname\")"


universe                = vanilla
executable              = /sphenix/user/patsfan753/condor_calotreegen.sh
arguments               = 44686 $(filename) $(Cluster)
log                     = /sphenix/user/patsfan753/logs/job.$(Cluster).$(Process).log
output                  = /sphenix/user/patsfan753/out/job.$(Cluster).$(Process).out
error                   = /sphenix/user/patsfan753/err/job.$(Cluster).$(Process).err
request_memory          = 7GB
queue filename from /sphenix/u/patsfan753/scratch/analysis/calotriggeremulator/dst_calo_run2pp-00044686.list

