#!/bin/bash

# Set user-specific environment variables
export USER="$(id -u -n)"
export LOGNAME=${USER}
export HOME=/sphenix/u/${LOGNAME}  # Change according to specific user directories if necessary

# Source the necessary environment setup for Sphenix
source /opt/sphenix/core/bin/sphenix_setup.sh -n

# Print the environment variables for debugging
echo "Environment variables after sourcing sphenix_setup.sh:"
printenv

# Set additional environment paths
export LD_LIBRARY_PATH=$PWD/src/.libs:$LD_LIBRARY_PATH

# Assign script parameters
dst_file=$1
runnumber=$2
qa_output=$3
dst_output=$4
nEvents=$5

echo "Running Fun4All_Calo_Emulator with the following parameters:"
echo "DST file: $dst_file"
echo "Run number: $runnumber"
echo "QA output: $qa_output"
echo "DST output: $dst_output"
echo "Number of events: $nEvents"

# Ensure that the ROOT command is available
which root

# Check if the ROOT macro exists
if [ ! -f macros/Fun4All_Calo_Emulator.C ]; then
    echo "Error: ROOT macro 'macros/Fun4All_Calo_Emulator.C' not found"
    exit 1
fi

# Debugging: Print the content of the current directory
echo "Current directory content:"
ls -al

# Execute the ROOT macro and redirect output to log for debugging
root -b -q "macros/Fun4All_Calo_Emulator.C(\"$dst_file\", $runnumber, \"$qa_output\", \"$dst_output\", $nEvents)" >& root_execution.log

# Check the exit status of the ROOT command
exit_status=$?
echo "ROOT command exit status: $exit_status"


# Print the content of the log file
cat root_execution.log

# Check if the histogram file was created
if [ -f "$qa_output" ]; then
    echo "Histogram file $qa_output created successfully."
else
    echo "Error: Histogram file $qa_output was not created."
fi

# If there was an error, print a message and exit with the same status
if [ $exit_status -ne 0 ]; then
    echo "Error: ROOT command failed with exit status $exit_status"
    exit $exit_status
fi
