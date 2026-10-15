#!/bin/bash
echo "Backup script started"
tar -czf "$HOME/backup_$(date +%F_%H%M%S).tar.gz" "$HOME/assignment2"
echo "Backup completed"
