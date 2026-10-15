#!/bin/bash

echo "===== System Information ====="
echo "Hostname: $(hostname)"
echo "Current User: $(whoami)"
echo "Date: $(date)"
echo "Uptime:"
uptime
echo "Disk Usage:"
df -h
echo "Memory Usage:"
free -h
