#!/bin/bash
set -x
scriptDir="$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )"
[[ -z "${TOKEN}" ]] && echo "please provide your Github PAT token via env variable TOKEN" && exit 1

GITHOST=${GITHOST:-api.github.com}
ORG=klibio

# activate bash checks for unset vars, pipe fails
set -eauo pipefail

downloadUrl=$(curl -s \
    -H "Accept: application/vnd.github+json"\
    -H "Authorization: Bearer ${TOKEN}" \
    https://${GITHOST}/orgs/${ORG}/actions/runners/downloads \
    | jq -r '.[] | select(.os|test("linux")) | select(.architecture|test("x64")) | .download_url')

runnerVersion=$(echo $downloadUrl | sed 's,.*download/v\(.*\)/.*,\1,g')

cd $scriptDir
docker build \
    --progress=plain \
    --no-cache \
    --build-arg RUNNER_VERSION=${runnerVersion} \
    -t github-action-runner-image \
    .
