resource "aws_instance" "nginx" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "nginx"
  }
  user_data = file("${path.module}/install.nginx.sh")
}

data "aws_secretsmanager_secret" "test-secret" {
  name = "Test"
}