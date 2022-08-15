#!/usr/bin/bash

git fetch

mkdir -p ./dCompose/automation/static/public &&
    cd ./dCompose/automation/static/public &&
    ls | xargs -I{} git -C {} pull &&
    cd ../../../../

check=$(git status | grep -c "Your branch is up to date with")
dpull=0
git=0

for arg in "$@"; do
    if [ "$arg" = "-f" ]; then
        echo "force update" && check=999
    fi
    if [ "$arg" = "-dpull" ]; then
        echo "pull docker images" && dpull=1
    fi
    if [ "$arg" = "-git" ]; then
        echo "pull docker images" && git=1
    fi
done

if [ "$check" = 1 ]; then
    echo "nothing to update" && exit
fi

if [ "$git" = 1 ]; then
    git stash &&
        git pull
fi

if [ "$dpull" = 1 ]; then
    cd ./dRun &&
        ./kuma.sh &&
        ./portainer.sh &&
        echo "(!!) dRun updated"

    cd ../dCompose &&
        ./upAll.sh &&
        [[ -f ./postUp.sh ]] && ./postUp.sh &&
        echo "(!!) dCompose updated"
else
    cd ./dCompose &&
        ./upAll.sh -nopull &&
        [[ -f ./postUp.sh ]] && ./postUp.sh &&
        echo "(!!) dCompose updated"
fi
