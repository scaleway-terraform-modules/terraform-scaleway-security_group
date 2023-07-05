# Scaleway Load Balancer Terraform module

Terraform module that can be used to deploy Load Balancer resources on Scaleway. Common deployment examples can be found in [examples/](../../examples).

This is a basic example showing how to use the module.

## Usage

The example below provision a basic Load Balancer.

``` hcl
module "lb" {
  source                          = "scaleway/lb-module/scaleway"
  zone                            = local.zone
  name                            = local.name
  tags                            = local.tags
  create_acls                     = true
  create_routes                   = true
  load_balancer_action_rules      = local.load_balancer_action_rules
  load_balancer_route_host_header = local.load_balancer_route_host_header
}
```
