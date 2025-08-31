output "ecr_repo_url" {
  value = aws_ecr_repository.springboot.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.springboot.name
}

output "ecs_service_name" {
  value = aws_ecs_service.springboot.name
}

output "task_definition_family" {
  value = aws_ecs_task_definition.springboot.family
}
