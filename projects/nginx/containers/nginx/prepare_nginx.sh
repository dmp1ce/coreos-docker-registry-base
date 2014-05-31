#!/bin/bash

# Get the registry ip
REGISTRY_IP=$(curl -Ls http://172.17.42.1:4001/v1/keys/registry/ip | jq -r '.value')

# Replace placeholder variables in nginx.conf
sed -e "s&%registry-ip%&$REGISTRY_IP&g" /root/deploy/etc/nginx/nginx.conf > /etc/nginx/nginx.conf
