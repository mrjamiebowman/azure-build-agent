clear
docker rmi -f mrjamiebowman/azure-build-agent:latest
# --no-cache
docker build -t mrjamiebowman/azure-build-agent:latest .