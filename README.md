# Global-Scale Retail Cloud

This project is a cloud graduation assignment designed around a multi-cloud retail architecture.

## Cloud Scope

- AWS: Web application frontend and high-traffic microservice simulation.
- Azure: Central management, networking, governance, policy, and SQL layer.
- GCP: Optional architecture only. Not deployed because student credits were exhausted.

## Cost-Safety Decision

To avoid unexpected billing, this project uses the smallest possible resources and destroys all deployed resources immediately after screenshots are collected.

Important cost decisions:

- No AWS NAT Gateway.
- No long-running EC2 instances.
- No long-running Azure SQL Database.
- GCP resources are not deployed.
- Budget alerts are configured before deployment.

## Repository Structure

```text
terraform/
  aws/
  gcp-optional-not-deployed/

azure-templates/
  policy/
  scripts/

scripts/
screenshots/
diagrams/
