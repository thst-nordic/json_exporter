#!/bin/bash
cd "$(dirname "$0")"

# get go compiler
sudo apt install golang-go -y

# This command replaces k8s.io version with custom fork with fix for parsing bug
go mod edit -replace k8s.io/client-go=./client-go

# build json_exporter binary and put it where dockerfile expects it
make build
ARCH="amd64"
OS="linux"
mkdir -p .build/${OS}-${ARCH}
cp json_exporter .build/${OS}-${ARCH}/

# build & push docker image
docker build . --tag docker-dtr.nordicsemi.no/buran_ci/json-exporter:latest
docker push docker-dtr.nordicsemi.no/buran_ci/json-exporter:latest
