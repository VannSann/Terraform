module "vpc" {
  source      = "./modules/vpc"
  vpc_name    = var.vpc_name
  environment = var.environment
  region      = var.region
  cidr_block  = "10.0.0.0/16"
  azs         = ["us-east-1a", "us-east-1b"]
}

module "iam" {
  source      = "./modules/iam"
  environment = var.environment
}

module "security" {
  source      = "./modules/security"
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}
