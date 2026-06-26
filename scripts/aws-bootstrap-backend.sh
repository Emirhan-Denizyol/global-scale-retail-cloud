#!/usr/bin/env bash
set -euo pipefail

REGION="${AWS_REGION:-us-east-1}"
PROJECT_NAME="global-retail"
ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
BUCKET_NAME="${PROJECT_NAME}-tfstate-${ACCOUNT_ID}-${REGION}"
STATE_KEY="global-scale-retail-cloud/aws/terraform.tfstate"

echo "Region: ${REGION}"
echo "Account ID: ${ACCOUNT_ID}"
echo "Backend bucket: ${BUCKET_NAME}"

if aws s3api head-bucket --bucket "${BUCKET_NAME}" 2>/dev/null; then
  echo "Backend bucket already exists."
else
  echo "Creating backend bucket..."

  if [ "${REGION}" = "us-east-1" ]; then
    aws s3api create-bucket \
      --bucket "${BUCKET_NAME}" \
      --region "${REGION}"
  else
    aws s3api create-bucket \
      --bucket "${BUCKET_NAME}" \
      --region "${REGION}" \
      --create-bucket-configuration LocationConstraint="${REGION}"
  fi
fi

echo "Blocking public access..."
aws s3api put-public-access-block \
  --bucket "${BUCKET_NAME}" \
  --public-access-block-configuration \
  BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true

echo "Enabling server-side encryption..."
aws s3api put-bucket-encryption \
  --bucket "${BUCKET_NAME}" \
  --server-side-encryption-configuration \
  '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

echo "Enabling versioning..."
aws s3api put-bucket-versioning \
  --bucket "${BUCKET_NAME}" \
  --versioning-configuration Status=Enabled

cat > terraform/aws/backend.tf <<BACKEND
terraform {
  backend "s3" {
    bucket       = "${BUCKET_NAME}"
    key          = "${STATE_KEY}"
    region       = "${REGION}"
    encrypt      = true
    use_lockfile = true
  }
}
BACKEND

echo "Generated terraform/aws/backend.tf"
echo "Backend bootstrap completed."
