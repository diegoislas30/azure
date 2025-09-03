output "vnet_id" {
  description = "ID de la VNET"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Nombre de la VNET"
  value       = azurerm_virtual_network.this.name
}

output "vnet_address_space" {
  description = "Address space de la VNET"
  value       = azurerm_virtual_network.this.address_space
}

output "subnet_ids" {
  description = "Mapa nombre_subnet => subnet_id"
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}

output "subnet_names" {
  description = "Mapa nombre_subnet => nombre"
  value       = { for k, s in azurerm_subnet.this : k => s.name }
}

output "subnet_prefixes" {
  description = "Mapa nombre_subnet => lista de CIDRs"
  value       = { for k, s in azurerm_subnet.this : k => s.address_prefixes }
}

# NUEVOS
output "peering_ids" {
  description = "IDs de los peerings creados (clave = nombre del peering)"
  value       = { for k, p in azurerm_virtual_network_peering.this : k => p.id }
}
