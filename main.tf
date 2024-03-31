resource "aws_vpc" "sandbox_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "sandbox_vpc"
  }
}

resource "aws_subnet" "sandbox_subnet" {
  vpc_id     = aws_vpc.sandbox_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "sandbox_subnet"
  }
}

resource "aws_security_group" "sandbox_sg" {
  name   = "sandbox_sg"
  vpc_id = aws_vpc.sandbox_vpc.id

  dynamic "ingress" {
    for_each = var.sg_settings
    content {
      description = ingress.value["description"]
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = "tcp"
      cidr_blocks = [aws_vpc.sandbox_vpc.cidr_block]
    }
  }

  tags = {
    Name = "sandbox_sg"
  }
}

resource "aws_instance" "nginx" {
  ami                    = var.ami
  instance_type          = var.instance_type
  user_data              = file("${path.module}/install.nginx.sh")
  subnet_id              = aws_subnet.sandbox_subnet.id
  vpc_security_group_ids = [aws_security_group.sandbox_sg.id]

  tags = {
    Name = "nginx"
  }

}

data "aws_secretsmanager_secret" "test_secret" {
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