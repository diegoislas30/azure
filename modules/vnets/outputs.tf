output "vnet_id" {
  description = "ID de la Virtual Network."
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "Mapa de IDs de las subnets."
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "subnet_names" {
  description = "Mapa de nombres de las subnets."
  value       = { for k, v in azurerm_subnet.this : k => v.name }
}
