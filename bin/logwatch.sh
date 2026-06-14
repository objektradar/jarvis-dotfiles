#!/bin/bash
# Jarvis Logwatch — kompakte Docker-Log-Übersicht
echo "=== Docker Logs (last 1h) ==="
docker ps --format '{{.Names}}' | while read container; do
    lines=$(docker logs --since 1h "$container" 2>/dev/null | grep -ciE 'error|warn|fail|crash|OOM' || true)
    if [ "$lines" -gt 0 ]; then
        echo "🔴 $container: $lines errors/warnings"
        docker logs --since 1h "$container" 2>/dev/null | grep -iE 'error|warn|fail|crash|OOM' | tail -3 | sed 's/^/   /'
    else
        echo "🟢 $container: clean"
    fi
done
echo "=== Disk ==="
df -h / | tail -1
echo "=== Memory ==="
free -h | grep Mem
echo "=== Docker ==="
docker system df --format 'table {{.Type}}\t{{.TotalCount}}\t{{.Size}}' 2>/dev/null || docker system df
