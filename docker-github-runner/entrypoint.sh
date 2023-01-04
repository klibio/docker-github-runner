#!/bin/bash

PUID=${PUID:-911}
PGID=${PGID:-911}

echo '
-------------------------------------
GID/UID
-------------------------------------'
echo "
User uid:    $(id -u docker)
User gid:    $(id -g docker)
-------------------------------------
"
groupmod -o -g "$PGID" docker
usermod -o -u "$PUID" docker

githubToken=$githubToken
gitHost=${gitHost:-api.github.com}
organization=$organization
repo=$repo
repoRunner=$repoRunner


if [ repoRunner ]; then

  echo '
  -------------------------------------
  Runnerconfiguration
  -------------------------------------'
  echo "
  GitHost:         $(gitHost)
  Organisation:    $(organization)
  Repository:      $(repo)
  -------------------------------------
  "
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

#remove githubToken, so it cannot be printed when accessing the container
githubToken="REMOVED"

cd /home/docker/actions-runner
if [ repoRunner ]; then
    echo "config.sh --url https://github.com/${organization}/${repo} --token ${runnerToken}"
    ./config.sh --url https://github.com/${organization}/${repo} --token ${runnerToken}
else 
    echo "config.sh --url https://github.com/${organization} --token ${runnerToken}"
    ./config.sh --url https://github.com/${organization} --token ${runnerToken}
fi
./run.sh