bucket         = "tfstate-staging-bucket-2025"
key            = "envs/staging/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-lock-table"
encrypt        = true
