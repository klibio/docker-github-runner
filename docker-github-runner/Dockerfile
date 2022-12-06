# base
FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# set the github runner version
ARG RUNNER_VERSION

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
    && curl -s -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN echo "# install some additional dependencies" \
    && chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
