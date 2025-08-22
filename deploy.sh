#!/bin/bash
set -e

echo "Deploying with docker-compose..."

# Navigate to project folder (adjust if needed)
cd /home/ubuntu/pro

# Pull the latest image
docker compose pull

# Stop and remove old containers
docker compose down

# Start fresh containers
docker compose up -d --build

echo "Deployment completed!"
