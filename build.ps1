Clear-Host

# fix formatting issues
dos2unix terraform.sh

# --no-cache
docker build --progress=plain -t mrjamiebowman/azure-build-agent:latest .
