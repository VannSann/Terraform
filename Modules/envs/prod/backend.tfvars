bucket         = "tfstate-prod-bucket-2025"
key            = "envs/prod/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "terraform-lock-table"
encrypt        = true
