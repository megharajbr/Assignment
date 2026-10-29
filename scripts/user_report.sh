#!/bin/bash
# Purpose: Report users with UID 1000 or above.
# Author: Ubuntu user
# Date: 2026-10-22
# Usage: ./scripts/user_report.sh

set -euo pipefail

print_header() {
    printf '%-25s %-10s %-35s %-20s\n' \
        "USERNAME" "UID" "HOME DIRECTORY" "SHELL"
    printf '%s\n' '------------------------------------------------------------------------------------------'
}

print_header

while IFS=: read -r username password uid gid gecos home shell; do
    if [[ "$uid" =~ ^[0-9]+$ ]] && (( uid >= 1000 )); then
        printf '%-25s %-10s %-35s %-20s\n' \
            "$username" "$uid" "$home" "$shell"
    fi
done < /etc/passwd
