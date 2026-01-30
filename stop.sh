#!/bin/bash

# Kali Linux Docker - Stop Script
# This script stops the Kali Linux Docker container

set -e

echo "Stopping Kali Linux container..."
docker-compose down

echo "✓ Kali Linux container stopped successfully."
