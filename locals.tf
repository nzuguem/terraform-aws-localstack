locals {
  users_list_tmp  = toset(split(",", var.users))
  users           = toset([for user in local.users_list_tmp : "${user}-${var.env_name}"])
  users_arns      = values(module.iam_user)
  credentials     = jsondecode(ephemeral.aws_secretsmanager_secret_version.credentials.secret_string)
  credentials_bad = jsondecode(data.aws_secretsmanager_secret_version.credentials_bad.secret_string)
}
