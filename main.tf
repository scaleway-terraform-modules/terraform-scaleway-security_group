##################################
# Get ID of created Security Group
##################################
locals {
  this_sg_id = var.create_sg ? scaleway_instance_security_group.this[0].id : var.security_group_id
}

resource "scaleway_instance_security_group" "this" {
  count       = var.create_sg ? 1 : 0
  name        = var.name
  description = var.security_group_description
  stateful    = var.stateful

  inbound_default_policy  = var.inbound_default_policy
  outbound_default_policy = var.outbound_default_policy
  enable_default_security = var.enable_default_security
  external_rules          = true
  tags = concat(
    var.tags,
    var.sg_tags,
  )
}

resource "scaleway_instance_security_group_rules" "this" {
  security_group_id = local.this_sg_id

  dynamic "inbound_rule" {
    for_each = var.inbound_rules
    content {
      action     = inbound_rule.value.action
      ip_range   = inbound_rule.value.ip_range
      port       = inbound_rule.value.port
      port_range = inbound_rule.value.port_range
      protocol   = inbound_rule.value.protocol
    }
  }

  dynamic "outbound_rule" {
    for_each = var.outbound_rules
    content {
      action     = outbound_rule.value.action
      ip_range   = outbound_rule.value.ip_range
      port       = outbound_rule.value.port
      port_range = outbound_rule.value.port_range
      protocol   = outbound_rule.value.protocol
    }
  }
}
