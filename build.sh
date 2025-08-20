#!/bin/bash
IMAGE_NAME="my-react-app"
IMAGE_TAG="latest"

echo "Building Docker image: $IMAGE_NAME:$IMAGE_TAG ..."
docker build -t $IMAGE_NAME:$IMAGE_TAG .

if [ $? -eq 0 ]; then
  echo "Docker image built successfully!"
else
  echo "Docker build failed!"
  exit 1
fi
