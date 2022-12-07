# docker-github-runner

project for docker-github-runner and docker-compose configuration
the github-runner contains docker so that spawning of other containers is feasible 
(if launched with corresponding privileges)

1. build the contained container image - following `docker-github-runner/README.md`
2. configure the .env file with your orga/project and self-hosted runner token
3. launch `docker compose up -d`




NAME: ORG/REPO
ORG: Github Organisation/Repository Owner
REPO: Github Repository
TOKEN: Github PAT to use Github API, to list and create a new runner (inside a container)




for now missing:
- PAT used to create Runner Token for registration
- make Host Docker accessible to the github-runner container
- (use this repo with pipeline that uses this github-runner)