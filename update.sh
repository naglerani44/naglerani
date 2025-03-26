#!/bin/bash
set -e

echo "Checking for updates..."

# Check current version
current_version=$(multiple-cli --version)
echo "Current version: $current_version"

# Get latest version
latest_version=$(curl -s https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/version.txt)
echo "Latest version: $latest_version"

if [[ "$current_version" =~ "$latest_version" ]]; then
    echo "Multiple is up-to-date!"
else
    echo "Updating Multiple for Linux..."

    # Stop running process
    process_name="multiple-node"
    pid=$(pgrep -f "$process_name" | awk '{print $1}')
    if [[ -n $pid ]]; then
        echo "Stopping existing multiple-node process..."
        kill -9 "$pid"
    fi

    # Reinstall latest version
    source /install.sh
    echo "Update complete!"
fi
