output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "availability_zones" {
  value = module.vpc.availability_zones
}

output "traffic_group_id" {
  value = module.keeper-traffic.group_id
}
