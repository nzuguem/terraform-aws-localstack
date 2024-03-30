output "nginx-ip" {
  value = aws_instance.nginx.public_ip
}

output "test-secret-arn" {
  value = data.aws_secretsmanager_secret.test-secret.arn
}