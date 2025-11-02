output "terraform_rg_name" {
  description = "Nombre del Resource Group"
  value       = module.resource_group.resource_group_name
}

output "terraform_rg_id" {
  description = "ID del Resource Group"
  value       = module.resource_group.resource_group_id
}

output "terraform_rg_location" {
  description = "Location del Resource Group"
  value       = module.resource_group.resource_group_location
}