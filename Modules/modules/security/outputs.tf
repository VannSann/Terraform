output "security_group_ids" {
  description = "List of all security group IDs"
  value = [
    aws_security_group.ssh_sg.id,
    aws_security_group.web_sg.id
  ]
}
