# ---------------------------------------------
# providers.tf
# ---------------------------------------------
terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "env/prod/ecs.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}


# ---------------------------------------------
# variables.tf
# ---------------------------------------------
variable "region" {
  default = "us-east-1"
}

variable "codestar_connection_arn" {}

# ---------------------------------------------
# ecr.tf
# ---------------------------------------------
resource "aws_ecr_repository" "java_app_repo" {
  name = "javatechie-registry"
  image_scanning_configuration {
    scan_on_push = true
  }
}

# ---------------------------------------------
# iam_roles.tf
# ---------------------------------------------
resource "aws_iam_role" "codebuild_role" {
  name = "codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "codebuild.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr_access" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ---------------------------------------------
# codebuild.tf
# ---------------------------------------------
resource "aws_codebuild_project" "java_app_build" {
  name         = "java-app-codebuild"
  description  = "Builds and pushes Docker image to ECR"
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type      = "GITHUB"
    location  = "https://github.com/VannSann/aws-cicd"
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true

    environment_variable {
    name  = "REPOSITORY_NAME"
    value = aws_ecr_repository.java_app_repo.name
  }

  environment_variable {
    name  = "REPOSITORY_URI"
    value = aws_ecr_repository.java_app.repository_url
  }

  environment_variable {
    name  = "IMAGE_TAG"
    value = "latest"
  }
  }
}

# ---------------------------------------------
# ecs.tf (you need to configure VPC, ALB, TG separately)
# ---------------------------------------------
resource "aws_ecs_cluster" "main" {
  name = "java-app-cluster"
}

resource "aws_ecs_task_definition" "java_app_task" {
  family                   = "java-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "0.5"
  memory                   = "1"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "javatechie-registry",
      image     = "${aws_ecr_repository.java_app_repo.repository_url}:latest",
      essential = true,
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 8080
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "java_service" {
  name            = "java-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.java_app.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
  }
}


# ---------------------------------------------
# pipeline.tf
# ---------------------------------------------
resource "aws_codepipeline" "java_app_pipeline" {
  name     = "java-app-pipeline"
  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"
  }

  ### Stage 1: Source (GitHub via CodeStar)
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn     = var.codestar_connection_arn
        FullRepositoryId  = "VannSann/aws-cicd"
        BranchName        = "main"
      }
    }
  }

  ### Stage 2: Build (Dockerize and Push to ECR)
  stage {
    name = "Build"
    action {
      name             = "BuildDockerImage"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = aws_codebuild_project.docker_build.name
      }
    }
  }

  ### Stage 3: Deploy to ECS
  stage {
    name = "Deploy"
    action {
      name            = "DeployToECS"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["build_output"]
      version         = "1"
      configuration = {
        ClusterName = aws_ecs_cluster.main.name
        ServiceName = aws_ecs_service.java_service.name
        FileName    = "imagedefinitions.json"
      }
    }
  }
}


# ---------------------------------------------
# s3.tf (pipeline artifacts bucket)
# ---------------------------------------------
resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "java-app-artifacts-2025"
  force_destroy = true
}
