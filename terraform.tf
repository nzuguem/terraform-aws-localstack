terraform {

  required_version = ">= 1.7.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state"
    key            = "terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-state"
    # https://github.com/localstack/localstack/issues/3982#issuecomment-838121468
    force_path_style = true
    endpoints = {
      s3       = "http://localhost:4566"
      dynamodb = "http://localhost:4566"
    }
  }

}