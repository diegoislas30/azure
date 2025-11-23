# ================== Key Vault Outputs ==================
output "key_vault_id" {
  description = "ID del Key Vault"
  value       = azurerm_key_vault.this.id
}

output "key_vault_name" {
  description = "Nombre del Key Vault"
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "URI del Key Vault"
  value       = azurerm_key_vault.this.vault_uri
}

output "key_vault_tenant_id" {
  description = "Tenant ID del Key Vault"
  value       = azurerm_key_vault.this.tenant_id
}

# ================== Private Endpoint Outputs ==================
output "private_endpoint_id" {
  description = "ID del Private Endpoint (null si no está habilitado)"
  value       = var.private_endpoint_enabled ? azurerm_private_endpoint.this[0].id : null
}

output "private_endpoint_name" {
  description = "Nombre del Private Endpoint (null si no está habilitado)"
  value       = var.private_endpoint_enabled ? azurerm_private_endpoint.this[0].name : null
}

output "private_endpoint_private_ip" {
  description = "IP privada del Private Endpoint (null si no está habilitado)"
  value       = var.private_endpoint_enabled ? azurerm_private_endpoint.this[0].private_service_connection[0].private_ip_address : null
}

output "private_endpoint_network_interface_id" {
  description = "ID de la interfaz de red del Private Endpoint (null si no está habilitado)"
  value       = var.private_endpoint_enabled ? azurerm_private_endpoint.this[0].network_interface[0].id : null
}
