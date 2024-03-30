locals {
  users = toset(split(",", var.users))
}