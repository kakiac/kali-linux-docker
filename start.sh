#!/bin/bash

# Kali Linux Docker - Start Script
# This script builds and starts the Kali Linux Docker container

set -e

echo "=================================="
echo "Kali Linux Docker Environment"
echo "=================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed. Please install Docker first."
    exit 1
fi

# Detect Docker Compose command (v1 uses docker-compose, v2 uses docker compose)
if command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
elif docker compose version &> /dev/null 2>&1; then
    DOCKER_COMPOSE="docker compose"
else
    echo "Error: Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "Using Docker Compose command: $DOCKER_COMPOSE"
echo ""

# Create workspace directories if they don't exist
echo "Creating workspace directories..."
mkdir -p workspace labs tools

# Check if image exists, if not build it
if [[ "$(docker images -q kali-linux-edu:latest 2> /dev/null)" == "" ]]; then
    echo "Building Kali Linux Docker image (this may take a while)..."
    $DOCKER_COMPOSE build
else
    echo "Kali Linux image already exists. Skipping build."
    echo "To rebuild, run: $DOCKER_COMPOSE build --no-cache"
fi

# Start the container
echo ""
echo "Starting Kali Linux container..."
$DOCKER_COMPOSE up -d

# Check if container is running
if [ "$(docker ps -q -f name=kali-linux-classroom)" ]; then
    echo ""
    echo "✓ Kali Linux container is running!"
    echo ""
    echo "To access the container shell, run:"
    echo "  ./shell.sh"
    echo ""
    echo "To stop the container, run:"
    echo "  ./stop.sh"
    echo ""
else
    echo ""
    echo "✗ Failed to start the container. Please check Docker logs."
    $DOCKER_COMPOSE logs
    exit 1
fi
