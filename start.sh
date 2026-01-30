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

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "Error: Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Create workspace directories if they don't exist
echo "Creating workspace directories..."
mkdir -p workspace labs tools
touch workspace/.gitkeep labs/.gitkeep tools/.gitkeep

# Check if image exists, if not build it
if [[ "$(docker images -q kali-linux-edu:latest 2> /dev/null)" == "" ]]; then
    echo "Building Kali Linux Docker image (this may take a while)..."
    docker-compose build
else
    echo "Kali Linux image already exists. Skipping build."
    echo "To rebuild, run: docker-compose build --no-cache"
fi

# Start the container
echo ""
echo "Starting Kali Linux container..."
docker-compose up -d

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
    docker-compose logs
    exit 1
fi
