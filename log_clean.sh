#!/bin/bash

LOG_DIR="$HOME/devops-ass"
find "$LOG_DIR" -type f -name "*.log" -mtime +7 -print

echo "Log cleanup check completed."
