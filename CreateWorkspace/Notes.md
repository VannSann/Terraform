# 1. Initialize project
terraform init

# 2. Create and switch to "dev" workspace
terraform workspace new dev

# 3. Apply for dev
terraform apply

# 4. Create and switch to "prod"
terraform workspace new prod

# 5. Apply for prod
terraform apply


Terraform will create separate state files for dev and prod (internally stored in .terraform/environment and terraform.tfstate.d/).

