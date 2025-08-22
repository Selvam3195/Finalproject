#!/bin/bash
set -e

echo "Deploying Docker container..."

# Stop and remove old container if running
docker stop react-app || true
docker rm react-app || true

# Pull latest image from DockerHub
docker pull cherry3104/react-app-prod:latest

# Run new container
docker run -d -p 80:80 --name react-app cherry3104/react-app-prod:latest

echo "Deployment successful!"
