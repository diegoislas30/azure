output "vnet_id" {
  description = "ID de la Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Nombre de la Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "subnet_id" {
  description = "ID de la Subnet"
  value       = azurerm_subnet.this.id
}

output "subnet_name" {
  description = "Nombre de la Subnet"
  value       = azurerm_subnet.this.name
}

output "nsg_association_id" {
  description = "ID de la asociación de NSG con la Subnet (si aplica)"
  value       = try(azurerm_subnet_network_security_group_association.this[0].id, null)
}

output "route_table_association_id" {
  description = "ID de la asociación de tabla de ruteo con la Subnet (si aplica)"
  value       = try(azurerm_subnet_route_table_association.this[0].id, null)
}

output "peerings" {
  description = "Mapa de peerings creados"
  value       = { for k, v in azurerm_virtual_network_peering.this : k => v.id }
}
