## genera los output s de la infraestructura creada

output "resource_group_name" {
  description = "The name of the Resource Group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "The ID of the Resource Group"
  value       = azurerm_resource_group.main.id
}

output "resource_group_location" {
  description = "The location of the Resource Group"
  value       = azurerm_resource_group.main.location
}


output "resource_group_tags" {
  description = "The tags assigned to the Resource Group"
  value       = azurerm_resource_group.main.tags
}

