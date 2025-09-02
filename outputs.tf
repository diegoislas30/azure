# root/outputs.tf
output "resource_group_xpe_rg_001_name" {
  description = "Resource group name"
  value       = module.resource_group_1.resource_group_name
}

output "resource_group_xpe_rg_001_id" {
  description = "Resource group id"
  value       = module.resource_group_1.id     # <-- antes ponías resource_group_id (no existe)
}

output "resource_group_xpe_rg_001_location" {
  description = "Resource group location"
  value       = module.resource_group_1.resource_group_location
}


