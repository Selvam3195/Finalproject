#!/bin/bash
set -e

echo "Deploying with docker-compose..."

# Pull latest image
docker compose pull

# Restart container
docker compose up -d

echo "Deployment successful!"
