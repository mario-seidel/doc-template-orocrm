#!/bin/bash

#load settings
source "$DOC_SETTINGS"

DOC_DOCKERFILE_OROBASE="./dockerfiles/Dockerfile-orobase"

docker inspect "$DOC_USERNAME"/orobase &> /dev/null

if [ $? -ne 0 ]; then
	echo "-> start building base system for oro"
	docker build \
	    --build-arg user_id=$(id -u) \
	    --build-arg group_id=$(id -g) \
	    -f "$DOC_DOCKERFILE_OROBASE" \
	    -t "$DOC_REPO/$DOC_USERNAME/orobase:latest" .
fi