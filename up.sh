#!/usr/bin/bash

git fetch

check=$(git status | grep -c "Your branch is up to date with")

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
    pullRepo
    pullStatic

    cd ./dCompose &&
        ./upAll.sh -nopull &&
        [[ -f ./postUp.sh ]] && ./postUp.sh &&
        echo "(!!) dCompose updated"

    exit
}

function up() {
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

if [ "$1" = "" ] || [ "$arg" = "-h" ]; then
    help
fi

for arg in "$@"; do
    if [ "$arg" = "-ci" ]; then
        echo "ci active" && ci
    fi
    if [ "$arg" = "-up" ]; then
        echo "up active" && up
    fi
    if [ "$arg" = " " ] || [ "$arg" = "-h" ]; then
        help
    fi
done