#!/usr/bin/bash

git fetch

mkdir -p ./dCompose/automation/static/public &&
    cd ./dCompose/automation/static/public &&
    ls | xargs -I{} git -C {} pull &&
    cd ../../../../

check=$(git status | grep -c "Your branch is up to date with")

if [ "$1" = "-f" ]; then
    echo "force update" && check=999
fi

if [ "$check" = 1 ]; then
    echo "nothing to update" && exit
fi

git stash &&
    git pull

cd ./dRun &&
    ./kuma.sh &&
    ./portainer.sh &&
    echo "(!!) dRun updated"

cd ../dCompose &&
    ./upAll.sh &&
    [[ -f ./postUp.sh ]] && ./postUp.sh &&
    echo "(!!) dCompose updated"
