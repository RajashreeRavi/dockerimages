# Copyright 2022 Bowery Farming, all rights reserved.
IMAGE_VERSION=1.0
IMAGE_TAG=rajravi95/pytorch-cuda-opencv:${IMAGE_VERSION}
SOURCE_IMAGE=ubuntu:20.04

pullOrBuildBaseImage:
	make $(shell ./pullorbuild.sh ${IMAGE_TAG} pullBaseImage buildBaseImage)

buildBaseImage:
	DOCKER_BUILDKIT=1 docker build --build-arg SOURCE_IMAGE=${SOURCE_IMAGE} --tag ${IMAGE_TAG} .

pullBaseImage:
	docker pull ${IMAGE_TAG}

checkTagAndPushImage:
	./checktagandpush.sh ${IMAGE_TAG}

shell: buildBaseImage
	docker run \
			--interactive \
			--tty \
			--network="host" \
			--rm \
			${IMAGE_TAG} \
			bash
