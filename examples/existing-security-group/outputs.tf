output "security_group_id" {
  description = "ID of the existing security group, as returned by the module."
  value       = module.security_group_rules.security_group_id
}

output "security_group_zone" {
  description = "Zone of the existing security group, taken from its ID by the module."
  value       = module.security_group_rules.security_group_zone
}
