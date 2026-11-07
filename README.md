# Terraform / Scaleway

## Purpose

This repository is used to manage a security group and its rules on scaleway using terraform. The module can create the security group, or attach its rules to an existing one.

> [!IMPORTANT]
> Both default policies are `drop`, unlike the provider's defaults (`accept`). Without rules, instances using the security group accept no incoming traffic and can't reach anything either, including package mirrors, NTP or DNS servers. Add the rules they need, or set `outbound_default_policy = "accept"`.

- ### Rules

`inbound_rules` and `outbound_rules` are lists of rules, evaluated in order. Each rule sets:

- `action`: `accept` or `drop`;
- `protocol`: `TCP`, `UDP`, `ICMP` or `ANY`;
- `port` (e.g. `443`) or `port_range` (e.g. `8000-8080`), only with `TCP` or `UDP`. They are destination ports, in both directions. A rule without `port` nor `port_range` applies to all ports;
- `ip_ranges`: the IP ranges the rule applies to. It defaults to `["0.0.0.0/0"]`, i.e. all IPv4 addresses: IPv6 addresses must be listed explicitly, e.g. `["0.0.0.0/0", "::/0"]`. Use a `/32` range (or `/128` in IPv6) for a single address.

The module creates one provider rule per range, keeping the order of the rules and of their ranges. `ip` and `ip_range` are not supported: use `ip_ranges` instead.

- ### Stateful and stateless security groups

By default (`stateful = true`), the security group remembers the accepted connections, and allows their replies without rules of their own. With `stateful = false`, every packet is evaluated on its own, so the replies must be accepted by rules too, e.g. an outbound rule on the ephemeral ports of the clients for a web server. See the [stateless](examples/stateless) example.

- ### Using an existing security group

Set `create_security_group = false`, and `security_group_id` to the ID of an existing security group, as `{zone}/{id}`, to attach the rules to it. Note that:

- the module manages **all** the rules of the security group: rules created outside of the module are deleted on the next apply, and empty `inbound_rules` / `outbound_rules` remove all the rules;
- if the existing security group is managed by Terraform, it must set `external_rules = true` and have no inline `inbound_rule` / `outbound_rule` block, otherwise both configurations fight over the rules;
- the module doesn't manage the settings of the existing security group (name, description, default policies, ...). Setting `description`, `project_id` or `zone` displays a warning, as they are ignored.

See the [existing-security-group](examples/existing-security-group) example.

- ### SMTP

By default (`enable_default_security = true`), outgoing SMTP traffic (ports 25, 465 and 587) is blocked on IPv4 and IPv6. Set `enable_default_security = false` to unblock it if your organization is authorized to send SMTP traffic; otherwise, [open a support ticket](https://console.scaleway.com/support/tickets) to request it.

## Usage

- Setup the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) in your tf file.
- Include this module in your tf file. Refer to [documentation](https://www.terraform.io/docs/modules/sources.html#generic-git-repository).

```hcl
module "security_group" {
  source  = "scaleway-terraform-modules/security_group/scaleway"
  version = "~> 1.0"

  name = "web-servers"

  inbound_rules = [{
    action    = "accept"
    protocol  = "TCP"
    port      = 443
    ip_ranges = ["0.0.0.0/0", "::/0"]
  }]
}
```

Attach the security group to instances with its ID, e.g. `security_group_id = module.security_group.security_group_id` in a `scaleway_instance_server` resource.

See the [examples](examples) folder for runnable configurations covering the most common use-cases (simple security group, web server, existing security group, stateless security group).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.11 |
| <a name="requirement_scaleway"></a> [scaleway](#requirement_scaleway) | >= 2.79.0 |

## Resources

| Name | Type |
|------|------|
| [scaleway_instance_security_group.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_security_group) | resource |
| [scaleway_instance_security_group_rules.this](https://registry.terraform.io/providers/scaleway/scaleway/latest/docs/resources/instance_security_group_rules) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_security_group"></a> [create_security_group](#input_create_security_group) | Whether to create a new security group. Set to false to attach the rules to an existing security group, given in `security_group_id`. | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input_description) | Description of the security group. Only used when `create_security_group` is true: a warning is displayed when it is set otherwise. | `string` | `null` | no |
| <a name="input_enable_default_security"></a> [enable_default_security](#input_enable_default_security) | Whether to block outgoing SMTP traffic (ports 25, 465 and 587) on IPv4 and IPv6. Set to false to unblock it if your organization is authorized to send SMTP traffic; otherwise, open a support ticket to request it. | `bool` | `true` | no |
| <a name="input_inbound_default_policy"></a> [inbound_default_policy](#input_inbound_default_policy) | Default policy applied to incoming traffic matching no rule: `accept` or `drop`. | `string` | `"drop"` | no |
| <a name="input_inbound_rules"></a> [inbound_rules](#input_inbound_rules) | List of inbound rules to add to the security group. When empty (default), only `inbound_default_policy` applies to incoming traffic. Each rule applies to every range of `ip_ranges` (default `["0.0.0.0/0"]`, i.e. all IPv4 addresses), e.g. `["0.0.0.0/0", "::/0"]` for all IPv4 and IPv6 addresses, or `["192.0.2.10/32"]` for a single address. A rule without `port` nor `port_range` applies to all ports. `ip` and `ip_range` are not supported: use `ip_ranges` instead. | ```list(object({ action = string protocol = string port = optional(number) port_range = optional(string) ip_ranges = optional(list(string), ["0.0.0.0/0"]) # Kept only to reject them: undeclared attributes would be silently dropped, leaving the rule open to 0.0.0.0/0. ip = optional(string) ip_range = optional(string) }))``` | `[]` | no |
| <a name="input_name"></a> [name](#input_name) | Name of the security group. The provider generates a random name when null. Only used when `create_security_group` is true. | `string` | `null` | no |
| <a name="input_outbound_default_policy"></a> [outbound_default_policy](#input_outbound_default_policy) | Default policy applied to outgoing traffic matching no rule: `accept` or `drop`. | `string` | `"drop"` | no |
| <a name="input_outbound_rules"></a> [outbound_rules](#input_outbound_rules) | List of outbound rules to add to the security group. When empty (default), only `outbound_default_policy` applies to outgoing traffic. Each rule applies to every range of `ip_ranges` (default `["0.0.0.0/0"]`, i.e. all IPv4 addresses), e.g. `["0.0.0.0/0", "::/0"]` for all IPv4 and IPv6 addresses, or `["192.0.2.10/32"]` for a single address. A rule without `port` nor `port_range` applies to all ports. `ip` and `ip_range` are not supported: use `ip_ranges` instead. | ```list(object({ action = string protocol = string port = optional(number) port_range = optional(string) ip_ranges = optional(list(string), ["0.0.0.0/0"]) # Kept only to reject them: undeclared attributes would be silently dropped, leaving the rule open to 0.0.0.0/0. ip = optional(string) ip_range = optional(string) }))``` | `[]` | no |
| <a name="input_project_id"></a> [project_id](#input_project_id) | ID of the project the security group is associated with. Resource will be created in the project set at the provider level if null. Only used when `create_security_group` is true: a warning is displayed when it is set otherwise. | `string` | `null` | no |
| <a name="input_security_group_id"></a> [security_group_id](#input_security_group_id) | ID of an existing security group to attach the rules to, as `{zone}/{id}`, e.g. `fr-par-1/11111111-1111-1111-1111-111111111111`. Required when `create_security_group` is false. Ignored otherwise: a warning is displayed when it is set. | `string` | `null` | no |
| <a name="input_stateful"></a> [stateful](#input_stateful) | Whether the security group is stateful, i.e. automatically allows the return traffic of allowed connections. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Tags associated with the security group. Duplicate tags are only applied once. | `list(string)` | `[]` | no |
| <a name="input_zone"></a> [zone](#input_zone) | Zone in which the security group should be created, e.g. `fr-par-1`. Resource will be created in the zone set at the provider level if null. Only used when `create_security_group` is true: a warning is displayed when it is set otherwise, as the zone of an existing security group is part of `security_group_id`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_description"></a> [security_group_description](#output_security_group_description) | Description of the security group. Null when `create_security_group` is false. |
| <a name="output_security_group_id"></a> [security_group_id](#output_security_group_id) | ID of the security group the rules are attached to: the one created by the module, or `security_group_id`. |
| <a name="output_security_group_name"></a> [security_group_name](#output_security_group_name) | Name of the security group. Null when `create_security_group` is false. |
| <a name="output_security_group_organization_id"></a> [security_group_organization_id](#output_security_group_organization_id) | ID of the organization the security group is associated with. Null when `create_security_group` is false. |
| <a name="output_security_group_project_id"></a> [security_group_project_id](#output_security_group_project_id) | ID of the project the security group is associated with. Null when `create_security_group` is false. |
| <a name="output_security_group_zone"></a> [security_group_zone](#output_security_group_zone) | Zone of the security group the rules are attached to. When `create_security_group` is false, taken from `security_group_id`. |
<!-- END_TF_DOCS -->

## Authors

Module is maintained with help from [the community](https://github.com/scaleway-terraform-modules/terraform-scaleway-security_group/graphs/contributors).

## License

Mozilla Public License 2.0 Licensed. See [LICENSE](https://github.com/scaleway-terraform-modules/terraform-scaleway-security_group/tree/main/LICENSE) for full details.
