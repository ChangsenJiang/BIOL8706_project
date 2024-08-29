#!/bin/bash

# Define the path to the command file
echo "Current working directory: $(pwd)"cd
commandFilePath="/data/changsen/10exon_try/iqtree_commands.txt"

# Read commands into an array
mapfile -t commands < "$commandFilePath"

# Start a background process for each command read from the array
for cmd in "${commands[@]}"; do
    eval "$cmd" &
done

# Wait for all background processes to complete
wait

# Display process outputs (if needed)
# As outputs from background processes are already displayed during execution, this step can generally be omitted

# Clean up all processes (no additional cleanup needed in bash after using `wait`)

