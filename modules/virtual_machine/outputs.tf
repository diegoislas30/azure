output "vm_id" {
  description = "ID de la máquina virtual."
  value       = try(azurerm_linux_virtual_machine.this[0].id, azurerm_windows_virtual_machine.this[0].id)
}

output "vm_name" {
  description = "Nombre de la máquina virtual."
  value       = var.vm_name
}

output "network_interface_id" {
  description = "ID de la NIC principal."
  value       = azurerm_network_interface.this.id
}

output "private_ip_address" {
  description = "IP privada asignada."
  value       = try(azurerm_network_interface.this.ip_configuration[0].private_ip_address, null)
}

output "public_ip_id" {
  description = "ID de la IP pública (si se creó)."
  value       = try(azurerm_public_ip.this[0].id, null)
}

output "public_ip_address" {
  description = "Dirección IP pública (si existe)."
  value       = try(azurerm_public_ip.this[0].ip_address, null)
}
