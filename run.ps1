$AZ_BUILD_AGENT = [System.Environment]::GetEnvironmentVariable("AZ_BUILD_AGENT","User") # build agent token
$AZ_DEVOPS_URL = [System.Environment]::GetEnvironmentVariable("AZ_DEVOPS_URL","User") # https://dev.azure.com/your-org-name
$AZ_DEVOPS_AGENT_POOL = "Unraid"

Write-Host "Starting ADO Agent: $AZ_DEVOPS_URL"
Write-Host "Azure DevOps Token: $AZ_BUILD_AGENT"

docker rm -f azure-build-agent
docker run --name azure-build-agent -e AZP_URL=$AZ_DEVOPS_URL -e AZP_TOKEN=$AZ_BUILD_AGENT -e AZP_AGENT_NAME=dockeragent-01 -e AZP_POOL=$AZ_DEVOPS_AGENT_POOL mrjamiebowman/azure-build-agent:latest
