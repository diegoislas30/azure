output "resource_group_xpeterraformpoc_name" {
  value       = module.resource_group_xpeterraformpoc.resource_group_name
  description = "Nombre del resource group principal"
}

output "resource_group_xpeterraformpoc_location" {
  value       = module.resource_group_xpeterraformpoc.resource_group_location
  description = "Ubicación del resource group principal"
}

output "vnet_simple_id" {
  value       = module.vnet_simple.vnet_id
  description = "ID de la VNet simple"
}

output "vnet_simple_subnet_ids" {
  value       = module.vnet_simple.subnet_ids
  description = "IDs de las subnets en la VNet simple"
}
