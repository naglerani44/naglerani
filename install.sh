#!/bin/bash
set -e

echo "Installing Multiple for Linux..."

# Determine system architecture
arch=$(arch)
download_url=""
if [[ $arch =~ "x86_64" ]]; then 
    download_url="https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/x64/multipleforlinux.tar"
elif [[ $arch =~ "aarch64" ]]; then 
    download_url="https://mdeck-download.s3.us-east-1.amazonaws.com/client/linux/arm64/multipleforlinux.tar"
else
    echo "Unsupported system architecture!"
    exit 1
fi

# Download and extract
wget -q $download_url -O multipleforlinux.tar
tar -xvf multipleforlinux.tar
rm -f multipleforlinux.tar

# Set permissions
chmod -R 777 multipleforlinux
chmod +x multipleforlinux/multiple-cli
chmod +x multipleforlinux/multiple-node

# Add to PATH
export PATH=$PATH:$(pwd)/multipleforlinux
source /etc/profile

echo "Installation complete!"
