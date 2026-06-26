#!/usr/bin/env bash
set -euo pipefail

LOCATION="${AZURE_LOCATION:-westeurope}"

az deployment sub create \
  --name global-retail-tag-policy-deployment \
  --location "${LOCATION}" \
  --template-file azure-templates/policy/require-tags.bicep
