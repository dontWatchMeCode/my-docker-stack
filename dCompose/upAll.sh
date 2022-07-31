#!/usr/bin/bash

cd ./automation &&
    docker-compose down &&
    docker-compose pull &&
    docker-compose up -d

cd ../static &&
    mkdir -p public &&
    docker-compose down &&
    docker-compose pull &&
    docker-compose up -d &&
    cd ./public &&
    ls | xargs -I{} git -C {} pull
# this version pulles repos in parallel
# ls | xargs -P10 -I{} git -C {} pull
