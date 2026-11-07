# Simple security group

This example shows the minimal setup: a security group with the module's default policies and no rule.

Both default policies are `drop`: instances using this security group accept no incoming traffic, and can't reach anything either, including package mirrors, NTP or DNS servers. See the [web-server](../web-server) example for a security group with rules.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```
