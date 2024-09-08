variable "create_instance" {
  description = "Whether to create a instance."
  type        = bool
  default     = false
}

variable "ami" {
  type    = string
  default = "ami-00232bbfe70330a10"
}

variable "instance_type" {
  type = string
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

variable "env_name" {
  type = string
}
