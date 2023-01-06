#!/bin/bash
scriptDir="$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )"
[[ -z "${githubToken}" ]] && echo "please provide your Github PAT token via env variable githubToken" && exit 1
[[ -z "${repo}" ]] && echo "please provide a repository via env variable repo" && exit 1

# function to parse --no-build flag
_setArgs(){
  while [ "${1:-}" != "" ]; do
    case "$1" in
      "--no-build")
        noBuild=true;;
      "--test-mode")
        testMode=true;;
      "-d")
        detached=true;;
      "-R")
        repoRunner=true;;
    esac
    shift 1
  done
}

gitHost=${gitHost:-api.github.com}
organization=klibio
tag=latest

# check arguments for no build option
noBuild=false
repoRunner=false
detached=false
testMode=false

_setArgs "$@"

# activate bash checks for unset vars, pipe fails
set -eauo pipefail

#fetching token for the runner downloads
if [ repoRunner ]; then
  runnerToken=$(curl -s \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${githubToken}"\
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://${gitHost}/repos/${organization}/${repo}/actions/runners/registration-token | jq -r '.token')
else 
  runnerToken=$(curl -s \
    -X POST \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer ${githubToken}"\
    -H "X-GitHub-Api-Version: 2022-11-28" \
    https://${gitHost}/orgs/${organization}/actions/runners/registration-token | jq -r '.token')
fi

downloadUrl=$(curl -s \
    -H "Accept: application/vnd.github+json"\
    -H "Authorization: Bearer ${githubToken}" \
    https://${gitHost}/orgs/${organization}/actions/runners/downloads \
    | jq -r '.[] | select(.os|test("linux")) | select(.architecture|test("x64")) | .download_url')

runnerVersion=$(echo $downloadUrl | sed 's,.*download/v\(.*\)/.*,\1,g')

# removing past configuration
if test -f ".env"; then rm ./.env; fi;

#writing new configuration (as the runnerToken, might change!)
cat << EOF >> ./.env
runnerVersion=${runnerVersion}
name=${organization}_${repo}
organization=${organization}
runnerUrl=${downloadUrl}
tag=${tag}
repo=${repo}
PUID=$(id -u)
GUID=$(id -g)
repoRunner=${repoRunner}
githubToken=${githubToken}
EOF
#TODO: grep docker group id
cd $scriptDir

# setting plain progress reporting for easier readbility in logs
BUILDKIT_PROGRESS=plain

# execute compose either with or without build, depending on flat.
# default: build again
if [ noBuild ]; then
    if [ detached ]; then
      docker compose up -d
    else
      docker compose up
    fi
else
    if [ detached ]; then
      docker compose up -d --build
    else
      docker compose up --build
    fi
fi
