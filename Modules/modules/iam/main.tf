resource "aws_iam_role" "terraform_exec_role" {
  name = "terraform-exec-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_policy" "terraform_exec_policy" {
  name = "terraform-exec-policy-${var.environment}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["ec2:*", "s3:*", "iam:*", "logs:*"]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.terraform_exec_role.name
  policy_arn = aws_iam_policy.terraform_exec_policy.arn
}
