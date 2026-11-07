provider "scaleway" {}

module "security_group" {
  source = "../.."

  name        = "example-simple"
  description = "Security group with the default policies and no rule"
}
