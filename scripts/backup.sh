#!/bin/bash
# Purpose: Back up webapp configuration and application files.
# Author: Ubuntu user
# Date: 2026-10-22
# Usage: ./scripts/backup.sh

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/webapp/config/app.conf"
LOG_FILE="$PROJECT_DIR/webapp/logs/backup.log"

log_message() {
    local message="$1"
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')" "$message" >> "$LOG_FILE"
}

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "ERROR: Config file not found: $CONFIG_FILE" >&2
    exit 1
fi

BACKUP_DIR=$(awk -F= '$1 == "BACKUP_DIR" {print substr($0, index($0, "=") + 1); exit}' "$CONFIG_FILE")

if [[ -z "$BACKUP_DIR" ]]; then
    echo "ERROR: BACKUP_DIR is not set in $CONFIG_FILE" >&2
    exit 1
fi

mkdir -p "$BACKUP_DIR" "$PROJECT_DIR/webapp/logs"

TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
ARCHIVE="$BACKUP_DIR/webapp_backup_${TIMESTAMP}.tar.gz"
TEMP_ARCHIVE="${ARCHIVE}.tmp"

cleanup() {
    rm -f -- "$TEMP_ARCHIVE"
}
trap cleanup EXIT

if tar -czf "$TEMP_ARCHIVE" -C "$PROJECT_DIR" webapp/config webapp/app &&
   tar -tzf "$TEMP_ARCHIVE" >/dev/null; then
    mv -- "$TEMP_ARCHIVE" "$ARCHIVE"

    FILE_COUNT=$(tar -tzf "$ARCHIVE" | wc -l)
    MESSAGE="SUCCESS: Created $ARCHIVE; verified $FILE_COUNT archive entries."
    echo "$MESSAGE"
    log_message "$MESSAGE"
else
    MESSAGE="FAILURE: Backup creation or verification failed for $ARCHIVE."
    echo "$MESSAGE" >&2
    log_message "$MESSAGE"
    exit 1
fi

mapfile -t BACKUPS < <(find "$BACKUP_DIR" -maxdepth 1 -type f -name 'webapp_backup_*.tar.gz' -printf '%f\n' | sort -r)

if (( ${#BACKUPS[@]} > 3 )); then
    for old_backup in "${BACKUPS[@]:3}"; do
        rm -f -- "$BACKUP_DIR/$old_backup"
        echo "Removed old backup: $old_backup"
    done
fi

echo "Backups currently retained:"
find "$BACKUP_DIR" -maxdepth 1 -type f -name 'webapp_backup_*.tar.gz' -printf '%f\n' | sort -r
