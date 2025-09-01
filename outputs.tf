output "resource_group_1" {
  value = module.resource_group_1.resource_group_name
  description = "Resource group name"
}

output "resource_group_1_id" {
  value = module.resource_group_1.resource_group_id
  description = "Resource group id"
}

output "resource_group_1_location" {
  value = module.resource_group_1.resource_group_location
  description = "Resource group location"
}