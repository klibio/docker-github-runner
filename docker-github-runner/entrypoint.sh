#!/bin/bash

ORGANIZATION=$ORGANIZATION
RUNNER_TOKEN=$RUNNER_TOKEN

cd /home/docker/actions-runner
echo "config.sh --url https://github.com/${ORGANIZATION} --token ${RUNNER_TOKEN}"
./config.sh --url https://github.com/${ORGANIZATION} --token ${RUNNER_TOKEN}
./run.sh