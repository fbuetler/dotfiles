#!/bin/bash

set -euo pipefail

# TODO create cronjob

ROOT_HOME=/root
USER_HOME=/home/florian

RESTIC_REPO=$USER_HOME/media/backup
RESTIC_LOG_DIR=$ROOT_HOME/restic-logs
RESTIC_PASSWORD_FILE=$ROOT_HOME/restic.password
RESTIC_EXCLUDE_FILE=$ROOT_HOME/restic-backup-exclude.txt

mkdir -p $RESTIC_LOG_DIR

restic \
    --repo "$RESTIC_REPO" \
    --password-file "$RESTIC_PASSWORD_FILE" \
    --verbose \
    backup \
    --one-file-system \
    --exclude-file "$RESTIC_EXCLUDE_FILE" \
    / \
| tee -a $RESTIC_LOG_DIR/log-$(date -d "today" +"%Y-%m-%d_%H:%M").log


