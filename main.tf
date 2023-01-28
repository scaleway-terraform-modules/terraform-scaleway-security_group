resource "scaleway_instance_security_group" "this" {
  name     = var.name
  stateful = var.stateful

  inbound_default_policy  = var.inbound_default_policy
  outbound_default_policy = var.outbound_default_policy
  enable_default_security = var.enable_default_security
  external_rules          = true
  tags                    = var.tags
}


resource "scaleway_instance_security_group_rules" "inboud" {
  security_group_id = scaleway_instance_security_group.this.id

  dynamic "inbound_rule" {
    for_each = var.inbound_rules
    content {
      action   = inbound_rule.value.action
      ip_range = inbound_rule.value.ip_range
      port     = inbound_rule.value.port
      protocol = inbound_rule.value.protocol

    }
  }
}

resource "scaleway_instance_security_group_rules" "outband" {
  security_group_id = scaleway_instance_security_group.this.id

  dynamic "outbound_rule" {
    for_each = var.outbound_rules
    content {
      action   = outbound_rule.value.action
      ip_range = outbound_rule.value.ip_range
      port     = outbound_rule.value.port
      protocol = outbound_rule.value.protocol

    }
  }
}
