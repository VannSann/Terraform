resource "aws_s3_bucket" "my_s3" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
  Name = var.bucket_name
  Environment = var.environment
  ManagedBy = "Terraform"
}
}

resource "aws_s3_bucket_versioning" "my_versioning" {
  bucket = aws_s3_bucket.my_s3.id

  versioning_configuration {
    status = "Enabled"
}
}

resource "aws_s3_bucket_public_access_block" "my_access" {
  bucket = aws_s3_bucket.my_s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}
