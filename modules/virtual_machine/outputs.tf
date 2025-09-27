output "vm_id" {
  description = "ID de la VM creada."
  value       = try(azurerm_linux_virtual_machine.this[0].id, azurerm_windows_virtual_machine.this[0].id)
}

output "vm_name" {
  description = "Nombre de la VM."
  value       = var.vm_name
}

output "nic_id" {
  description = "ID de la NIC principal."
  value       = azurerm_network_interface.this.id
}

output "private_ip" {
  description = "IP privada asignada a la NIC."
  value       = azurerm_network_interface.this.ip_configuration[0].private_ip_address
}
