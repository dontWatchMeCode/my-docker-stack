#!/usr/bin/bash

docker stop uptime-kuma
docker rm uptime-kuma

docker pull louislam/uptime-kuma:latest

docker run -d \
    --name uptime-kuma \
    --restart=always \
    -p 127.0.0.1:3001:3001 \
    -v uptime-kuma:/app/data \
    louislam/uptime-kuma:latest
