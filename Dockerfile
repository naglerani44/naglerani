# Use Ubuntu 22.04 as base image
FROM ubuntu:22.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies including required .NET libraries
RUN apt-get update && apt-get install -y \
    wget tar curl apt-transport-https \
    libicu-dev libssl-dev libgssapi-krb5-2 zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy scripts
COPY entrypoint.sh /entrypoint.sh
COPY install.sh /install.sh
COPY update.sh /update.sh
COPY start.sh /start.sh
COPY multi.env /multi.env

# Set permissions
RUN chmod +x /entrypoint.sh /install.sh /update.sh /start.sh

# Entrypoint to start the service
ENTRYPOINT ["/entrypoint.sh"]
