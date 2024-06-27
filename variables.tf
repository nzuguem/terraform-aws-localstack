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
  validation {
    # TF 1.9 : Cross-object referencing for input variable validations
    condition     = var.instance_type != "" && var.create_instance
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