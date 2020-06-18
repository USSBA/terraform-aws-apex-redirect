#!/bin/bash
set -eo pipefail
TAG=${1:-latest}
IMAGE=ussba/apex-redirect
docker image build -t ${IMAGE}:${TAG} .
