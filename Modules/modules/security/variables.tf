variable "vpc_id" {
  description = "VPC ID to attach security groups"
  type        = string
}

variable "environment" {
  description = "Environment name (dev/staging/prod)"
  type        = string
}
