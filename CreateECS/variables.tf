variable "region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "myapp"
}

variable "app_image" {
  description = "Docker image (e.g., nginx or ECR image)"
  default     = "nginx:latest"
}

variable "environment" {
  default = "prod"
}
