# Terraform / Scaleway

## Purpose

This repository is used to create a security group on scaleway using terraform.

## Usage

- Setup the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) in your tf file.
- Include this module in your tf file. Refer to [documentation](https://www.terraform.io/docs/modules/sources.html#generic-git-repository).

```hcl
module "my_sg" {
  source  = "app.terraform.io/terra-art/sc_sh/scaleway"
  version = "1.0.0"
}
```

<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 0.13 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement_scaleway) | >= 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_scaleway"></a> [scaleway](#provider_scaleway) | >= 2 |

## Resources

| Name | Type |
|------|------|
| [scaleway_instance_security_group.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_security_group) | resource |
| [scaleway_instance_security_group_rules.inboud](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_security_group_rules) | resource |
| [scaleway_instance_security_group_rules.outband](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_security_group_rules) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enable_default_security"></a> [enable_default_security](#input_enable_default_security) | n/a | `bool` | `true` | no |
| <a name="input_inbound_default_policy"></a> [inbound_default_policy](#input_inbound_default_policy) | n/a | `string` | `"drop"` | no |
| <a name="input_inbound_rules"></a> [inbound_rules](#input_inbound_rules) | n/a | ```list(object({ action = string protocol = string port = optional(number) ip_range = optional(string) }))``` | ```[ { "action": null, "ip_range": null, "port": null, "protocol": null } ]``` | no |
| <a name="input_name"></a> [name](#input_name) | n/a | `string` | `"git-servers"` | no |
| <a name="input_outbound_default_policy"></a> [outbound_default_policy](#input_outbound_default_policy) | n/a | `string` | `"drop"` | no |
| <a name="input_outbound_rules"></a> [outbound_rules](#input_outbound_rules) | n/a | ```list(object({ action = string protocol = string port = optional(number) ip_range = optional(string) }))``` | ```[ { "action": null, "ip_range": null, "port": null, "protocol": null } ]``` | no |
| <a name="input_stateful"></a> [stateful](#input_stateful) | n/a | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Tags associated with the security group and its rules. | `list(any)` | `[]` | no |
<!-- END_TF_DOCS -->

## Known issues

- none for now.
