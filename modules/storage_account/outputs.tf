output "storage_account_id" {
  description = "ID del Storage Account."
  value       = try(module.sa_v2[0].storage_account_id, module.sa_nonv2[0].storage_account_id)
}

output "storage_account_name" {
  description = "Nombre del Storage Account."
  value       = try(module.sa_v2[0].storage_account_name, module.sa_nonv2[0].storage_account_name)
}

output "primary_blob_endpoint" {
  description = "Endpoint primario de blob (si aplica)."
  value       = try(module.sa_v2[0].storage_account_primary_blob_endpoint, module.sa_nonv2[0].storage_account_primary_blob_endpoint, null)
}
