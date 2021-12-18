# This script overrides the entry point. This is useful for verifying versions, packages, and installations via command line.

# remove previous agent if needed.
docker rm -f azure-build-agent

# docker run -it
docker run --rm -it -e AZP_URL=$AZP_URL -e AZP_TOKEN=$AZP_DEVOPS_AGENT_TOKEN -e AZP_AGENT_NAME=$AZP_AGENT_NAME -e AZP_POOL=$AZP_AGENT_POOL  --entrypoint /bin/bash mrjamiebowman/azure-build-agent:latest
