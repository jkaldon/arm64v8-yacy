#!/bin/sh
set -ex
YACY_TAG=Release_1.92
DOCKER_TAG=${YACY_TAG}-3

docker build --progress plain --build-arg "YACY_TAG=${YACY_TAG}" -t "jkaldon/arm64v8-yacy:${DOCKER_TAG}" .
docker push "jkaldon/arm64v8-yacy:${DOCKER_TAG}"
