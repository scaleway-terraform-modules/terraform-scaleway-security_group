output "group_id" {
  description = "ID of the security group the rules are attached to: the one created by the module, or `security_group_id`."
  value       = local.this_sg_id
}

output "security_group_id" {
  description = "ID of the security group the rules are attached to: the one created by the module, or `security_group_id`."
  value       = local.this_sg_id
}

output "security_group_name" {
  description = "Name of the security group. Null when `create_security_group` is false."
  value       = one(scaleway_instance_security_group.this[*].name)
}

output "security_group_description" {
  description = "Description of the security group. Null when `create_security_group` is false."
  value       = one(scaleway_instance_security_group.this[*].description)
}
