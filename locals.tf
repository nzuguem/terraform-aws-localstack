locals {
  users      = toset(split(",", var.users))
  users_arns = values(module.iam_user)
}