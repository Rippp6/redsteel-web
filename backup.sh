#!/bin/bash
# RedSteel Landing - Database Backup Script
# Run daily via cron: 0 3 * * * /opt/redsteel/backup.sh

BACKUP_DIR="/opt/redsteel/backups"
mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="$BACKUP_DIR/redsteel_backup_$TIMESTAMP.sql"

source /opt/redsteel/.env
docker exec redsteel-db sh -c "MYSQL_PWD=$MYSQL_PASSWORD mysqldump -u redsteel_user redsteel" > "$BACKUP_FILE"

# Keep only last 7 daily backups
find "$BACKUP_DIR" -name "redsteel_backup_*.sql" -mtime +7 -delete

echo "Backup completed: $BACKUP_FILE ($(du -h "$BACKUP_FILE" | cut -f1))"
