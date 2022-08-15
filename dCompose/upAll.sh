#!/usr/bin/bash

cd ./automation &&
    [ "$1" != "-nopull" ] && docker-compose pull
    docker-compose up -d

cd ../static &&
    mkdir -p public &&
    [ "$1" != "-nopull" ] && docker-compose pull
    docker-compose up -d &&
    cd ./public &&
    ls | xargs -I{} git -C {} pull
