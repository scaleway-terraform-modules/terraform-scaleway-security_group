# Existing security group

This example shows how to attach rules to a security group that is not created by the module: `create_security_group = false`, and `security_group_id` set to the ID of the existing group, as `{zone}/{id}`.

To keep the example self-contained, the existing security group is created in `main.tf`. In practice, it is managed elsewhere, e.g. by another team or Terraform configuration, and its ID is passed to the module.

Note that:

- the module manages **all** the rules of the security group: rules created outside of the module are deleted on the next apply;
- if the existing security group is managed by Terraform, it must set `external_rules = true` and have no inline `inbound_rule` / `outbound_rule` block, otherwise both configurations fight over the rules;
- the settings of the existing group (name, description, default policies, ...) are not managed by the module: inputs such as `description`, `project_id` or `zone` display a warning when they are set.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```
