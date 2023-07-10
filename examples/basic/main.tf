provider "scaleway" {
  region = "fr-par"
  zone   = "fr-par-1"
}

locals {
  name        = "example-module-security-group-and-rules-${basename(path.cwd)}"
  description = "Security group with all available arguments set (this is just an example)"

  tags = [
    local.name,
    "terraform-scaleway-security-group-module"
  ]

  create_sg = true

  inbound_rules = [
    {
      action     = "accept"
      ip_range   = "10.10.0.0/20"
      port_range = "15-25"
      protocol   = "TCP"
    },
    {
      action   = "drop"
      port     = 443
      ip_range = "0.0.0.0/0"
      protocol = "TCP"
    }
  ]
  outbound_rules = [
    {
      action     = "accept"
      port_range = "80-90"
      ip_range   = "0.0.0.0/0"
      protocol   = "TCP"
    },
    {
      action   = "drop"
      port     = 443
      ip_range = "0.0.0.0/0"
      protocol = "TCP"
    }
  ]
}

################################################################################
# Security Group Module
################################################################################

module "sg" {
  source                     = "../../"
  name                       = local.name
  create_sg                  = local.create_sg
  security_group_description = local.description
  tags                       = local.tags
  inbound_rules              = local.inbound_rules
  outbound_rules             = local.outbound_rules
}
