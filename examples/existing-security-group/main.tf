provider "scaleway" {}

# Security group managed outside of the module, e.g. by another team or configuration. As the module manages its rules,
# it must set `external_rules = true` and have no inline rule.
resource "scaleway_instance_security_group" "existing" {
  name                    = "example-existing-security-group"
  inbound_default_policy  = "drop"
  outbound_default_policy = "accept"
  external_rules          = true
}

module "security_group_rules" {
  source = "../.."

  create_security_group = false
  security_group_id     = scaleway_instance_security_group.existing.id

  inbound_rules = [
    {
      action    = "accept"
      protocol  = "TCP"
      port      = 443
      ip_ranges = ["0.0.0.0/0", "::/0"]
    },
  ]
}
