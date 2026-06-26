# Global-Scale Retail Cloud

This repository contains the final cloud infrastructure project for the Global-Scale Retail Cloud scenario. The project demonstrates infrastructure provisioning across AWS and Azure using Infrastructure as Code, Cloud Shell workflows, security rules, tagging, deployment evidence, and cleanup evidence.

## Project Scope

The project includes:

- AWS infrastructure provisioned with Terraform
- Azure infrastructure provisioned with Bicep and Template Spec
- GCP architecture documented as optional and not deployed due to credit limitations
- Cloud Shell command evidence
- Screenshots for deployment, validation, browser test, portal validation, and cleanup

## Repository Structure

global-scale-retail-cloud/
├── terraform/
│   ├── aws/
│   │   ├── providers.tf
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── backend.tf.example
│   │   ├── user_data.sh
│   │   └── modules/
│   │       ├── network/
│   │       ├── security/
│   │       ├── alb/
│   │       └── compute/
│   └── gcp-optional-not-deployed/
├── azure-templates/
│   ├── main.bicep
│   ├── parameters.dev.json
│   ├── policy/
│   │   └── require-tags.bicep
│   └── scripts/
├── scripts/
├── screenshots/
│   ├── aws/
│   ├── azure/
│   └── destroy/
└── README.md

## AWS Architecture

The AWS part was created with Terraform.

Implemented AWS resources:

- VPC: 10.2.0.0/16
- 2 public subnets
- 2 private subnets
- Internet Gateway
- Public Application Load Balancer
- Target Group
- Auto Scaling Group
- 2 private EC2 instances
- Security Groups
- S3 Terraform backend with state locking

The EC2 instances are placed in private subnets and are not directly exposed to the internet. Public HTTP traffic reaches the Application Load Balancer first. The ALB forwards traffic to the private EC2 instances on port 8080.

AWS traffic flow:

Internet
  -> Public Application Load Balancer
  -> Private EC2 instances in Auto Scaling Group
  -> Python HTTP server returning Hello AWS page

## AWS Test Result

The ALB browser test returned the expected HTML page:

Hello AWS - Global Scale Retail Cloud

Served from a private EC2 instance behind an Application Load Balancer.

AWS screenshots are stored under:

screenshots/aws/

AWS destroy evidence is stored under:

screenshots/destroy/

## Azure Architecture

The Azure part was created with Bicep and deployed through Azure Cloud Shell using Template Spec.

Implemented Azure resources:

- Resource Group: rg-global-retail-prod
- Template Spec: global-retail-template-spec
- VNet: global-retail-prod-vnet
- Address space: 10.1.0.0/16
- Frontend subnet: 10.1.1.0/24
- Backend subnet: 10.1.2.0/24
- Database subnet: 10.1.3.0/24
- NSG: global-retail-prod-nsg
- Azure SQL Server
- Azure SQL Database: global-retail-prod-db
- SQL firewall rule for the configured public IP
- Subscription-level tag policy

## Azure Region Note

The initial Azure deployment attempt in westeurope was blocked by the Azure for Students subscription region policy. The deployment was validated and successfully completed in francecentral.

## Azure Tags

The project uses the required tags:

- Environment = Prod
- Owner = Master-Grad
- CostCenter = 101
- Project = global-retail
- ManagedBy = Bicep / AzureCLI

Azure screenshots are stored under:

screenshots/azure/

Azure destroy evidence is stored under:

screenshots/destroy/

## GCP Status

The GCP part is documented as optional and not deployed because the available GCP credit was exhausted.

The intended GCP architecture includes:

- Custom VPC
- Subnet
- Private Compute Engine instance
- Cloud IAP access

The GCP section is kept in the repository for documentation purposes.

## Cost Safety

The project was designed with cost control in mind:

- AWS EC2 instance type was set to t3.micro
- AWS resources were destroyed after validation
- Azure resources were destroyed after validation
- No NAT Gateway was used in AWS
- Terraform state files and secrets are excluded from Git
- Screenshots include destroy evidence

## Main Commands

AWS:

terraform -chdir=terraform/aws init
terraform -chdir=terraform/aws validate
terraform -chdir=terraform/aws plan
terraform -chdir=terraform/aws apply
terraform -chdir=terraform/aws destroy

Azure:

./azure-templates/scripts/01-create-resource-group.sh
./azure-templates/scripts/02-create-template-spec.sh
./azure-templates/scripts/03-deploy-template-spec.sh
./azure-templates/scripts/04-get-sql-connection-string.sh
./azure-templates/scripts/06-deploy-tag-policy.sh
./azure-templates/scripts/05-destroy-azure.sh

## Evidence

Deployment and cleanup screenshots are available in:

- screenshots/aws/
- screenshots/azure/
- screenshots/destroy/

## Final Status

- AWS deployment completed successfully.
- AWS browser test completed successfully.
- AWS resources were destroyed successfully.
- Azure deployment completed successfully.
- Azure Template Spec deployment completed successfully.
- Azure resources were destroyed successfully.
- GCP was documented as optional and not deployed due to credit limitations.
