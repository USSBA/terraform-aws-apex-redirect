#!/bin/bash
set -eo pipefail

TAG=${1:-latest}
IMAGE=ussba/apex-redirect
docker container run --rm --interactive --tty \
 -e REDIRECT_FQDN="" \
 -e HSTS_HEADER_VALUE="max-age=60;" \
 -e AWS_S3_BUCKET_NAME="" \
 -e AWS_S3_KEY_FULLCHAIN_PEM="" \
 -e AWS_S3_KEY_PRIVATEKEY_PEM="" \
 -e AWS_PROFILE="" \ # only necessary when testing on localhost
 --publish "80:80" \
 --publish "443:443" \
 --volume "${HOME}/.aws/:/root/.aws/" \ # only necessary when testing on localhost
 ${IMAGE}:${TAG}
