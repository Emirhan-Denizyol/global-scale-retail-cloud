#!/usr/bin/env bash
set -euo pipefail

LOCATION="${AZURE_LOCATION:-westeurope}"
RESOURCE_GROUP="${AZURE_RESOURCE_GROUP:-rg-global-retail-prod}"
TEMPLATE_SPEC_NAME="${TEMPLATE_SPEC_NAME:-global-retail-template-spec}"
VERSION="${TEMPLATE_SPEC_VERSION:-1.0}"

az ts create \
  --name "${TEMPLATE_SPEC_NAME}" \
  --version "${VERSION}" \
  --resource-group "${RESOURCE_GROUP}" \
  --location "${LOCATION}" \
  --template-file azure-templates/main.bicep
