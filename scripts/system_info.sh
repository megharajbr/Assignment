#!/bin/bash
# Purpose: Display system information and warn if disk usage exceeds 80%.
# Author: Ubuntu user
# Date: 2026-10-22
# Usage: ./scripts/system_info.sh

set -euo pipefail

HOSTNAME_VALUE=$(hostname)
CURRENT_USER=$(whoami)
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S %Z')
OS_NAME=$(. /etc/os-release && echo "$PRETTY_NAME")
KERNEL=$(uname -r)
UPTIME_VALUE=$(uptime -p)
CPU_CORES=$(nproc)
TOTAL_MEMORY=$(free -h | awk '/^Mem:/ {print $2}')
AVAILABLE_MEMORY=$(free -h | awk '/^Mem:/ {print $7}')
DISK_USAGE=$(df -P / | awk 'NR==2 {gsub(/%/, "", $5); print $5}')
LOGGED_IN_USERS=$(who | wc -l)

echo "========== SYSTEM INFORMATION =========="
echo "Hostname:         $HOSTNAME_VALUE"
echo "Current user:     $CURRENT_USER"
echo "Date and time:    $CURRENT_DATE"
echo "Operating system: $OS_NAME"
echo "Kernel version:   $KERNEL"
echo "Uptime:           $UPTIME_VALUE"
echo "CPU cores:        $CPU_CORES"
echo "Total memory:     $TOTAL_MEMORY"
echo "Available memory: $AVAILABLE_MEMORY"
echo "Disk usage (/):   ${DISK_USAGE}%"
echo "Logged-in users:  $LOGGED_IN_USERS"
echo "========================================"

if (( DISK_USAGE > 80 )); then
    echo "WARNING: Root filesystem disk usage is above 80%!"
fi
