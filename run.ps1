Clear-Host

# azure devops url and auth token
$AZP_URL = [System.Environment]::GetEnvironmentVariable("AZP_DEVOPS_URL","User") # https://dev.azure.com/your-org-name
$AZP_DEVOPS_AGENT_TOKEN = [System.Environment]::GetEnvironmentVariable("AZP_DEVOPS_AGENT_TOKEN","User") # build agent token

# agent name & pool
$AZP_AGENT_NAME = "dockeragent-02"
$AZP_AGENT_POOL = "Unraid"

# output
Write-Host "Starting ADO Agent: $AZP_URL"
Write-Host "Azure DevOps Token: $AZP_DEVOPS_AGENT_TOKEN"

# remove previous agent if needed.
docker rm -f azure-build-agent

# docker run
docker run -v ${PWD}/logs/:/azp/_diag --name azure-build-agent -e AZP_URL=$AZP_URL -e AZP_TOKEN=$AZP_DEVOPS_AGENT_TOKEN -e AZP_AGENT_NAME=$AZP_AGENT_NAME -e AZP_POOL=$AZP_AGENT_POOL mrjamiebowman/azure-build-agent:latest
