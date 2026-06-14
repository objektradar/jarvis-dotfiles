#!/bin/bash
# Jarvis Backup — wichtige Configs + Docker Volumes
set -e
BACKUP_DIR="/opt/backups/$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

echo "=== Jarvis Backup ==="

# Docker Volumes
docker volume ls -q | while read vol; do
    echo "  backing up volume: $vol"
    docker run --rm -v "$vol":/data -v "$BACKUP_DIR":/backup alpine \
        tar czf "/backup/${vol}.tar.gz" -C /data . 2>/dev/null || echo "  ⚠️ $vol failed"
done

# Configs
for f in /opt/jarvis /opt/m365_token.json /root/.config/todoist/token /opt/jarvis/matrix; do
    [ -e "$f" ] && cp -a "$f" "$BACKUP_DIR/" 2>/dev/null && echo "  ✅ $f"
done

# Docker compose files
find /opt -name "docker-compose*" -o -name "compose*" 2>/dev/null | head -20 | while read f; do
    cp "$f" "$BACKUP_DIR/" 2>/dev/null && echo "  ✅ $f"
done

# Cleanup old backups (keep 7 days)
find /opt/backups -maxdepth 1 -type d -mtime +7 -exec rm -rf {} \; 2>/dev/null

echo "=== Backup complete: $BACKUP_DIR ==="
du -sh "$BACKUP_DIR"
