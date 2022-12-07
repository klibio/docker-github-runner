#!/bin/bash

organization=$organization
runnerToken=$runnerToken

cd /home/docker/actions-runner
echo "config.sh --url https://github.com/${organization} --token ${runnerToken}"
./config.sh --url https://github.com/${organization} --token ${runnerToken}
./run.sh