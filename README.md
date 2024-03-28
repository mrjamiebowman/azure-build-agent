# Azure Build Agent
Dockerized Azure Build Agent with .NET 8/9 Preview, Terraform, Packer, and Ansible.

[![Docker Image CI](https://github.com/mrjamiebowman/azure-build-agent/actions/workflows/docker-image.yml/badge.svg?branch=main)](https://github.com/mrjamiebowman/azure-build-agent/actions/workflows/docker-image.yml)

#### Additional Tools 
* az cli
* terraform
* helm
* packer
* jinja cli
* whois / mkpasswd

### Microsoft Docs
[https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops)

## Unraid Support
I'm going to write an article and publish this to the Unraid repository. If you're running this at home, installing this on an Unraid server will be extreamly easy.

## Running Locally (Docker)
There are environment variables in the `start.sh` script that need to be passed in.

`AZP_URL`  
`AZP_TOKEN`  
`AZP_AGENT_NAME`  
`AZP_POOL`  

## Running Locally (Windows)
You can run this locally on Windows by setting these environment variables and running the `run.ps1` script.

#### Environment Variables
`AZP_DEVOPS_AGENT_TOKEN` - Build agent token   
`AZP_DEVOPS_URL` - Azure DevOps URL   

Manually set the `AZP_AGENT_NAME` and `AZP_AGENT_POOL` with the appropriate agent name and agent pool. For mine, I used `dockeragent-01` and `Unraid`.  

## VMWare Builds (Packer)
[https://www.vmware.com/go/getworkstation-linux](https://www.vmware.com/go/getworkstation-linux)   
