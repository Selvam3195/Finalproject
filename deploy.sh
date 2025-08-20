#!/bin/bash
SERVICE_NAME="react-app"
echo "Deploying Docker container..."
docker-compose up -d --build
if [ $? -eq 0 ]; then
  echo "Deployment successfull"
else
  echo "Deployment failed!"
  exit 1
fi
