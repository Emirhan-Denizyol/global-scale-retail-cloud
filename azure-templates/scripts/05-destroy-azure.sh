#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="${AZURE_RESOURCE_GROUP:-rg-global-retail-prod}"

az group delete \
  --name "${RESOURCE_GROUP}" \
  --yes \
  --no-wait

echo "Delete requested for resource group: ${RESOURCE_GROUP}"
