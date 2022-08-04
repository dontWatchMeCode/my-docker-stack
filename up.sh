#!/usr/bin/bash

check=$(git status | grep -c "Your branch is up to date with")

#check=$(git fetch && git stash && git pull | grep -c "Already up to date.")

if [ "$check" = 1 ]; then
    echo "nothing to update" && exit
fi

git fetch &&
    git stash &&
    git pull

cd ./dRun &&
    ./kuma.sh &&
    ./portainer.sh &&
    echo "(!!) dRun updated"

cd ../dCompose &&
    ./upAll.sh &&
    echo "(!!) dCompose updated"
