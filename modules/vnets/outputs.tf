output "vnet_id" {
  description = "ID de la Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "IDs de las subnets creadas"
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}
