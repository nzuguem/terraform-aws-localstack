resource "aws_instance" "nginx" {
  ami           = var.ami
  instance_type = var.instance-type
  tags = {
    Name = "nginx"
  }
  user_data = file("${path.module}/install.nginx.sh")
}

data "aws_secretsmanager_secret" "test-secret" {
  name = "Test"
}

module "iam-user" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-user"
  version                       = "~> 5.37.2"
  create_iam_access_key         = false
  create_iam_user_login_profile = false
  name                          = each.value
  for_each                      = local.users
}