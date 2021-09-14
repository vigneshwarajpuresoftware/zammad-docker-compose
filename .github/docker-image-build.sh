#!/usr/bin/env bash
#
# build zammads docker & docker-compose images

set -o errexit
set -o pipefail

DOCKER_IMAGES="zammad zammad-elasticsearch zammad-postgresql"

# shellcheck disable=SC2153
for DOCKER_IMAGE in ${DOCKER_IMAGES}; do
  echo "Build Zammad Docker image ${DOCKER_IMAGE} for local or ci tests"
  docker --version
  docker buildx create --name samplekit
  docker buildx use samplekit
  docker buildx inspect --bootstrap
  docker buildx build --pull --push --no-cache --build-arg BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" -t ajv21/zammad-docker-compose:latest --platform linux/arm64,linux/amd64 -f "containers/${DOCKER_IMAGE}/Dockerfile" .
  docker buildx rm samplekit
done
