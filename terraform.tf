terraform {

  required_version = ">= 1.7.0"

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

  # GitHub Remote Backend -> https://tfstate.dev/
  # export TF_HTTP_PASSWORD=<your-github-token> or terraform init -backend-config="password=<your-github-token>"
  /*   backend "http" {
    address        = "https://api.tfstate.dev/github/v1"
    lock_address   = "https://api.tfstate.dev/github/v1/lock"
    unlock_address = "https://api.tfstate.dev/github/v1/lock"
    lock_method    = "PUT"
    unlock_method  = "DELETE"
    username       = "<GitHubOrg>/<GithubRepo>"
  } */


  # GitLab Remote Backend -> https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html
  # export TF_HTTP_PASSWORD=<your-gitlab-token> or terraform init -backend-config="password=<your-gitlab-token>"
  /*   backend "http" {
    address        = "https://gitlab.com/api/v4/projects/<ProjectID>/terraform/state/<StateName>"
    lock_address   = "https://gitlab.com/api/v4/projects/<ProjectID>/terraform/state/<StateName>/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/<ProjectID>/terraform/state/<StateName>/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    username       = "<GitlabUserName>"
  } */

}