output "cmk_key_id" {
  description = "ID versionado de la CMK usada para TDE."
  value       = try(azurerm_key_vault_key.cmk[0].id, var.key_vault_key_version_id)
}

output "mssql_instance_key_id" {
  description = "ID del recurso azurerm_mssql_managed_instance_key."
  value       = azurerm_mssql_managed_instance_key.tde_cmk.id
}

output "private_endpoints_ids" {
  description = "IDs de Private Endpoints creados por nombre lógico."
  value       = { for k, v in azurerm_private_endpoint.pe : k => v.id }
}

output "created_private_dns_zone_ids" {
  description = "IDs de Private DNS Zones creadas por este módulo."
  value       = { for k, v in azurerm_private_dns_zone.this : k => v.id }
}
