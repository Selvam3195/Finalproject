#!/bin/bash

# Variables
SERVICE_NAME="react-app"

echo "📦 Deploying Docker container..."

# Stop old container if running
docker compose down

# Start with new build
docker compose up -d --build

if [ $? -eq 0 ]; then
  echo "✅ Deployment successful! Service is running."
  echo "👉 Check app at: http://localhost:3000"
else
  echo "❌ Deployment failed!"
  exit 1
fi

