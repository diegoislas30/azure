# ================== SQL Server ==================
output "sql_server_id" {
  description = "ID del SQL Server."
  value       = azurerm_mssql_server.this.id
}

output "sql_server_name" {
  description = "Nombre del SQL Server."
  value       = azurerm_mssql_server.this.name
}

output "sql_server_fqdn" {
  description = "FQDN del SQL Server."
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "sql_server_identity" {
  description = "Identity del SQL Server (si está habilitada)."
  value       = var.enable_system_identity ? azurerm_mssql_server.this.identity : null
}

# ================== Databases ==================
output "database_ids" {
  description = "Map de IDs de las bases de datos."
  value       = { for k, v in azurerm_mssql_database.this : k => v.id }
}

output "database_names" {
  description = "Lista de nombres de las bases de datos."
  value       = [for db in azurerm_mssql_database.this : db.name]
}

# ================== Private Endpoint ==================
output "private_endpoint_id" {
  description = "ID del Private Endpoint (si está habilitado)."
  value       = var.private_endpoint_enabled ? azurerm_private_endpoint.this[0].id : null
}

output "private_endpoint_ip" {
  description = "IP privada del Private Endpoint (si está habilitado)."
  value       = var.private_endpoint_enabled ? azurerm_private_endpoint.this[0].private_service_connection[0].private_ip_address : null
}

# ================== Connection String ==================
output "connection_string" {
  description = "Connection string para las aplicaciones (sin contraseña)."
  value       = "Server=tcp:${azurerm_mssql_server.this.fully_qualified_domain_name},1433;Initial Catalog=<database_name>;Persist Security Info=False;User ID=${var.administrator_login};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = false
}
