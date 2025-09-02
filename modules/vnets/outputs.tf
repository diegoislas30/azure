#############################################
# OUTPUTS DEL MÓDULO VNET
#############################################

# ID de la VNET
output "vnet_id" {
  description = "ID de la VNET creada."
  value       = azurerm_virtual_network.this.id
}

# Nombre de la VNET
output "vnet_name" {
  description = "Nombre de la VNET creada."
  value       = azurerm_virtual_network.this.name
}

# IDs de todas las subnets (mapa nombre => id)
output "subnet_ids" {
  description = "Mapa con los IDs de subnets (nombre_subnet => subnet_id)."
  value       = { for name, s in azurerm_subnet.this : name => s.id }
}

# Prefijos de todas las subnets (mapa nombre => lista de prefixes)
output "subnet_prefixes" {
  description = "Mapa con los prefijos de subnets (nombre_subnet => [prefix])."
  value       = { for name, s in azurerm_subnet.this : name => s.address_prefixes }
}

# IDs de peerings (si los hay)
output "peering_ids" {
  description = "Mapa con los IDs de peerings (nombre_peering => peering_id)."
  value       = { for name, p in azurerm_virtual_network_peering.this : name => p.id }
}
