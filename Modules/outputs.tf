output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnets
}

output "iam_role_arn" {
  description = "IAM role ARN"
  value       = module.iam.role_arn
}

output "security_group_ids" {
  description = "List of Security Group IDs"
  value       = module.security.security_group_ids
}
