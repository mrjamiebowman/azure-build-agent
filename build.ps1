Clear-Host

$VERSION = "latest"

# fix formatting issues
dos2unix start.sh
dos2unix terraform.sh

# --no-cache
docker build -f Dockerfile -t mrjamiebowman/azure-build-agent:$VERSION .
