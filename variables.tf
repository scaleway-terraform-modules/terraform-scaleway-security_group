variable "name" {
  description = "Name of the security group."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the security group."
  type        = string
  default     = null
}
variable "stateful" {
  description = "Boolean to specify whether the security group should be stateful or not."
  type        = bool
  default     = true
}

variable "inbound_default_policy" {
  description = "Default policy on incoming traffic. Possible values are: accept or drop."
  type        = string
  default     = "drop"

  validation {
    condition     = contains(["accept", "drop"], var.inbound_default_policy)
    error_message = "The inbound_default_policy value must be one of 'accept' or 'drop'."
  }
}

variable "outbound_default_policy" {
  description = "Default policy on outgoing traffic. Possible values are: accept or drop."
  type        = string
  default     = "drop"

  validation {
    condition     = contains(["accept", "drop"], var.outbound_default_policy)
    error_message = "The outbound_default_policy value must be one of 'accept' or 'drop'."
  }
}

variable "inbound_rules" {
  description = "List of inbound rule to add to the security group."
  type = list(object({
    action     = string
    protocol   = string
    port       = optional(number)
    port_range = optional(string)
    ip         = optional(string)
    ip_range   = optional(string)
  }))
  default = [
    {
      action     = null
      protocol   = null
      port       = null
      port_range = null
      ip         = null
      ip_range   = null
    }
  ]
}

variable "outbound_rules" {
  description = "List of outbound rule to add to the security group."
  type = list(object({
    action   = string
    protocol = string
    port       = optional(number)
    port_range = optional(string)
    ip         = optional(string)
    ip_range   = optional(string)
  }))
  default = [
    {
      action     = null
      protocol   = null
      port       = null
      port_range = null
      ip         = null
      ip_range   = null
    }
  ]
}

variable "enable_default_security" {
  description = "Whether to block SMTP on IPv4/IPv6 (Port 25, 465, 587). Set to false will unblock SMTP if your account is authorized to. If your organization is not yet authorized to send SMTP traffic, open a support ticket."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags associated with the security group and its rules."
  type        = list(any)
  default     = []
}
