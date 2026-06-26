variable "project_name" {
  description = "Project name used for resource naming."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs where EC2 instances will run."
  type        = list(string)
}

variable "ec2_security_group_id" {
  description = "Security group ID attached to private EC2 instances."
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN used by the Auto Scaling Group."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of EC2 instances."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EC2 instances."
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "Desired number of EC2 instances."
  type        = number
  default     = 2
}

variable "common_tags" {
  description = "Common resource tags."
  type        = map(string)
}
