# Web server

This example shows a security group for web servers:

- HTTP (80) and HTTPS (443) are open to everyone, over IPv4 and IPv6 (`ip_ranges = ["0.0.0.0/0", "::/0"]`);
- SSH (22) is only open to the admin IP ranges set in `local.admin_ip_ranges`;
- other incoming traffic is dropped by the default inbound policy;
- outgoing traffic is accepted (`outbound_default_policy = "accept"`), so that instances can reach package mirrors, NTP or DNS servers.

The security group is stateful (the default): the replies to the accepted connections are allowed without rules of their own.

Replace `local.admin_ip_ranges` in `main.tf` with your own IP ranges: the default ones are reserved for documentation ([RFC 5737](https://www.rfc-editor.org/rfc/rfc5737.html) and [RFC 3849](https://www.rfc-editor.org/rfc/rfc3849.html)).

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```
