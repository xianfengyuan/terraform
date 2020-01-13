output "group_id" {
  description = "The id of the VPC security group."
  value       = aws_security_group.vpc_sg.id
}

