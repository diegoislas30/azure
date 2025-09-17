output "vnet_id" {
  description = "El ID de la Virtual Network creada."
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "Un mapa con los IDs de las subnets creadas, usando su nombre como clave."
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}