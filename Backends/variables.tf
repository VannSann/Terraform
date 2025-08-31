variable "bucket_name" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
  default     = "my-dev-bucket-2025"
}

variable "lock_table_name" {
  description = "The name of the DynamoDB table to use for state locking"
  type        = string
  default     = "terraform-lock-table"
}

variable "region" {
  description = "AWS Region to deploy backend resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}
