output "nginx_ip" {
  value = aws_instance.nginx.public_ip
}

output "test_secret_arn" {
  value = data.aws_secretsmanager_secret.test_secret.arn
}