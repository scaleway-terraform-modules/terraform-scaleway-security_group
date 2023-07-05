output "group_id" {
  description = "ID of the security group."
  value       = try(scaleway_instance_security_group.this[0].id, "")
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = try(scaleway_instance_security_group.this[0].id, "")
}

output "security_group_name" {
  description = "The name of the security group"
  value       = try(scaleway_instance_security_group.this[0].name, "")
}

output "security_group_description" {
  description = "The description of the security group"
  value       = try(scaleway_instance_security_group.this[0].description, "")
}
