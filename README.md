# Terraform / Scaleway

## Purpose

This repository is used to create a security group on scaleway using terraform.

## Usage

- Setup the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) in your tf file.
- Include this module in your tf file. Refer to [documentation](https://www.terraform.io/docs/modules/sources.html#generic-git-repository).

```hcl
module "my_sg" {
  source  = "app.terraform.io/terra-art/sc_sg/scaleway"
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
| <a name="input_description"></a> [description](#input_description) | Description of the security group. | `string` | `null` | no |
| <a name="input_enable_default_security"></a> [enable_default_security](#input_enable_default_security) | Whether to block SMTP on IPv4/IPv6 (Port 25, 465, 587). Set to false will unblock SMTP if your account is authorized to. If your organization is not yet authorized to send SMTP traffic, open a support ticket. | `bool` | `true` | no |
| <a name="input_inbound_default_policy"></a> [inbound_default_policy](#input_inbound_default_policy) | Default policy on incoming traffic. Possible values are: accept or drop. | `string` | `"drop"` | no |
| <a name="input_inbound_rules"></a> [inbound_rules](#input_inbound_rules) | List of inbound rule to add to the security group. | ```list(object({ action = string protocol = string port = optional(number) port_range = optional(string) ip = string ip_range = optional(string) }))``` | ```[ { "action": null, "ip": null, "ip_range": null, "port": null, "port_range": null, "protocol": null } ]``` | no |
| <a name="input_name"></a> [name](#input_name) | Name of the security group. | `string` | `null` | no |
| <a name="input_outbound_default_policy"></a> [outbound_default_policy](#input_outbound_default_policy) | Default policy on outgoing traffic. Possible values are: accept or drop. | `string` | `"drop"` | no |
| <a name="input_outbound_rules"></a> [outbound_rules](#input_outbound_rules) | List of outbound rule to add to the security group. | ```list(object({ action = string protocol = string port = optional(number) ip_range = optional(string) }))``` | ```[ { "action": null, "ip_range": null, "port": null, "protocol": null } ]``` | no |
| <a name="input_stateful"></a> [stateful](#input_stateful) | Boolean to specify whether the security group should be stateful or not. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Tags associated with the security group and its rules. | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_group_id"></a> [group_id](#output_group_id) | ID of the security group. |
<!-- END_TF_DOCS -->

## Known issues

- none for now.
