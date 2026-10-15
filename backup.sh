#!/bin/bash

SOURCE="$HOME/devops-ass"
BACKUP_DIR="$HOME/backups"

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/devops-ass-$(date +%Y%m%d-%H%M%S).tar.gz" \
    -C "$HOME" devops-ass

echo "Backup completed."
ls -lh "$BACKUP_DIR"
