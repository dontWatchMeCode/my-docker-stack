#!/usr/bin/bash

cd ./dRun &&
    ./kuma.sh &&
    ./portainer.sh &&
    echo "(!!) dRun updated"

cd ../dCompose &&
    ./upAll.sh &&
    echo "(!!) dCompose updated"
