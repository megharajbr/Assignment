#!/bin/bash

echo "===== Health Check ====="

echo "Checking disk usage..."
df -h /

echo "Checking memory..."
free -h

echo "Checking load average..."
uptime

echo "Health check completed."
