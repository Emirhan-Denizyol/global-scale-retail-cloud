#!/usr/bin/env bash
set -euo pipefail

LOCATION="${AZURE_LOCATION:-westeurope}"
RESOURCE_GROUP="${AZURE_RESOURCE_GROUP:-rg-global-retail-prod}"

az group create \
  --name "${RESOURCE_GROUP}" \
  --location "${LOCATION}" \
  --tags Environment=Prod Owner=Master-Grad CostCenter=101 Project=global-retail ManagedBy=AzureCLI
