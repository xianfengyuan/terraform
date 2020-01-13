terraform {
  backend "s3" {
    region = "us-west-1"
  }
}

module "vpc" {
  source = "../vpc"

  environment          = "keeper"
  aws_region           = var.region
  cidr_block           = var.cidr_block
  public_cidr_width    = var.public_cidr_width
  enable_nat_iam_setup = var.enable_nat_iam_setup
  gateway              = var.gateway

  // optional, defaults
  create_private_subnets     = "false"
  create_private_hosted_zone = "false" // default = true
}

module "keeper-traffic" {
  source              = "../sg"
  tcp_from_ports      = "22,80,4000"
  tcp_to_ports        = "22,80,4000"
  cidrs               = ["${var.gateway}/32"]
  security_group_name = "keeper-traffic"
  vpc_id              = module.vpc.vpc_id
  environment         = "keeper"
}
