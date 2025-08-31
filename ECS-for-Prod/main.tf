# Root main.tf (production-ready ECS CI/CD pipeline)

module "network" {
  source = "./modules/network"
  region = var.region
}

module "ecr" {
  source = "./modules/ecr"
  repo_name = var.repo_name
}

module "iam" {
  source = "./modules/iam"
}

module "codebuild" {
  source = "./modules/codebuild"
  repo_name           = var.repo_name
  github_repo         = var.github_repo
  github_owner        = var.github_owner
  codebuild_role_arn  = module.iam.codebuild_role_arn
  ecr_repo_url        = module.ecr.repository_url
}

module "ecs" {
  source = "./modules/ecs"
  repo_name            = var.repo_name
  cluster_name         = var.cluster_name
  container_name       = var.container_name
  container_port       = 8080
  ecr_repo_url         = module.ecr.repository_url
  ecs_task_exec_role   = module.iam.ecs_task_exec_role_arn
  alb_sg_id            = module.network.alb_sg_id
  ecs_sg_id            = module.network.ecs_sg_id
  public_subnets       = module.network.public_subnets
  vpc_id               = module.network.vpc_id
}

module "codepipeline" {
  source = "./modules/codepipeline"
  repo_name            = var.repo_name
  github_repo          = var.github_repo
  github_owner         = var.github_owner
  connection_arn       = var.codestar_connection_arn
  cluster_name         = module.ecs.cluster_name
  service_name         = module.ecs.service_name
  codebuild_project    = module.codebuild.project_name
  artifact_bucket_name = module.codepipeline.artifact_bucket_name
  pipeline_role_arn    = module.iam.pipeline_role_arn
}

# variables.tf
variable "region" {
  default = "us-east-1"
}

variable "repo_name" {
  default = "javatechie"
}

variable "github_repo" {
  default = "aws-cicd"
}

variable "github_owner" {
  default = "VannSann"
}

variable "cluster_name" {
  default = "java-cluster"
}

variable "container_name" {
  default = "javatechie"
}

variable "codestar_connection_arn" {
  description = "GitHub CodeStar Connection ARN"
}
