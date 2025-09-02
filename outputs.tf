# root/outputs.tf
output "resource_group_xpe_rg_001_name" {
  description = "Resource group name"
  value       = module.resource_group_xpe-rg-001.resource_group_name
}

output "resource_group_xpe_rg_001_id" {
  description = "Resource group ID"
  value       = module.resource_group_xpe-rg-001.resource_group_id
}

output "resource_group_xpe_rg_001_location" {
  description = "Resource group location"
  value       = module.resource_group_xpe-rg-001.resource_group_location
  
  
}
