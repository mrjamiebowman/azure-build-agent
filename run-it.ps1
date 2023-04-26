# azure devops url and auth token
$AZP_URL = [System.Environment]::GetEnvironmentVariable("AZP_DEVOPS_URL","User") # https://dev.azure.com/your-org-name
$AZP_DEVOPS_AGENT_TOKEN = [System.Environment]::GetEnvironmentVariable("AZP_DEVOPS_AGENT_TOKEN","User") # build agent token

# agent name & pool
$AZP_AGENT_NAME = "dockeragent-03"
$AZP_AGENT_POOL = "Unraid"

# output
Write-Host "Starting ADO Agent: $AZP_URL"
Write-Host "Azure DevOps Token: $AZP_DEVOPS_AGENT_TOKEN"

# docker run -it
docker run --rm -it -e AZP_URL=$AZP_URL -e AZP_TOKEN=$AZP_DEVOPS_AGENT_TOKEN -e AZP_AGENT_NAME=$AZP_AGENT_NAME -e AZP_POOL=$AZP_AGENT_POOL  --entrypoint /bin/bash mrjamiebowman/azure-build-agent:latest
