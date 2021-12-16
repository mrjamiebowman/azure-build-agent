$AZ_BUILD_AGENT = [System.Environment]::GetEnvironmentVariable("AZ_BUILD_AGENT","User") # build agent token
$AZ_DEVOPS_URL = [System.Environment]::GetEnvironmentVariable("AZ_DEVOPS_URL","User") # https://dev.azure.com/your-org-name
Write-Host "Starting ADO Agent with PAT: $AZ_BUILD_AGENT"

docker rm -f azure-build-agent
docker run --name azure-build-agent -e AZP_URL=$AZ_DEVOPS_URL -e AZP_TOKEN=$AZ_BUILD_AGENT -e AZP_AGENT_NAME=dockeragent-01 -e AZP_POOL="On Prem Agents" mrjamiebowman/azure-build-agent:latest
