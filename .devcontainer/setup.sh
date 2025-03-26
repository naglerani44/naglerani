#!/bin/bash

echo "🚀 Running post-creation setup for ULTRA MAX PERFORMANCE..."

# Update & install necessary tools
apt update && apt install -y     jq zip unzip python3-venv tlp     && apt clean && rm -rf /var/lib/apt/lists/*

# Enable CPU performance mode
echo performance | tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor

# Enable ZRAM swap
systemctl restart zramswap

# Install Node.js tools globally
npm install -g npm yarn pm2

# Increase file limits
echo '* soft nofile 1048576' | tee -a /etc/security/limits.conf
echo '* hard nofile 1048576' | tee -a /etc/security/limits.conf
ulimit -n 1048576

# Enable TLP for power management
systemctl enable tlp && systemctl start tlp

# Start Docker service
systemctl start docker


echo "✅ Setup complete! ULTRA OPTIMIZED Codespace is READY 🚀🔥"
