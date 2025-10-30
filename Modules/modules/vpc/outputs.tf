output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc_base.vpc_id
}

output "public_subnets" {
  description = "Public subnets"
  value       = module.vpc_base.public_subnets
}

output "private_subnets" {
  description = "Private subnets"
  value       = module.vpc_base.private_subnets
}
