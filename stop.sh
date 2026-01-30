#!/bin/bash

# Kali Linux Docker - Stop Script
# This script stops the Kali Linux Docker container

set -e

# Detect Docker Compose command (v1 uses docker-compose, v2 uses docker compose)
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
elif docker compose version &> /dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
else
    echo "Error: Docker Compose is not installed."
    exit 1
fi

echo "Stopping Kali Linux container..."
$DOCKER_COMPOSE down

echo "✓ Kali Linux container stopped successfully."
