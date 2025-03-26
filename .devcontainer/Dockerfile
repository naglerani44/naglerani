# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install essential tools & performance tuning
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y     curl git nano vim python3 python3-pip nodejs npm     build-essential cmake htop neofetch tlp     zram-tools docker.io     && apt clean && rm -rf /var/lib/apt/lists/*

# Enable ZRAM for better memory management
RUN echo 'ALGO=lz4' > /etc/default/zramswap &&     echo 'PERCENT=50' >> /etc/default/zramswap &&     systemctl enable zramswap

# Enable Docker service
RUN systemctl enable docker

# Set working directory
WORKDIR /workspaces/naglerani

# Default shell
CMD ["/bin/bash"]
