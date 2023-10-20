#!/bin/bash
DOCKER_IMAGE_TAG=$1
PULL_COMMAND=$2
BUILD_COMMAND=$3
if docker manifest inspect ${DOCKER_IMAGE_TAG} > /dev/null; then
    echo $PULL_COMMAND
else
    echo $BUILD_COMMAND
fi
