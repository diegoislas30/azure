output "vnet_id" {
  description = "ID de la Virtual Network."
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "Mapa de IDs de subnets."
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}

output "subnet_names" {
  description = "Mapa de nombres de subnets."
  value       = { for k, s in azurerm_subnet.this : k => s.name }
}
