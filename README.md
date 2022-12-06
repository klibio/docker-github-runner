# docker-github-runner

project for docker-github-runner and docker-compose configuration
the github-runner contains docker so that spawning of other containers is feasible 
(if launched with corresponding privileges)

1. build the contained container image - following `docker-github-runner/README.md`
2. configure the .env file with your orga/project and self-hosted runner token
3. launch `docker-compose up -d`