variable "ami" {
  type    = string
  default = "ami-00232bbfe70330a10"
}

variable "instance-type" {
  type = string
}

variable "users" {
  type    = string
  default = "kevin,idriss,pores,michelle"
}