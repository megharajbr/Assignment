#!/bin/bash
# Purpose: Check whether requested systemd services are active.
# Author: Ubuntu user
# Date: 2026-10-22
# Usage: ./scripts/health_check.sh ssh cron nginx

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
LOG_FILE="$PROJECT_DIR/webapp/logs/health.log"

if (( $# == 0 )); then
    echo "Usage: $0 service1 [service2 ...]" >&2
    exit 2
fi

mkdir -p "$(dirname "$LOG_FILE")"
overall_status=0

for service in "$@"; do
    timestamp=$(date '+%Y-%m-%d %H:%M:%S %Z')

    if systemctl is-active --quiet "$service"; then
        message="[$timestamp] [OK] $service is active"
    else
        message="[$timestamp] [FAIL] $service is not active"
        overall_status=1
    fi

    echo "$message"
    echo "$message" >> "$LOG_FILE"
done

exit "$overall_status"
