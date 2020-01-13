provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.8"
}

resource "aws_vpc" "vpc" {
  cidr_block           = cidrsubnet(var.cidr_block, 0, 0)
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.environment}-internet-gateway"
    Environment = var.environment
  }
}

resource "aws_route_table" "public_routetable" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name        = "${var.environment}-public-routetable"
    Environment = var.environment
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = cidrsubnet(var.cidr_block, var.public_cidr_width, count.index)
  availability_zone       = element(var.availability_zones[var.aws_region], count.index)
  map_public_ip_on_launch = var.public_subnet_map_public_ip_on_launch
  count                   = length(var.availability_zones[var.aws_region])

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones[var.aws_region], count.index)}-public"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_routing_table" {
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_routetable.id
  count          = length(var.availability_zones[var.aws_region])
}

resource "aws_route_table" "private_routetable" {
  count  = var.create_private_subnets ? length(var.availability_zones[var.aws_region]) : 0
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = element(module.nat.instance_ids, count.index)
  }

  tags = {
    Name        = "${var.environment}-private-routetable"
    Environment = var.environment
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(
    var.cidr_block,
    var.private_cidr_width,
    length(var.availability_zones[var.aws_region]) + count.index,
  )
  availability_zone       = element(var.availability_zones[var.aws_region], count.index)
  map_public_ip_on_launch = false
  count                   = var.create_private_subnets ? length(var.availability_zones[var.aws_region]) : 0

  tags = {
    Name        = "${var.environment}-${element(var.availability_zones[var.aws_region], count.index)}-private"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private_routing_table" {
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private_routetable.*.id, count.index)
  count          = var.create_private_subnets ? length(var.availability_zones[var.aws_region]) : 0
}

resource "aws_eip" "nat" {
  count = var.create_private_subnets ? length(var.availability_zones[var.aws_region]) : 0
  vpc   = true
}

module "nat-traffic-local" {
  source              = "../sg"
  tcp_from_ports      = "1"
  tcp_to_ports        = "65535"
  cidrs               = [var.cidr_block]
  security_group_name = "nat-local"
  vpc_id              = aws_vpc.vpc.id
  environment         = var.environment
}

module "nat-traffic-ssh" {
  source              = "../sg"
  tcp_from_ports      = "22"
  tcp_to_ports        = "22"
  cidrs               = ["${var.gateway}/32"]
  security_group_name = "nat-ssh"
  vpc_id              = aws_vpc.vpc.id
  environment         = var.environment
}

module "nat" {
  source                 = "../nat"
  name                   = var.environment
  instance_type          = "t3.medium"
  instance_count         = var.create_private_subnets ? length(var.availability_zones[var.aws_region]) : 0
  aws_key_name           = "safelykey"
  public_subnet_ids      = aws_subnet.public_subnet.*.id
  private_subnet_ids     = aws_subnet.private_subnet.*.id
  vpc_security_group_ids = [module.nat-traffic-local.group_id, module.nat-traffic-ssh.group_id]
  az_list                = var.availability_zones[var.aws_region]
  subnets_count          = length(var.availability_zones[var.aws_region])
  route_table_identifier = "${var.environment}-private"
  ssh_bastion_user       = "ubuntu"
  ssh_bastion_host       = ""
  aws_key_location       = file("../../.ssh/safelykey")
  ami_publisher          = var.nat_ami_owner
  ami_name_pattern       = "amzn-ami-vpc-nat-hvm-${var.nat_ami_version}-x86_64-ebs"
  aws_region             = var.aws_region
  enable_nat_iam_setup   = var.enable_nat_iam_setup

  tags = {
    Name        = "${var.environment}-nat-instance"
    Environment = var.environment
  }
}

resource "aws_eip_association" "nat_eip_assoc" {
  count         = var.create_private_subnets ? length(var.availability_zones[var.aws_region]) : 0
  allocation_id = element(aws_eip.nat.*.id, count.index)
  instance_id   = element(module.nat.instance_ids, count.index)
}

resource "aws_route53_zone" "local" {
  count   = var.create_private_hosted_zone ? 1 : 0
  name    = "${var.environment}.local"
  comment = "${var.environment} - route53 - local hosted zone"

  tags = {
    Name        = "${var.environment}-route53-private-hosted-zone"
    Environment = var.environment
  }

  vpc_id = aws_vpc.vpc.id
}
