#!/bin/bash
set -e

# Load environment variables
if [ -f /multi.env ]; then
    export $(grep -v '^#' /multi.env | xargs)
fi

# Debugging: Print environment variables
echo "🔍 Debug: Checking environment variables..."
echo "BANDWIDTH_DOWNLOAD=${BANDWIDTH_DOWNLOAD:-MISSING}"
echo "BANDWIDTH_UPLOAD=${BANDWIDTH_UPLOAD:-MISSING}"
echo "STORAGE=${STORAGE:-MISSING}"
echo "IDENTIFIER=${IDENTIFIER:-MISSING}"
echo "PIN=${PIN:-MISSING}"

# Ensure all required variables are set
if [[ -z "$BANDWIDTH_DOWNLOAD" || -z "$BANDWIDTH_UPLOAD" || -z "$STORAGE" || -z "$IDENTIFIER" || -z "$PIN" ]]; then
    echo "❌ Error: Missing required environment variables!"
    exit 1
fi

# Ensure previous instance is stopped
process_name="multiple-node"
pid=$(pgrep -f "$process_name" | awk '{print $1}')
if [[ -n $pid ]]; then
    echo "🛑 Stopping existing multiple-node process..."
    kill -9 "$pid"
fi

# Run installation
echo "📦 Running installation..."
source /install.sh

# Run update script
echo "🔄 Checking for updates..."
source /update.sh

# Start the service
echo "🚀 Starting multiple-node..."
source /start.sh

# ✅ Smart Wait: Ensure multiple-node is running properly
echo "⏳ Waiting for multiple-node to be fully ready..."
for i in {1..15}; do
    if pgrep -f "multiple-node" > /dev/null; then
        echo "✅ multiple-node is running!"
        break
    fi
    echo "⌛ Waiting... ($i/15)"
    sleep 5
done

# Check if multiple-node is running before proceeding
if ! pgrep -f "multiple-node" > /dev/null; then
    echo "❌ Error: multiple-node failed to start!"
    exit 1
fi

# 🔥 **Restart multiple-node to ensure a clean state before binding**
echo "🔄 Restarting multiple-node before binding..."
pkill -f multiple-node
sleep 5
nohup ./multipleforlinux/multiple-node > output.log 2>&1 &

# ✅ Smart Retry: Attempt binding multiple times if it fails
echo "🔗 Binding account..."
for attempt in {1..5}; do
    multipleforlinux/multiple-cli bind --bandwidth-download "$BANDWIDTH_DOWNLOAD" --identifier "$IDENTIFIER" --pin "$PIN" --storage "$STORAGE" --bandwidth-upload "$BANDWIDTH_UPLOAD" && break
    echo "⚠️ Bind attempt $attempt failed. Retrying in 10 seconds..."
    sleep 10
done

echo "✅ Node binding successful!"
tail -f /dev/null  # Keep container running
