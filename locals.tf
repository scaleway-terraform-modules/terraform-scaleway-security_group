locals {
  this_sg_id = var.create_security_group ? scaleway_instance_security_group.this[0].id : var.security_group_id

  # One provider rule per range of each rule, keeping the order of the rules and of their ranges: rules are evaluated in order.
  inbound_rules  = flatten([for rule in var.inbound_rules : [for ip_range in rule.ip_ranges : merge(rule, { ip_range = ip_range })]])
  outbound_rules = flatten([for rule in var.outbound_rules : [for ip_range in rule.ip_ranges : merge(rule, { ip_range = ip_range })]])
}
