output "resource_group_name" {
  value       = module.resource_group.resource_group_name
  description = "Resource group name"
}

output "resource_group_location" {
  value       = module.resource_group.resource_group_location
  description = "Resource group location"
}

output "id" {
  value       = module.resource_group.id
  description = "Resource group ID"
}

