variable "name" {
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources"
}

variable "ami_name_pattern" {
  default     = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"
  description = "The name filter to use in data.aws_ami"
}

variable "ami_publisher" {
  default     = "099720109477" # Canonical
  description = "The AWS account ID of the AMI publisher"
}

variable "aws_region" {
}

variable "instance_type" {
}

variable "instance_count" {
}

variable "az_list" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "subnets_count" {
  description = "The number of subnets in public_subnet_ids. Required because of hashicorp/terraform#1497"
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "aws_key_name" {
}

variable "aws_key_location" {
}

variable "ssh_bastion_host" {
  default = ""
}

variable "ssh_bastion_user" {
  default = ""
}

variable "awsnycast_deb_url" {
  default = "https://github.com/bobtfish/AWSnycast/releases/download/v0.1.5/awsnycast_0.1.5-425_amd64.deb"
}

variable "route_table_identifier" {
  description = "Indentifier used by AWSnycast route table regexp"
  default     = "rt-private"
}

variable "enable_nat_iam_setup" {
  description = "If true, create the IAM Role, IAM Instance Profile, and IAM Policies. If false, these will not be created, and you can pass in your own IAM Instance Profile via var.nat_iam_instance_profile_name."
  default     = 0
}

variable "nat_iam_instance_profile_id" {
  description = "If enable_iam_setup is false then this will be the name of the IAM instance profile to attach"
  default     = ""
}

