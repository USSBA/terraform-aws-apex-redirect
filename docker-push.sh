#!/bin/bash
set -eo pipefail

TAG="${1:-latest}"
IMAGE=ussba/apex-redirect

if [[ "${TAG}" != "latest" ]];
then
  docker image tag ${IMAGE}:latest ${IMAGE}:${TAG}
  docker push ${IMAGE}:${TAG}
else
  docker push ${IMAGE}
fi
