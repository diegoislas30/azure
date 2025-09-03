output "vnet_name" {
  description = "The name of the Virtual Network."
  value       = azurerm_virtual_network.this.name
}

output "resource_group_name" {
  description = "The name of the resource group in which the Virtual Network is created."
  value       = azurerm_virtual_network.this.resource_group_name
}

output "resource_group_location" {
  description = "The location of the resource group in which the Virtual Network is created."
  value       = azurerm_virtual_network.this.location
}

output "vnet_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "A mapping of subnet names to their IDs."
  value       = { for s in azurerm_subnet.this : s.name => s.id }
}

output "route_table_ids" {
  description = "A mapping of route table names to their IDs."
  value       = { for rt in azurerm_route_table.this : rt.name => rt.id }
}

output "vnet_peering_ids" {
  description = "A mapping of virtual network peering names to their IDs."
  value       = { for p in azurerm_virtual_network_peering.this : p.name => p.id }
}

output "tags" {
  description = "A mapping of tags assigned to the Virtual Network."
  value       = azurerm_virtual_network.this.tags
}

output "dns_servers" {
  description = "A list of DNS servers IP addresses assigned to the Virtual Network."
  value       = azurerm_virtual_network.this.dns_servers
}

