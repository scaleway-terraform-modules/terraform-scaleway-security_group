variable "name" {
  type    = string
  default = "git-servers"
}

variable "stateful" {
  type    = bool
  default = true
}

variable "inbound_default_policy" {
  type    = string
  default = "drop"
}

variable "outbound_default_policy" {
  type    = string
  default = "drop"
}

variable "tags" {
  type        = list(any)
  description = "Tags associated with the security group and its rules."
  default     = []
}

variable "enable_default_security" {
  type    = bool
  default = true
}

variable "inbound_rules" {
  type = list(object({
    action   = string
    protocol = string
    port     = optional(number)
    ip_range = optional(string)
  }))
  default = [
    {
      action   = null
      protocol = null
      port     = null
      ip_range = null
    }
  ]
}

variable "outbound_rules" {
  type = list(object({
    action   = string
    protocol = string
    port     = optional(number)
    ip_range = optional(string)
  }))
  default = [
    {
      action   = null
      protocol = null
      port     = null
      ip_range = null
    }
  ]
}