#!/usr/bin/bash

check=$(git pull | grep -c "Already up to date.")

if [ "$check" = 1 ];
then
    echo "nothing to update" && exit
fi

cd ./dRun &&
    ./kuma.sh &&
    ./portainer.sh &&
    echo "(!!) dRun updated"

cd ../dCompose &&
    ./upAll.sh &&
    echo "(!!) dCompose updated"
