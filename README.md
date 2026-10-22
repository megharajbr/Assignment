# DevOps Assignment

## Overview
This project demonstrates Linux administration, shell scripting, and Git version control.

## Directory Structure
- `webapp/app/` - Application files.
- `webapp/config/` - Application configuration.
- `webapp/logs/` - Application and script logs.
- `webapp/backups/` - Compressed backup archives.
- `scripts/` - Automation scripts.
- `docs/` - Project documentation.

## Scripts

### system_info.sh
Displays hostname, user, date and time, operating system, kernel, uptime, CPU cores, memory, disk usage, and logged-in users.

Run:
`./scripts/system_info.sh`

### health_check.sh
Checks whether the specified systemd services are active and appends timestamped results to `webapp/logs/health.log`.

Run:
`./scripts/health_check.sh cron ssh`

### log_cleanup.sh
Compresses `.log` files older than seven days. Supports a dry-run mode.

Run:
`./scripts/log_cleanup.sh --dry-run`

### backup.sh
Creates and verifies timestamped backups of the application and configuration directories. Retains the latest three backups.

Run:
`./scripts/backup.sh`

### user_report.sh
Displays usernames, UIDs, home directories, and shells for users with UID 1000 or above.

Run:
`./scripts/user_report.sh`

## Requirements
- Linux with Bash
- systemd
- Git
- gzip and tar

## Usage
Make scripts executable with `chmod +x scripts/*.sh`, then run the desired script from the project root.
