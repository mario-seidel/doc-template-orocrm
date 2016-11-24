#!/bin/bash

#load settings
source "$DOC_SETTINGS"

GIT_REPO="$1"
DOC_DOCKERFILE_OROBASE="./dockerfiles/Dockerfile-orobase"

docker inspect "$DOC_USERNAME"/orobase &> /dev/null

if [ $? -ne 0 ]; then
	echo "-> start building base system for oro"
	docker build \
	    --build-arg user_id=$(id -u) \
	    --build-arg group_id=$(id -g) \
	    -f "$DOC_DOCKERFILE_OROBASE" \
	    -t "$DOC_USERNAME/orobase:latest" .
fi

if [ -z ${GIT_REPO} ]; then
	if [ -f config/composer.json ]; then
	    echo "-> copy composer.json from config/composer.json"
	    cp config/composer.json sources/composer.json
    fi
else
	echo "-> init project from $GIT_REPO"
	rm -rf ./sources
	git clone ${GIT_REPO} sources
fi