provider "scaleway" {}

locals {
  # Replace with the IP ranges allowed to connect with SSH, e.g. your office's.
  admin_ip_ranges = ["192.0.2.0/24", "2001:db8::/32"]
}

module "security_group" {
  source = "../.."

  name        = "example-web-server"
  description = "Web server: HTTP and HTTPS from anywhere, SSH from the admin IP ranges"

  # Instances can reach any destination, e.g. package mirrors, NTP or DNS servers.
  outbound_default_policy = "accept"

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
    {
      action    = "accept"
      protocol  = "TCP"
      port      = 22
      ip_ranges = local.admin_ip_ranges
    },
  ]
}
