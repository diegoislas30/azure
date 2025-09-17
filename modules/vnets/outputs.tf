# === VNet ===
output "vnet_id" {
  description = "ID de la VNet creada."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Nombre de la VNet creada."
  value       = azurerm_virtual_network.this.name
}

# === Subnets ===
output "subnet_ids" {
  description = "IDs de todas las subnets creadas."
  value       = { for k, s in azurerm_subnet.this : k => s.id }
}

output "subnet_names" {
  description = "Nombres de todas las subnets creadas."
  value       = keys(azurerm_subnet.this)
}

# === Asociaciones NSG → Subnet ===
output "nsg_associations" {
  description = "Asociaciones de NSG por subnet (si existen)."
  value       = { for k, a in azurerm_subnet_network_security_group_association.this : k => a.network_security_group_id }
}

# === Asociaciones Route Table → Subnet ===
output "route_table_associations" {
  description = "Asociaciones de Route Table por subnet (si existen)."
  value       = { for k, a in azurerm_subnet_route_table_association.this : k => a.route_table_id }
}

# === Peerings ===
output "vnet_peerings" {
  description = "Peerings creados desde esta VNet."
  value       = { for k, p in azurerm_virtual_network_peering.this : k => p.id }
}
