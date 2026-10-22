#!/bin/bash
# Purpose: Compress log files older than seven days.
# Author: Ubuntu user
# Date: 2026-10-22
# Usage: ./scripts/log_cleanup.sh [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/webapp/config/app.conf"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "ERROR: Config file not found: $CONFIG_FILE" >&2
    exit 1
fi

# Read LOG_DIR from the configuration file.
LOG_DIR=$(awk -F= '$1 == "LOG_DIR" {print substr($0, index($0, "=") + 1); exit}' "$CONFIG_FILE")

if [[ -z "$LOG_DIR" ]]; then
    echo "ERROR: LOG_DIR is not set in $CONFIG_FILE" >&2
    exit 1
fi

if [[ ! -d "$LOG_DIR" ]]; then
    echo "ERROR: Log directory does not exist: $LOG_DIR" >&2
    exit 1
fi

dry_run=false

if [[ "${1:-}" == "--dry-run" ]]; then
    dry_run=true
elif [[ $# -gt 0 ]]; then
    echo "Usage: $0 [--dry-run]" >&2
    exit 2
fi

mapfile -d '' old_logs < <(find "$LOG_DIR" -maxdepth 1 -type f -name '*.log' -mtime +7 -print0)

if [[ "$dry_run" == true ]]; then
    echo "Dry run: files that would be compressed:"
    printf '%s\n' "${old_logs[@]:-}"
    echo "Files that would be compressed: ${#old_logs[@]}"
    exit 0
fi

count=0
for file in "${old_logs[@]}"; do
    [[ -n "$file" ]] || continue
    if gzip -- "$file"; then
        echo "Compressed: $file"
        ((count += 1))
    else
        echo "ERROR: Failed to compress $file" >&2
        exit 1
    fi
done

echo "Total files compressed: $count"
