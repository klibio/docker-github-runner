#!/bin/bash
scriptDir="$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )"
[[ -z "${TOKEN}" ]] && echo "please provide your Github PAT token via env variable TOKEN" && exit 1
[[ -z "${REPO}" ]] && echo "please provide a repository via env variable REPO" && exit 1

GITHOST=${GITHOST:-api.github.com}
ORG=klibio
TAG=latest

# activate bash checks for unset vars, pipe fails
set -eauo pipefail

downloadUrl=$(curl -s \
    -H "Accept: application/vnd.github+json"\
    -H "Authorization: Bearer ${TOKEN}" \
    https://${GITHOST}/orgs/${ORG}/actions/runners/downloads \
    | jq -r '.[] | select(.os|test("linux")) | select(.architecture|test("x64")) | .download_url')

runnerVersion=$(echo $downloadUrl | sed 's,.*download/v\(.*\)/.*,\1,g')

RUNNER_TOKEN=$(curl -s \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${TOKEN}"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://${GITHOST}/orgs/${ORG}/actions/runners/registration-token | jq -r '.token')

if test -f "./.env"; then
    echo "Found existing envFile, wont write new one";
else
    if [ -z ${NAME+x} ]; 
        then echo "Envvar NAME unset, using default value 'klibio_docker-eclipse'" && NAME=klibio_docker-eclipse;
    fi
    if [ -z ${ORGA+x} ];
        then echo "Envvar ORGA unset, using default value 'klibio/docker-eclipse'" && ORGA=klibio/docker-eclipse;
    fi 
    touch ./.env
    cat << EOF >> ./.env
    RUNNER_VERSION=${runnerVersion}
    NAME=${ORG}_${REPO}
    ORGANIZATION=${ORG}
    RUNNER_TOKEN=${RUNNER_TOKEN}
    RUNNER_URL=${downloadUrl}
    TAG=${TAG}
EOF
fi

cd $scriptDir

BUILDKIT_PROGRESS=plain
docker compose up --build