output "vnet_main_id" {
  value       = module.vnet_main.vnet_id
  description = "ID de la VNet principal"
}

output "vnet_main_subnet_ids" {
  value       = module.vnet_main.subnet_ids
  description = "Subnets de la VNet principal"
}

output "vnet_spoke_id" {
  value       = module.vnet_spoke.vnet_id
  description = "ID de la VNet spoke"
}

output "vnet_spoke_subnet_ids" {
  value       = module.vnet_spoke.subnet_ids
  description = "Subnets de la VNet spoke"
}
