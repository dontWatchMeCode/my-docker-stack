#!/usr/bin/bash

cd ./automation &&
    docker-compose pull &&
    docker-compose up -d

cd ../static &&
    mkdir -p public &&
    docker-compose pull &&
    docker-compose up -d &&
    cd ./public &&
    ls | xargs -I{} git -C {} pull
