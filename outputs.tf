output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group_xpe_rg_001.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group.resource_group_xpe_rg_001.location
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.resource_group_xpe_rg_001.id
}

output "resource_group_tags" {
  description = "The tags of the resource group"
  value       = azurerm_resource_group.resource_group_xpe_rg_001.tags
}

