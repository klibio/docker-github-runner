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

organization=$organization
runnerToken=$runnerToken
repo=$repo
[[ -z "${repo}" ]] && repoRunner=true

cd /home/docker/actions-runner
if [ repoRunner ]; then
    echo "config.sh --url https://github.com/${organization}/${repo} --token ${runnerToken}"
    ./config.sh --url https://github.com/${organization}/${repo} --token ${runnerToken}
else 
    echo "config.sh --url https://github.com/${organization} --token ${runnerToken}"
    ./config.sh --url https://github.com/${organization} --token ${runnerToken}
fi
./run.sh