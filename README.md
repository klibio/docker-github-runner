# docker-github-runner

project for docker-github-runner and docker-compose configuration
the github-runner contains docker so that spawning of other containers is feasible 
(if launched with corresponding privileges)

Building is included in the docker-compose.

## Usage

Execute 

```shell
sh buildLocal.sh
```

with the environment variables `githubToken` and `repo` set.
If you dont want to rebuild the image (which might be necessary, when changing the envvars in the compose file or the entrypoint script) you can use

```shell
sh buildLocal.sh --no-build
```

### Variables used
Here is a list of the variables we used and what they are referring to. This list aims to help when adapting our solution for your own environment.

- org: Github Organisation/Repository Owner
- repo: Github Repository
- name: \$org_\$repo - composite variable, which names the container (not the image!)
- githubToken: Github PAT to use Github API, to list and create a new runner (inside a container)
- runnerToken: The registration token, which the github runner uses to register with the github instance
- runnerVersion: version of the github runnter that is downloaded, parsed inside the start script
- tag: The tag, with which the container shall be tagged after build

### ToDos or unaccessible features
- make Host Docker accessible to the github-runner container
- (use this repo with pipeline that uses this github-runner)
- runner groups: enterprise only feature