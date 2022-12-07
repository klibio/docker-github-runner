# base
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# set the github runner version
ARG runnerVersion
ARG runnerUrl
# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker

# update the base packages and add a non-sudo user
RUN apt-get install -y --no-install-recommends -o Acquire::Check-Valid-Until=false \
        ca-certificates \
        curl \
        jq \
        build-essential \
        libssl-dev libffi-dev \
        libdigest-sha-perl

# cd into the user directory, download and unzip the github actions runner

RUN cd /home/docker \
    && echo "# Create a folder" \
    && mkdir actions-runner && cd actions-runner \
    && echo "# Download the latest runner package" \
    && curl -s -O -L https://github.com/actions/runner/releases/download/v${runnerVersion}/actions-runner-linux-x64-${runnerVersion}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${runnerVersion}.tar.gz

RUN echo "# install some additional dependencies" \
    && chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY entrypoint.sh entrypoint.sh

# make the script executable
RUN chmod +x entrypoint.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./entrypoint.sh"]
