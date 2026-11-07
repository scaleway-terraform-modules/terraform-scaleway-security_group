# Stateless security group

This example shows a stateless security group (`stateful = false`) for web servers, with the rules needed for the replies.

A stateful security group (the default) remembers the accepted connections, and allows their replies without rules of their own. A stateless one evaluates every packet on its own: the replies must be accepted by rules too.

Rules match the destination port of the traffic, in both directions. So:

- inbound, HTTP (80) and HTTPS (443) are accepted from everyone, over IPv4 and IPv6;
- outbound, TCP traffic to ports 1024 to 65535 is accepted: the replies of the web server go to these ephemeral ports of the clients;
- everything else is dropped by the default policies.

With these rules, instances can only answer to connections: they can't open connections of their own, e.g. to package mirrors, NTP or DNS servers. Add outbound rules for them (and the inbound rules for their replies), or use a stateful security group, as in the [web-server](../web-server) example.

## Usage

Configure the [scaleway provider](https://www.terraform.io/docs/providers/scaleway/index.html) with your own credentials, then:

```sh
terraform init
terraform apply
```
