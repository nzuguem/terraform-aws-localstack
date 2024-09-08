terraform {
  # Asks Terragrunt to fetch the sources (the Terraform configuration) of the application.
  # The application is defined as a Terraform module
  # The source can be a project on Git
  source = "${get_parent_terragrunt_dir()}/modules/aws-app"
}

# Instructs Terraform to include all the config of terragrunt.hcl file in other place (in this case, in the root folder)
include "root" {
  # The path to the terragrunt.hcl file
  path = find_in_parent_folders()
}

# Inputs to be passed to the module (source of Terraform Block above)
# This block input has priority over the env.hcl file (shared by all applications in the environment).
inputs = {
  instance_type = "t2.nano"
}