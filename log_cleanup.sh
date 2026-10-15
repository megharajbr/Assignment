#!/bin/bash
find "$HOME/assignment2" -type f -name "*.log" -mtime +7 -print
