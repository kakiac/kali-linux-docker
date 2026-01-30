#!/bin/bash

# Kali Linux Docker - Shell Access Script
# This script provides shell access to the running Kali Linux container

set -e

# Check if container is running
if [ ! "$(docker ps -q -f name=kali-linux-classroom)" ]; then
    echo "Error: Kali Linux container is not running."
    echo "Please start it first with: ./start.sh"
    exit 1
fi

echo "Connecting to Kali Linux container..."
echo "Type 'exit' to return to your host system."
echo ""

# Connect to the container as kali user
docker exec -it kali-linux-classroom /bin/bash
