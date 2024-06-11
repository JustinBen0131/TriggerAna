#!/bin/bash

export LD_LIBRARY_PATH=$PWD/src/.libs:$LD_LIBRARY_PATH

list_file="/sphenix/user/patsfan753/analysis/calotriggeremulator/dst_calo_run2pp-00044686.list"
runnumber=44686
output_dir="/sphenix/user/patsfan753/analysis/calotriggeremulator/$runnumber"
job_arguments_file="job_arguments.txt"

mkdir -p $output_dir/Hists
mkdir -p $output_dir/DSTs

echo "Reading DST files from list: $list_file"
echo "Run number: $runnumber"
echo "Output directory: $output_dir"

# Variable to count processed files
file_count=0
max_local_files=2
nEvents_local=10

# Clear job arguments file
> $job_arguments_file

while IFS= read -r dst_file; do
    file_number=$(echo $dst_file | sed 's/.*-000//' | sed 's/.root//')
    qa_output="$output_dir/Hists/HIST_TRIGGER_QA-000$runnumber-$file_number.root"
    dst_output="$output_dir/DSTs/DST_EMULATOR-000$runnumber-$file_number.root"

    echo "Processing DST file: $dst_file"
    echo "File number: $file_number"
    echo "QA output: $qa_output"
    echo "DST output: $dst_output"

    if [[ $1 == "local" ]]; then
        # Run jobs locally using ROOT with a limit of 10 events
        root -b -q "macros/Fun4All_Calo_Emulator.C(\"$dst_file\", $runnumber, \"$qa_output\", \"$dst_output\", $nEvents_local)"
        # Increment the file counter
        file_count=$((file_count + 1))
        # Check if the file count has reached the maximum number of local files
        if [[ $file_count -ge $max_local_files ]]; then
            break
        fi
    else
        # Add job arguments to the file
        echo "$dst_file $runnumber $qa_output $dst_output 0" >> $job_arguments_file
    fi
done < "$list_file"

if [[ $1 != "local" ]]; then
    # Submit jobs to Condor
    condor_submit condor.sub
fi

echo "All DST files processed and Condor jobs submitted."

