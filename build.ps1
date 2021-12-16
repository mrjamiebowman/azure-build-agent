clear
docker rmi -f mrjamiebowman/azure-build-agent:latest
docker build --no-cache -t mrjamiebowman/azure-build-agent:latest .