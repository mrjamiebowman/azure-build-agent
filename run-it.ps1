Clear-Host

# vars
$VERSION = "plain"
$AZP_AGENT_NAME = "dockeragent-03"
$AZP_AGENT_POOL = "Unraid"

# azure devops url and auth token
$AZP_URL = [System.Environment]::GetEnvironmentVariable("AZP_DEVOPS_URL","User") # https://dev.azure.com/your-org-name
$AZP_DEVOPS_AGENT_TOKEN = [System.Environment]::GetEnvironmentVariable("AZP_DEVOPS_AGENT_TOKEN","User") # build agent token

# output
Write-Host "Starting ADO Agent: $AZP_URL"
Write-Host "Azure DevOps Token: $($AZP_DEVOPS_AGENT_TOKEN.SubString(0, 8))..."

# docker run -it
docker run --rm -it `
            --name azure-build-agent `
            -e AZP_URL=$AZP_URL `
            -e AZP_TOKEN=$AZP_DEVOPS_AGENT_TOKEN `
            -e AZP_AGENT_NAME=$AZP_AGENT_NAME `
            -e AZP_POOL=$AZP_AGENT_POOL `
            --entrypoint /bin/bash `
            mrjamiebowman/azure-build-agent:$VERSION
