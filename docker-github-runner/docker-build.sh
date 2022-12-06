#!/bin/bash

# activate bash checks for unset vars, pipe fails
set -eauo pipefail
SCRIPT_DIR="$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )"

downloadUrl=$( curl -s \
    -H "Accept: application/vnd.github+json"\
    -H "Authorization: Bearer ${TOKEN}" \
    https://${HOSTNAME}/orgs/${ORG}/actions/runners/downloads \
    | jq -r '.[] | select(.os|test("linux")) | select(.architecture|test("x64")) | .download_url' )

version=$(echo $downloadUrl | sed 's,.*download/v\(.*\)/.*,\1,g')

docker build \
    --progress=plain \
    --no-cache \
    --build-arg RUNNER_VERSION=${RUNNER_VERSION} \
    -t github-action-runner-image \
    .
