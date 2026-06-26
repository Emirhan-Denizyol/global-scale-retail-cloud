#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="${AZURE_RESOURCE_GROUP:-rg-global-retail-prod}"

az group delete \
  --name "${RESOURCE_GROUP}" \
  --yes \
  --no-wait

az policy assignment delete \
  --name assign-global-retail-required-tags || true

az policy definition delete \
  --name require-global-retail-tags || true

echo "Delete requested for resource group and subscription-level tag policy cleanup completed."
