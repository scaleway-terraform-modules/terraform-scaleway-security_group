##################################
# Get ID of created Security Group
##################################
locals {
  this_sg_id = var.create_security_group ? scaleway_instance_security_group.this[0].id : var.security_group_id

  # One provider rule per range of each rule, keeping the order of the rules and of their ranges: rules are evaluated in order.
  inbound_rules  = flatten([for rule in var.inbound_rules : [for ip_range in rule.ip_ranges : merge(rule, { ip_range = ip_range })]])
  outbound_rules = flatten([for rule in var.outbound_rules : [for ip_range in rule.ip_ranges : merge(rule, { ip_range = ip_range })]])
}

resource "scaleway_instance_security_group" "this" {
  count       = var.create_security_group ? 1 : 0
  name        = var.name
  description = var.description
  stateful    = var.stateful

  inbound_default_policy  = var.inbound_default_policy
  outbound_default_policy = var.outbound_default_policy
  enable_default_security = var.enable_default_security
  external_rules          = true
  tags                    = distinct(var.tags)
}

resource "scaleway_instance_security_group_rules" "this" {
  security_group_id = local.this_sg_id

  dynamic "inbound_rule" {
    for_each = local.inbound_rules
    content {
      action     = inbound_rule.value.action
      ip_range   = inbound_rule.value.ip_range
      port       = inbound_rule.value.port
      port_range = inbound_rule.value.port_range
      protocol   = inbound_rule.value.protocol
    }
  }

  dynamic "outbound_rule" {
    for_each = local.outbound_rules
    content {
      action     = outbound_rule.value.action
      ip_range   = outbound_rule.value.ip_range
      port       = outbound_rule.value.port
      port_range = outbound_rule.value.port_range
      protocol   = outbound_rule.value.protocol
    }
  }
}

# A failed check only displays a warning: it doesn't stop the plan.

check "unused_description" {
  assert {
    condition     = var.create_security_group || var.description == null
    error_message = "'description' is ignored when 'create_security_group' is false: the module doesn't manage the existing security group."
  }
}

check "unused_security_group_id" {
  assert {
    condition     = !var.create_security_group || var.security_group_id == null
    error_message = "'security_group_id' is ignored when 'create_security_group' is true: the rules are attached to the security group created by the module."
  }
}
