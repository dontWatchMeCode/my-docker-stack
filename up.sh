#!/usr/bin/bash

git fetch

check=$(git status | grep -c "Your branch is up to date with")
gitexit=0

function help() {
    echo "-ci"
    echo "  git pull '/'"
    echo "  git pull 'static/public'"
    echo "  build containers"
    echo ""
    echo "-up"
    echo "  git pull '/'"
    echo "  git pull 'static/public'"
    echo "  pull new images"
    echo "  build containers"

    exit
}

function pullRepo() {
    if [ "$check" = 1 ]; then
        echo "no git changes"
        [ "$gitexit" = 1 ] && exit
    else
        echo "stash and pull"
        git stash &&
            git pull
    fi
}

function pullStatic() {
    mkdir -p ./dCompose/automation/static/public &&
        cd ./dCompose/automation/static/public &&
        ls | xargs -I{} git -C {} pull &&
        cd ../../../../
}

function ci() {
    gitexit=1

    pullRepo
    pullStatic

    cd ./dCompose &&
        ./upAll.sh -nopull &&
        [[ -f ./postUp.sh ]] && ./postUp.sh &&
        echo "(!!) dCompose updated"

    exit
}

function up() {
    gitexit=0

    pullRepo
    pullStatic

    cd ./dRun &&
        ./kuma.sh &&
        ./portainer.sh &&
        echo "(!!) dRun updated"

    cd ../dCompose &&
        ./upAll.sh &&
        [[ -f ./postUp.sh ]] && ./postUp.sh &&
        echo "(!!) dCompose updated"

    exit
}

for arg in "$@"; do
    if [ "$arg" = "-ci" ]; then
        echo "ci active" && ci
    elif [ "$arg" = "-up" ]; then
        echo "up active" && up
    fi
done

help
