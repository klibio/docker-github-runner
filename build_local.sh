#!/bin/bash
scriptDir="$( cd $( dirname ${BASH_SOURCE[0]} ) >/dev/null 2>&1 && pwd )"
[[ -z "${githubToken}" ]] && echo "please provide your Github PAT token via env variable githubToken" && exit 1
[[ -z "${repo}" ]] && echo "please provide a repository via env variable repo" && exit 1

# function to parse --no-build flag
_setArgs(){
  while [ "${1:-}" != "" ]; do
    case "$1" in
      "--no-build")
        noBuild=true
    case "$1" in
      "--test-mode")
        testMode=true
    case "$1" in
      "-d")
        detahed=true
        ;;
    esac
    shift
  done
}

gitHost=${gitHost:-api.github.com}
org=klibio
tag=latest

# check arguments for no build option
noBuild=false
_setArgs "$@"

# activate bash checks for unset vars, pipe fails
set -eauo pipefail

downloadUrl=$(curl -s \
    -H "Accept: application/vnd.github+json"\
    -H "Authorization: Bearer ${githubToken}" \
    https://${gitHost}/orgs/${org}/actions/runners/downloads \
    | jq -r '.[] | select(.os|test("linux")) | select(.architecture|test("x64")) | .download_url')

runnerVersion=$(echo $downloadUrl | sed 's,.*download/v\(.*\)/.*,\1,g')

runnerToken=$(curl -s \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer ${githubToken}"\
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://${gitHost}/orgs/${org}/actions/runners/registration-token | jq -r '.token')

# removing past configuration
if test -f ".env"; then rm ./.env; fi;

#writing new configuration (as the runnerToken, might change!)
cat << EOF >> ./.env
runnerVersion=${runnerVersion}
name=${org}_${repo}
organization=${org}
runnerToken=${runnerToken}
runnerUrl=${downloadUrl}
tag=${tag}
EOF

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
