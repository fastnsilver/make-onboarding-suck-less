#!/usr/bin/env bash

if [ -z "$1" ] && [ -z "$2" ] && [-z "$3" ]; then
	echo "Usage: fetch-tanzu-cli.sh {username} {password} {tanzu-cli-version}"
	exit 1
fi

VMWUSER="$1"
VMWPASS="$2"
TANZU_VERSION="$3"

FILE=tanzu-cli-bundle-v${TANZU_VERSION}-linux-amd64.tar
CURRENT_VERSION="latest"
if [ -e "dist/tanzu" ]; then
  cd dist
  TANZU_CLI_VERSION_OUTPUT=$(tanzu version)
  MULTI_LINE_STRING=${TANZU_CLI_VERSION_OUTPUT#"version: v"}
  OUTPUT_ARRAY=(${MULTI_LINE_STRING[@]})
  CURRENT_VERSION=${OUTPUT_ARRAY[0]}
  cd ..
fi

if [ "$TANZU_VERSION" == "$CURRENT_VERSION" ]; then
    echo "$FILE already downloaded."
else
    echo "$FILE does not exist. Will begin fetching from https://console.cloud.vmware.com."
    npm list | grep vmw-cli || npm install vmw-cli --global
    mkdir -p dist
    vmw-cli ls vmware_tanzu_kubernetes_grid
    vmw-cli cp tanzu-cli-bundle-v${TANZU_VERSION}-linux-amd64.tar
    tar xvf tanzu-cli-bundle-v${TANZU_VERSION}-linux-amd64.tar -C dist
    chmod +x dist/cli/core/v${TANZU_VERSION}/tanzu-core-linux_amd64
    cp dist/cli/core/v${TANZU_VERSION}/tanzu-core-linux_amd64 dist/tanzu
    rm -Rf dist/cli
    rm -f tanzu-cli-bundle-v${TANZU_VERSION}-linux-amd64.tar
fi