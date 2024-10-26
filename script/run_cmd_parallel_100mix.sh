#!/bin/bash

# Print the current working directory
echo "Current working directory: $(pwd)"
commandFilePath="/data/changsen/iqtreecommand/iqtree_commands_100mixfull.txt"

# Read the command file, remove carriage returns, and pass the cleaned commands to parallel for execution
cat "$commandFilePath" | tr -d '\r' | parallel -j 128 --linebuffer
