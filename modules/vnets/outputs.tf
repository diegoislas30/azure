output "virtual_network_id" {
  description = "The ID of the Virtual Network."
  value       = azurerm_virtual_network.this.id

}

output "resource_group_name " {
  description = "The name of the resource group in which the Virtual Network is created."
  value       = var.resource_group_name
}

output "location" {
  description = "The location where the Virtual Network is created."
  value       = var.location
}

output "tags" {

  description = "The tags assigned to the Virtual Network."
  value       = var.tags
}

output "dns_servers" {
  description = "The DNS servers IP addresses assigned to the Virtual Network."
  value       = var.dns_servers
}

output "subnet_ids" {
  description = "A map of subnet names to their IDs."
  value       = { for k, v in azurerm_subnet.this : k => v.id }
}

output "route_table_ids" {
  description = "A map of route table names to their IDs."
  value       = { for k, v in azurerm_route_table.this : k => v.id }
}

output "vnet_peering_ids" {
  description = "A map of virtual network peering names to their IDs."
  value       = { for k, v in azurerm_virtual_network_peering.this : k => v.id }
}



