variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed."
  type        = string
  default     = "eu-north-1"
}

variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
  default     = "global-retail"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "prod"
}

variable "owner" {
  description = "Resource owner tag."
  type        = string
  default     = "Master-Grad"
}

variable "cost_center" {
  description = "Cost center tag."
  type        = string
  default     = "101"
}

variable "vpc_cidr" {
  description = "CIDR block for the AWS VPC."
  type        = string
  default     = "10.2.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.2.1.0/24", "10.2.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.2.11.0/24", "10.2.12.0/24"]
}
