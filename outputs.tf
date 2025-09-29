output "xp_rg_name" {
  description = "Nombre del Resource Group"
  value       = module.resource_group_xpeterraformpoc.resource_group_name
}

output "xp_rg_id" {
  description = "ID del Resource Group"
  value       = module.resource_group_xpeterraformpoc.resource_group_id
}

output "xp_rg_location" {
  description = "Location del Resource Group"
  value       = module.resource_group_xpeterraformpoc.resource_group_location
}


output "vnet_simple_id" {
  description = "ID de la VNet simple"
  value       = module.vnet_simple.vnet_id
}

output "vnet_simple_name" {
  description = "Nombre de la VNet simple"
  value       = module.vnet_simple.vnet_name
}
