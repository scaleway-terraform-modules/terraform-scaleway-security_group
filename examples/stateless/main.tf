provider "scaleway" {}

module "security_group" {
  source = "../.."

  name        = "example-stateless"
  description = "Stateless web server: HTTP and HTTPS from anywhere, and their replies"
  stateful    = false

  inbound_rules = [
    {
      action    = "accept"
      protocol  = "TCP"
      port      = 80
      ip_ranges = ["0.0.0.0/0", "::/0"]
    },
    {
      action    = "accept"
      protocol  = "TCP"
      port      = 443
      ip_ranges = ["0.0.0.0/0", "::/0"]
    },
  ]

  # A stateless security group doesn't allow the replies of accepted connections by itself. Rules match the destination
  # port, so the replies are allowed by their destination: the ephemeral ports of the clients.
  outbound_rules = [
    {
      action     = "accept"
      protocol   = "TCP"
      port_range = "1024-65535"
      ip_ranges  = ["0.0.0.0/0", "::/0"]
    },
  ]
}
