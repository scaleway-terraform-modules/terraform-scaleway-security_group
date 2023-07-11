# Scaleway Security Group Terraform module

Terraform module that can be used to deploy a Security Groups configuration with their rules on Scaleway. Common
deployment examples can be found in [examples/](../../examples).

This is a basic example showing how to use the module.

## Usage

The example below provision a basic Security Group configuration.

``` hcl


locals {
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

module "my_sg" {
  source                     = "scaleway-terraform-modules/security_group/scaleway"
  name                       = "my_security_group"
  create_sg                  = true
  security_group_description = "description"
  inbound_rules              = local.inbound_rules
  outbound_rules             = local.outbound_rules
}
```
