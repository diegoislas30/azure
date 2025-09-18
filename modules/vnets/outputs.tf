output "subnet_ids" {
  description = "IDs de los subnets creados"
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}

output "vnet_id" {
  description = "ID de la VNet"
  value       = azurerm_virtual_network.this.id
}
