FROM ubuntu:20.04

ARG TARGETARCH=amd64
ARG AGENT_VERSION=2.185.1

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    git \
    libcurl4 \
    netcat \
    libssl1.0 \
    apt-transport-https \
    software-properties-common \
    wget \
    unzip \
    jq \
    gnupg \
    lsb-release \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# install docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update
RUN apt-get install docker-ce docker-ce-cli containerd.io

# azure cli
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | \
    gpg --dearmor | \
    tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null

RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/azure-cli.list

# RUN apt-get install azure-cli -y

# install terraform
COPY terraform.sh .
RUN ./terraform.sh

# install .net core
RUN wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

RUN apt-get update; \
  apt-get install -y apt-transport-https && \
  apt-get update && \
  apt-get install -y dotnet-sdk-6.0

# # agent
# WORKDIR /azp

# RUN if [ "$TARGETARCH" = "amd64" ]; then \
#       AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz; \
#     else \
#       AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${TARGETARCH}-${AGENT_VERSION}.tar.gz; \
#     fi; \
#     curl -LsS "$AZP_AGENTPACKAGE_URL" | tar -xz

# COPY ./start.sh .
# RUN chmod +x start.sh

# ENTRYPOINT [ "./start.sh" ]