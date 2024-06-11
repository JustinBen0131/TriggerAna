#!/usr/bin/env bash
export USER="$(id -u -n)"
export LOGNAME=${USER}
export HOME=/sphenix/user/${LOGNAME}
export MYINSTALL="$HOME/install"

source /opt/sphenix/core/bin/sphenix_setup.sh -n
source /opt/sphenix/core/bin/setup_local.sh $MYINSTALL

# Capture command line arguments
runNumber=$1
filename=$2
clusterID=$3

# Create a directory based on the run number
outputDir="/sphenix/user/patsfan753/output/${runNumber}"
mkdir -p ${outputDir}  # Ensure the directory exists

# Construct the output filename within the new directory
outname="${outputDir}/CaloOutput_${filename%.*}.root"  # Strip the extension from the filename and append

# Define the log file path
logFile="${outputDir}/CaloOutput_${filename%.*}_log.txt"

# Run the ROOT macro with dynamically generated output path and log the output
root -b -l -q "macros/Fun4All_Calo_Emulator.C($events, \"$filename\", \"$outname\")" &> $logFile


universe                = vanilla
executable              = /sphenix/user/patsfan753/condor_calotreegen.sh
arguments               = 44686 $(filename) $(Cluster)
log                     = log/job.$(Cluster).$(Process).log
output                  = stdout/job.$(Cluster).$(Process).out
error                   = error/job.$(Cluster).$(Process).err
request_memory          = 7GB
queue filename from /sphenix/u/patsfan753/scratch/analysis/calotriggeremulator/dst_calo_run2pp-00044686.list
