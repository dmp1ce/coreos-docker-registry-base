#!/bin/bash
# Run the UpgradeYa nginx webserver

# Get the last Container Name for the registry
CONTAINER_NAME=$(etcdctl get %project_name%/name)

echo "$(date): Starting nginx with volumes from $CONTAINER_NAME" >>  %shared_project_path%/nginx.log

# Create a new name for the new container
RANDOM_CHUNK=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c3;echo;)
NEW_NAME="%project_name%_$RANDOM_CHUNK"

# Remember name for other connecting to volume
etcdctl set %project_name%/name $NEW_NAME

# Determine the registry ip and change the config with the current IP
REGISTRY_CONTAINER_IP=$(etcdctl get %registry_project_name%/name | xargs docker inspect -format={{.NetworkSettings.IPAddress}})

# Set the current registry ip for the container
curl -L http://127.0.0.1:4001/v1/keys/registry/ip -d value="$REGISTRY_CONTAINER_IP"

# Start registry for systemd
/usr/bin/docker run -p 80:80 -p 443:443 --volumes-from=$CONTAINER_NAME -name $NEW_NAME upgradeya/%project_name%
