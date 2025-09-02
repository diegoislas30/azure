output "vnet_id" {
  description = "ID de la VNET"
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "Mapa nombre_subnet => subnet_id"
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}

output "subnet_prefixes" {
  description = "Mapa nombre_subnet => prefixes"
  value       = { for k, s in azurerm_subnet.this : k => s.address_prefixes }
}
