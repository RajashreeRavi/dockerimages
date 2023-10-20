#!/bin/bash
DOCKER_IMAGE_TAG=$1
PUSH_COMMAND=$2
if docker manifest inspect ${DOCKER_IMAGE_TAG} > /dev/null; then
    echo ${DOCKER_IMAGE_TAG} "already exists"
else
    docker push ${DOCKER_IMAGE_TAG}
fi
