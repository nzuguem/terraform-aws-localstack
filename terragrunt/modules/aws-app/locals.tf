locals {
  users_list_tmp = toset(split(",", var.users))
  users          = toset([for user in local.users_list_tmp : "${user}-${var.env_name}"])
  users_arns     = values(module.iam_user)
}
