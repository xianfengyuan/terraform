variable "environment" {
  description = "A logical name that will be used as prefix and tag for the created resources."
  type        = string
  default     = "vpc-dev"
}

variable "aws_region" {
  type        = string
  description = "The Amazon region."
}

variable "cidr_block" {
  description = "The CIDR block used for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_cidr_width" {
  description = "The CIDR public sub network width used for the VPC."
  default     = 8
}

variable "private_cidr_width" {
  description = "The CIDR private sub network width used for the VPC."
  default     = 8
}

variable "availability_zones" {
  type = map(list(string))

  default = {
    us-east-1 = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
    us-east-2 = ["us-east-2a", "eu-east-2b", "eu-east-2c"]
    us-west-1 = ["us-west-1a", "us-west-1c"]
    // us-west-2      = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
    us-west-2      = ["us-west-2a", "us-west-2b"]
    ca-central-1   = ["ca-central-1a", "ca-central-1b"]
    eu-west-1      = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
    eu-west-2      = ["eu-west-2a", "eu-west-2b"]
    eu-west-3      = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
    eu-central-1   = ["eu-central-1a", "eu-central-1b"]
    ap-south-1     = ["ap-south-1a", "ap-south-1b"]
    sa-east-1      = ["sa-east-1a", "sa-east-1c"]
    ap-east-1      = ["ap-east-1a", "ap-east-1b", "ap-east-1c"]
    ap-northeast-1 = ["ap-northeast-1a", "ap-northeast-1c"]
    ap-southeast-1 = ["ap-southeast-1a", "ap-southeast-1b"]
    ap-southeast-2 = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
    ap-northeast-2 = ["ap-northeast-2a", "ap-northeast-2c"]
  }
}

variable "create_private_subnets" {
  description = "If true create a private subnet for each availability zone."
  default     = "true"
}

variable "create_nat" {
  description = "If true create nat gateway or instance for private subnets."
  default     = "true"
}

variable "create_private_hosted_zone" {
  description = "If true a privated hosted zone is created."
  default     = "true"
}

variable "public_subnet_map_public_ip_on_launch" {
  description = "Set the default behavior for instances created in the VPC. If true by default a publi ip will be assigned."
  default     = "false"
}

variable "nat_ami_owner" {
  description = "owner-id of NAT AMI image"
  default     = "137112412989"
}

variable "nat_ami_version" {
  description = "version of NAT AMI image"
  default     = "2018.03.0.20181116"
}

variable "enable_nat_iam_setup" {
  default = 0
}

variable "gateway" {
  description = "IP address of gateway"
  default     = "2.3.4.5"
}
