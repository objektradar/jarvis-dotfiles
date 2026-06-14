#!/bin/bash
# Jarvis System Update
set -e
echo "=== System Update ==="
apt-get update -qq
apt-get upgrade -y -qq
apt-get autoremove -y -qq
apt-get autoclean -qq
echo "=== Docker ==="
docker system prune -f --volumes 2>/dev/null || true
docker images --format '{{.Repository}}:{{.Tag}}' | grep -v '<none>' | xargs -r docker pull 2>/dev/null || true
echo "=== Done ==="
