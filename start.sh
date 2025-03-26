#!/bin/bash
set -e

echo "Starting multiple-node..."

# Ensure previous instance is stopped
process_name="multiple-node"
pid=$(pgrep -f "$process_name" | awk '{print $1}')
if [[ -n $pid ]]; then
    echo "Process already running!"
else
    cd multipleforlinux
    nohup ./multiple-node > output.log 2>&1 &
    echo "Multiple-node started successfully!"
    cd ..
fi
