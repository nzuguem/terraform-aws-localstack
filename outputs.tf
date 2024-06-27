output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}

output "test_secret_arn" {
  value = data.aws_secretsmanager_secret.test_secret.arn
}

output "test_secret_account_id" {
  # TF 1.8 : Provider-defined functions
  value = provider::aws::arn_parse(data.aws_secretsmanager_secret.test_secret.arn).account_id
}

output "users_arns" {
  value = local.users_arns[*].iam_user_arn
}

