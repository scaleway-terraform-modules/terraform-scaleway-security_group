variable "create_security_group" {
  type        = bool
  description = "Whether to create a new security group. Set to false to attach the rules to an existing security group, given in `security_group_id`."
  default     = true
  nullable    = false
}

variable "description" {
  type        = string
  description = "Description of the security group. Only used when `create_security_group` is true: a warning is displayed when it is set otherwise."
  default     = null
}

variable "enable_default_security" {
  type        = bool
  description = "Whether to block outgoing SMTP traffic (ports 25, 465 and 587) on IPv4 and IPv6. Set to false to unblock it if your organization is authorized to send SMTP traffic; otherwise, open a support ticket to request it."
  default     = true
  nullable    = false
}

variable "inbound_default_policy" {
  type        = string
  description = "Default policy applied to incoming traffic matching no rule: `accept` or `drop`."
  default     = "drop"
  nullable    = false

  validation {
    condition     = contains(["accept", "drop"], var.inbound_default_policy)
    error_message = "'inbound_default_policy' must be one of `accept` or `drop`."
  }
}

variable "inbound_rules" {
  type = list(object({
    action     = string
    protocol   = string
    port       = optional(number)
    port_range = optional(string)
    ip_ranges  = optional(list(string), ["0.0.0.0/0"])
    # Kept only to reject them: undeclared attributes would be silently dropped, leaving the rule open to 0.0.0.0/0.
    ip       = optional(string)
    ip_range = optional(string)
  }))
  description = "List of inbound rules to add to the security group. When empty (default), only `inbound_default_policy` applies to incoming traffic. Each rule applies to every range of `ip_ranges` (default `[\"0.0.0.0/0\"]`, i.e. all IPv4 addresses), e.g. `[\"0.0.0.0/0\", \"::/0\"]` for all IPv4 and IPv6 addresses, or `[\"192.0.2.10/32\"]` for a single address. A rule without `port` nor `port_range` applies to all ports. `ip` and `ip_range` are not supported: use `ip_ranges` instead."
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for rule in var.inbound_rules : rule.ip == null && rule.ip_range == null])
    error_message = "'inbound_rules[].ip' and 'inbound_rules[].ip_range' are not supported: use 'ip_ranges' instead, e.g. `[\"192.0.2.10/32\"]` for a single address."
  }

  validation {
    condition     = alltrue([for rule in var.inbound_rules : length(rule.ip_ranges) > 0])
    error_message = "'inbound_rules[].ip_ranges' must not be empty."
  }

  validation {
    condition     = alltrue([for rule in var.inbound_rules : length(distinct(rule.ip_ranges)) == length(rule.ip_ranges)])
    error_message = "'inbound_rules[].ip_ranges' values must be unique within a rule."
  }

  validation {
    condition     = alltrue([for rule in var.inbound_rules : try(contains(["accept", "drop"], rule.action), false)])
    error_message = "'inbound_rules[].action' must be one of `accept` or `drop`."
  }

  validation {
    condition     = alltrue([for rule in var.inbound_rules : try(contains(["TCP", "UDP", "ICMP", "ANY"], rule.protocol), false)])
    error_message = "'inbound_rules[].protocol' must be one of `TCP`, `UDP`, `ICMP` or `ANY`."
  }

  validation {
    condition     = alltrue([for rule in var.inbound_rules : rule.port == null || try(rule.port >= 1 && rule.port <= 65535 && floor(rule.port) == rule.port, false)])
    error_message = "'inbound_rules[].port' must be an integer between 1 and 65535."
  }

  validation {
    condition     = alltrue([for rule in var.inbound_rules : rule.port_range == null || try(can(regex("^[0-9]+-[0-9]+$", rule.port_range)) && tonumber(split("-", rule.port_range)[0]) >= 1 && tonumber(split("-", rule.port_range)[1]) <= 65535 && tonumber(split("-", rule.port_range)[0]) <= tonumber(split("-", rule.port_range)[1]), false)])
    error_message = "'inbound_rules[].port_range' must be a range of ports between 1 and 65535, lowest first, e.g. `8000-8080`."
  }

  validation {
    condition     = alltrue([for rule in var.inbound_rules : rule.port == null || rule.port_range == null])
    error_message = "'inbound_rules[].port' and 'inbound_rules[].port_range' are mutually exclusive."
  }

  validation {
    condition     = alltrue([for rule in var.inbound_rules : rule.port == null && rule.port_range == null || try(contains(["TCP", "UDP"], rule.protocol), false)])
    error_message = "'inbound_rules[].port' and 'inbound_rules[].port_range' can only be set when 'protocol' is `TCP` or `UDP`."
  }
}

variable "name" {
  type        = string
  description = "Name of the security group. The provider generates a random name when null. Only used when `create_security_group` is true."
  default     = null
}

variable "outbound_default_policy" {
  type        = string
  description = "Default policy applied to outgoing traffic matching no rule: `accept` or `drop`."
  default     = "drop"
  nullable    = false

  validation {
    condition     = contains(["accept", "drop"], var.outbound_default_policy)
    error_message = "'outbound_default_policy' must be one of `accept` or `drop`."
  }
}

variable "outbound_rules" {
  type = list(object({
    action     = string
    protocol   = string
    port       = optional(number)
    port_range = optional(string)
    ip_ranges  = optional(list(string), ["0.0.0.0/0"])
    # Kept only to reject them: undeclared attributes would be silently dropped, leaving the rule open to 0.0.0.0/0.
    ip       = optional(string)
    ip_range = optional(string)
  }))
  description = "List of outbound rules to add to the security group. When empty (default), only `outbound_default_policy` applies to outgoing traffic. Each rule applies to every range of `ip_ranges` (default `[\"0.0.0.0/0\"]`, i.e. all IPv4 addresses), e.g. `[\"0.0.0.0/0\", \"::/0\"]` for all IPv4 and IPv6 addresses, or `[\"192.0.2.10/32\"]` for a single address. A rule without `port` nor `port_range` applies to all ports. `ip` and `ip_range` are not supported: use `ip_ranges` instead."
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for rule in var.outbound_rules : rule.ip == null && rule.ip_range == null])
    error_message = "'outbound_rules[].ip' and 'outbound_rules[].ip_range' are not supported: use 'ip_ranges' instead, e.g. `[\"192.0.2.10/32\"]` for a single address."
  }

  validation {
    condition     = alltrue([for rule in var.outbound_rules : length(rule.ip_ranges) > 0])
    error_message = "'outbound_rules[].ip_ranges' must not be empty."
  }

  validation {
    condition     = alltrue([for rule in var.outbound_rules : length(distinct(rule.ip_ranges)) == length(rule.ip_ranges)])
    error_message = "'outbound_rules[].ip_ranges' values must be unique within a rule."
  }

  validation {
    condition     = alltrue([for rule in var.outbound_rules : try(contains(["accept", "drop"], rule.action), false)])
    error_message = "'outbound_rules[].action' must be one of `accept` or `drop`."
  }

  validation {
    condition     = alltrue([for rule in var.outbound_rules : try(contains(["TCP", "UDP", "ICMP", "ANY"], rule.protocol), false)])
    error_message = "'outbound_rules[].protocol' must be one of `TCP`, `UDP`, `ICMP` or `ANY`."
  }

  validation {
    condition     = alltrue([for rule in var.outbound_rules : rule.port == null || try(rule.port >= 1 && rule.port <= 65535 && floor(rule.port) == rule.port, false)])
    error_message = "'outbound_rules[].port' must be an integer between 1 and 65535."
  }

  validation {
    condition     = alltrue([for rule in var.outbound_rules : rule.port_range == null || try(can(regex("^[0-9]+-[0-9]+$", rule.port_range)) && tonumber(split("-", rule.port_range)[0]) >= 1 && tonumber(split("-", rule.port_range)[1]) <= 65535 && tonumber(split("-", rule.port_range)[0]) <= tonumber(split("-", rule.port_range)[1]), false)])
    error_message = "'outbound_rules[].port_range' must be a range of ports between 1 and 65535, lowest first, e.g. `8000-8080`."
  }

  validation {
    condition     = alltrue([for rule in var.outbound_rules : rule.port == null || rule.port_range == null])
    error_message = "'outbound_rules[].port' and 'outbound_rules[].port_range' are mutually exclusive."
  }

  validation {
    condition     = alltrue([for rule in var.outbound_rules : rule.port == null && rule.port_range == null || try(contains(["TCP", "UDP"], rule.protocol), false)])
    error_message = "'outbound_rules[].port' and 'outbound_rules[].port_range' can only be set when 'protocol' is `TCP` or `UDP`."
  }
}

variable "project_id" {
  type        = string
  description = "ID of the project the security group is associated with. Resource will be created in the project set at the provider level if null. Only used when `create_security_group` is true: a warning is displayed when it is set otherwise."
  default     = null
}

variable "security_group_id" {
  type        = string
  description = "ID of an existing security group to attach the rules to, as `{zone}/{id}`, e.g. `fr-par-1/11111111-1111-1111-1111-111111111111`. Required when `create_security_group` is false. Ignored otherwise: a warning is displayed when it is set."
  default     = null

  validation {
    condition     = var.create_security_group || var.security_group_id != null
    error_message = "'security_group_id' must be set when 'create_security_group' is false."
  }

  validation {
    condition     = var.security_group_id == null || can(regex("^[a-z]+-[a-z]+-[0-9]+/[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.security_group_id))
    error_message = "'security_group_id' must be a zoned ID, as `{zone}/{id}`, e.g. `fr-par-1/11111111-1111-1111-1111-111111111111`."
  }
}

variable "stateful" {
  type        = bool
  description = "Whether the security group is stateful, i.e. automatically allows the return traffic of allowed connections."
  default     = true
  nullable    = false
}

variable "tags" {
  type        = list(string)
  description = "Tags associated with the security group. Duplicate tags are only applied once."
  default     = []
  nullable    = false
}

variable "zone" {
  type        = string
  description = "Zone in which the security group should be created, e.g. `fr-par-1`. Resource will be created in the zone set at the provider level if null. Only used when `create_security_group` is true: a warning is displayed when it is set otherwise, as the zone of an existing security group is part of `security_group_id`."
  default     = null
}
