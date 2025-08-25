#!/bin/bash
URL="http://<EC2_PUBLIC_IP>:3000"

if curl -s --head "$URL" | grep "200 OK" > /dev/null; then
  echo "Application is UP!"
  exit 0
else
  echo "Application is DOWN!"
  exit 1
fi
