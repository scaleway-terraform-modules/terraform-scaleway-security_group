output "security_group_id" {
  description = "ID of the security group, to attach to the web server instances."
  value       = module.security_group.security_group_id
}
