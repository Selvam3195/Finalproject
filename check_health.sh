#!/bin/bash

APP_URL="http://your-app-domain:port/health"

status_code=$(curl -o /dev/null -s -w "%{http_code}\n" $APP_URL)

if [ "$status_code" -ne 200 ]; then
    echo "DOWN"
    exit 1
else
    echo "UP"
    exit 0
fi
