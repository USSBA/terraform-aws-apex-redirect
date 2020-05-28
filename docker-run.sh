#!/bin/bash
set -eo pipefail

IMAGE=ussba/apex-redirect
docker container run --rm --interactive --tty \
 -e REDIRECT_FQDN="${1}" \
 --publish "80:80" \
 --volume "${HOME}/.aws/:/root/.aws/" \
 $IMAGE

