#!/bin/bash

# Kali Linux Docker - Root Shell Access Script
# This script provides root shell access to the running Kali Linux container

set -e

# Check if container is running
if [ ! "$(docker ps -q -f name=kali-linux-classroom)" ]; then
    echo "Error: Kali Linux container is not running."
    echo "Please start it first with: ./start.sh"
    exit 1
fi

echo "Connecting to Kali Linux container as root..."
echo "Warning: You are accessing the container with root privileges."
echo "Type 'exit' to return to your host system."
echo ""

# Connect to the container as root user
docker exec -it -u root kali-linux-classroom /bin/bash
