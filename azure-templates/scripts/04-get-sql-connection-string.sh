#!/usr/bin/env bash
set -euo pipefail

RESOURCE_GROUP="${AZURE_RESOURCE_GROUP:-rg-global-retail-prod}"

SQL_SERVER_NAME="$(az sql server list \
  --resource-group "${RESOURCE_GROUP}" \
  --query "[0].name" \
  --output tsv)"

SQL_DB_NAME="$(az sql db list \
  --resource-group "${RESOURCE_GROUP}" \
  --server "${SQL_SERVER_NAME}" \
  --query "[0].name" \
  --output tsv)"

az sql db show-connection-string \
  --server "${SQL_SERVER_NAME}" \
  --name "${SQL_DB_NAME}" \
  --client ado.net
