provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_s3" {
  bucket = "my-tf-bucket-${terraform.workspace}-${random_id.bucket_id.hex}"
  force_destroy = true

  tags = {
    Environment = terraform.workspace
    Name = "workspaceS3"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
