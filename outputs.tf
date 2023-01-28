output "group_id" {
  description = "ID of the security group."
  sensitive = false
  value = scaleway_instance_security_group.this.id
}