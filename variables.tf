variable "ami" {
  type    = string
  default = "ami-00232bbfe70330a10"
}

variable "instance_type" {
  type    = string
  default = ""
  validation {
    condition     = var.instance_type != ""
    error_message = "Instance Type is mandatory"
  }
}

variable "users" {
  type    = string
  default = "kevin,idriss,pores,michelle"
}

variable "sg_settings" {
  type = list(object({
    description = string
    port        = number
  }))
  default = [
    {
      description = "Allows SSH access"
      port        = 22
    },
    {
      description = "Allows HTTP traffic"
      port        = 80
    },
    {
      description = "Allows HTTPS traffic"
      port        = 443
    }
  ]
}

variable "passphrase_encryption" {
  type      = string
  default   = "hard-passphrase-try-to-find"
  sensitive = true
}