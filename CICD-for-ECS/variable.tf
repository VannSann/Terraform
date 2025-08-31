variable "region" {
  default = "us-east-1"
}

variable "ecr_repo_name" {
  default = "springboot-ecr"
}

variable "ecs_cluster_name" {
  default = "springboot-cluster"
}

variable "ecs_service_name" {
  default = "springboot-service"
}

variable "ecs_task_family" {
  default = "springboot-task-def"
}

variable "container_port" {
  default = 8080
}

variable "cpu" {
  default = 1
}

variable "memory" {
  default = 1
}
