output "vnet_id" {
  description = "ID de la Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Nombre de la Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Mapa de IDs de las Subnets"
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}
