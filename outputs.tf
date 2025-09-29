output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.resource_group_xpeterraformpoc.resource_group_name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = module.resource_group_xpeterraformpoc.resource_group_location
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = module.resource_group_xpeterraformpoc.resource_group_id
}


output "network_security_group_id" {
  description = "The ID of the Network Security Group"
  value       = module.network_security_group.nsg_id
}

