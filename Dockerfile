# https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops

#FROM ubuntu:22.04
FROM mcr.microsoft.com/dotnet/sdk:9.0.100-preview.2-jammy-amd64

ARG TARGETARCH=amd64
ARG GO_VERSION=1.22.1
ARG AGENT_VERSION=3.217.1

# To make it easier for build and release pipelines to run apt-get,
# configure apt to not require confirmation (assume the -y argument by default)
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

RUN apt-get update && apt-get install -y \
    --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    dos2unix \
    jq \
    git \
    gcc \
    libcurl4 \
    libssl1.0 \
    apt-transport-https \
    python3-pip \
    software-properties-common \
    wget \
    unzip \
    jq \
    gnupg \
    lsb-release \
    whois \
    zlib1g \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# # jinjacli
# RUN pip install jinja-cli

# install docker
RUN apt install apt-transport-https ca-certificates curl software-properties-common

# azure cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt update
RUN apt-cache policy docker-ce
RUN apt install docker-ce

# .net 8
RUN wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb

RUN apt-get update; \
  apt-get install -y apt-transport-https && \
  apt-get update && \
  apt-get install -y dotnet-sdk-8.0

# .net preview
RUN curl -L https://aka.ms/install-dotnet-preview -o install-dotnet-preview.sh
RUN bash install-dotnet-preview.sh

# install go
RUN wget -O go${GO_VERSION}.linux-amd64.tar.gz https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin

# terraform
COPY terraform.sh .
RUN ./terraform.sh

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# helm
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
RUN chmod 700 get_helm.sh && ./get_helm.sh

# ansible
RUN add-apt-repository --yes --update ppa:ansible/ansible
RUN apt update && apt install ansible

# packer
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt-get update && apt-get install packer

# agent
WORKDIR /azp

RUN if [ "$TARGETARCH" = "amd64" ]; then \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-x64-${AGENT_VERSION}.tar.gz; \
    else \
      AZP_AGENTPACKAGE_URL=https://vstsagentpackage.azureedge.net/agent/${AGENT_VERSION}/vsts-agent-linux-${TARGETARCH}-${AGENT_VERSION}.tar.gz; \
    fi; \
    curl -LsS "$AZP_AGENTPACKAGE_URL" | tar -xz

# argocd
RUN mkdir -p /install
WORKDIR /install
RUN curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
RUN install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
RUN rm argocd-linux-amd64

# start
WORKDIR /azp
COPY start.sh .
RUN dos2unix start.sh
RUN chmod +x start.sh

# set up user
# TODO

ENTRYPOINT [ "/azp/start.sh" ]