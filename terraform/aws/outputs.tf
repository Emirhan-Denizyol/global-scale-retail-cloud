output "vpc_id" {
  description = "ID of the AWS VPC."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of public subnets."
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of private subnets."
  value       = module.network.private_subnet_ids
}

output "alb_dns_name" {
  description = "DNS name of the public Application Load Balancer."
  value       = module.alb.alb_dns_name
}

output "alb_name" {
  description = "Name of the Application Load Balancer."
  value       = module.alb.alb_name
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group."
  value       = module.compute.autoscaling_group_name
}
