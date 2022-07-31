#!/usr/bin/bash

docker stop portainer
docker rm portainer

docker pull portainer/portainer-ce:latest

docker run -d \
    --name portainer \
    --restart=always \
    -p 127.0.0.1:3002:9443 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:latest
