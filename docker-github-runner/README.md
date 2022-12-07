# Container containing github-action-runner

Navigate to your github project and the settings page.
Nav bar -> 'Code and automation' -> 'Actions' -> Runners -> Button 'New self-hosted runner'
Switch 'Runner image' to **Linux** and select 'Architecture' **x64**

extract the runnerVersion from the download section e.g. `2.299.1`
and build the container

```bash
./docker-build.sh
```

extract the organization and runnerToken from the 'Configure' section

```bash
# running container with creds from your github repo
organization=klibio/docker-eclipse
runnerToken=<YOUR-TOKEN-HERE>
docker run \
  --env organization=${organization} \
  --env runnerToken=${runnerToken} \
  --name github-action-runner \
  --rm \
  github-action-runner-image
```
