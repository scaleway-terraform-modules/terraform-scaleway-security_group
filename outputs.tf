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

output "security_group_zone" {
  description = "Zone of the security group the rules are attached to. When `create_security_group` is false, taken from `security_group_id`."
  value       = var.create_security_group ? one(scaleway_instance_security_group.this[*].zone) : split("/", var.security_group_id)[0]
}

output "security_group_project_id" {
  description = "ID of the project the security group is associated with. Null when `create_security_group` is false."
  value       = one(scaleway_instance_security_group.this[*].project_id)
}

output "security_group_organization_id" {
  description = "ID of the organization the security group is associated with. Null when `create_security_group` is false."
  value       = one(scaleway_instance_security_group.this[*].organization_id)
}
