output "role_arn" {
  description = "Terraform execution IAM role ARN"
  value       = aws_iam_role.terraform_exec_role.arn
}
