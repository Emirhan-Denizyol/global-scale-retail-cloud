#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="${AZURE_RESOURCE_GROUP:-rg-global-retail-prod}"
TEMPLATE_SPEC_NAME="${TEMPLATE_SPEC_NAME:-global-retail-template-spec}"
VERSION="${TEMPLATE_SPEC_VERSION:-1.0}"

if [ -z "${ALLOWED_PUBLIC_IP:-}" ]; then
  echo "ERROR: ALLOWED_PUBLIC_IP environment variable is required."
  exit 1
fi

if [ -z "${SQL_ADMIN_PASSWORD:-}" ]; then
  echo "ERROR: SQL_ADMIN_PASSWORD environment variable is required."
  exit 1
fi

TEMPLATE_SPEC_ID="$(az ts show \
  --name "${TEMPLATE_SPEC_NAME}" \
  --resource-group "${RESOURCE_GROUP}" \
  --version "${VERSION}" \
  --query "id" \
  --output tsv)"

az deployment group create \
  --name global-retail-prod-deployment \
  --resource-group "${RESOURCE_GROUP}" \
  --template-spec "${TEMPLATE_SPEC_ID}" \
  --parameters @azure-templates/parameters.dev.json \
  --parameters allowedPublicIp="${ALLOWED_PUBLIC_IP}" \
  --parameters sqlAdminPassword="${SQL_ADMIN_PASSWORD}"
