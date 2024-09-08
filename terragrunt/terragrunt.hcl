# Asks Terragrunt to merge all env.hcl files found in the aborescence
inputs = merge(
  read_terragrunt_config(find_in_parent_folders("env.hcl")).inputs,
  read_terragrunt_config(find_in_parent_folders("global.hcl")).inputs
)

# Asks Terragrunt to generate the provider.tf file
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  access_key                  = "foo"
  secret_key                  = "bar"
  region                      = "eu-west-3"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    es             = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    route53        = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
    ec2            = "http://localhost:4566"
  }

  default_tags {
    tags = {
      ManagedBy = "Terraform"
    }
  }
}
EOF
}

# Asks Terragrunt to generate the terrform.tf file
generate "terraform_block" {
  path      = "terraform.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {

  # Terragrunt is based on OpenTofu
  required_version = ">= 1.8.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.43.0"
    }
  }
  
  backend "s3" {
    bucket         = "terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
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
EOF
}