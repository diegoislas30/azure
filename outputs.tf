# outputs.tf (root)

output "rg_name" {
  description = "Nombre del Resource Group"
  value       = module.rg_terraform_vm.resource_group_name
}

output "rg_id" {
  description = "ID del Resource Group"
  value       = module.rg_terraform_vm.resource_group_id
}

output "rg_location" {
  description = "Región del Resource Group"
  value       = module.rg_terraform_vm.resource_group_location
}

