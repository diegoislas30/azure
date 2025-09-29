output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group_terraform.name
}

output "resource_group_location" {
  description = "The location of the resource group"
  value       = azurerm_resource_group_terraform.location
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group_terraform.id
}
