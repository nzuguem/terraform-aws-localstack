terraform {
  # Asks Terragrunt to fetch the sources (the Terraform configuration) of the application.
  # The application is defined as a Terraform module
  source = "${get_parent_terragrunt_dir()}/modules/aws-app"
}

include "root" {
  # Ask Terragrunt to consider overwriting this defined file (terragrunt.hcl) at Root level
  path = find_in_parent_folders()
}