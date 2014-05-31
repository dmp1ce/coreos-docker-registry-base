#!/bin/bash
# Stop the UpgradeYa nginx

# Get the last Container Name for the registry
CONTAINER_NAME=$(etcdctl get %project_name%/name)

echo "$(date): Stopping nginx $CONTAINER_NAME"

# Start registry for systemd
/usr/bin/docker stop $CONTAINER_NAME
