#!/bin/bash
set -eo pipefail

IMAGE=ussba/apex-redirect
docker image build -t ${IMAGE}:${TAG} .

