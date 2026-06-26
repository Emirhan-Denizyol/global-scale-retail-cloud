output "alb_security_group_id" {
  description = "Security group ID of the Application Load Balancer."
  value       = aws_security_group.alb.id
}

output "ec2_security_group_id" {
  description = "Security group ID of the private EC2 instances."
  value       = aws_security_group.ec2.id
}
