variable "region" {
  description = "AWS region for deployment"
  type        = string
}

variable "environment" {
  description = "Deployment environment name (e.g., dev/staging/prod)"
  type        = string
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
}
