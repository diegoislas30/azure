output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.resource_group.resource_group_name
}

output "network_security_group_id" {
  description = "The ID of the Network Security Group"
  value       = module.network_security_group.azurerm_network_security_group.this.id
}

output "network_security_group_2_id" {
  description = "The ID of the second Network Security Group"
  value       = module.network_security_group_2.azurerm_network_security_group.this.id
}

