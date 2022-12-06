# Container containing github-action-runner

Navigate to your github project and the settings page.
Nav bar -> 'Code and automation' -> 'Actions' -> Runners -> Button 'New self-hosted runner'
Switch 'Runner image' to **Linux** and select 'Architecture' **x64**

extract the RUNNER_VERSION from the download section e.g. `2.299.1`
and build the container

```bash
./docker-build.sh
```

extract the ORGANIZATION and ACCESS_TOKEN from the 'Configure' section

```bash
# running container with creds from your github repo
ORGANIZATION=klibio/docker-eclipse
ACCESS_TOKEN=<YOUR-TOKEN-HERE>
docker run \
  --env ORGANIZATION=${ORGANIZATION} \
  --env ACCESS_TOKEN=${ACCESS_TOKEN} \
  --name github-action-runner \
  --rm \
  github-action-runner-image
```
