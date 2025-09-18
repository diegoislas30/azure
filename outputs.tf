output "hub_vnet_id" {
  value = module.vnet_hub.vnet_id
}

output "hub_subnet_ids" {
  value = module.vnet_hub.subnet_ids
}

output "spoke_vnet_id" {
  value = module.vnet_spoke.vnet_id
}

output "spoke_subnet_ids" {
  value = module.vnet_spoke.subnet_ids
}
