variable "region" {
  type        = string
  description = "AWS region to deploy the bucket"
  default     = "us-east-1"
}

variable "bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name"
  default = "my_dev_s3_2025"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"
}

variable "enable_logging" {
  type        = bool
  description = "Enable access logging"
  default     = true
}
