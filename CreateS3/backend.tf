terraform {
  backend "s3" {
    bucket         = "my-terraform-state-testttt-bucket-2025"
    key            = "env/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
