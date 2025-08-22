#!/bin/bash

# Replace with your EC2 public IP or DNS
APP_URL="http://<EC2_PUBLIC_IP>:3000"

# Try to fetch the page
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $APP_URL)

if [ "$HTTP_STATUS" -ne 200 ]; then
  echo "Application is DOWN!"
  exit 1   # exit with non-zero to fail Jenkins stage
else
  echo "Application is UP!"
fi
