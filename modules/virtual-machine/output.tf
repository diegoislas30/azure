output "vm_id" {
  description = "ID de la VM"
  value       = azurerm_windows_virtual_machine.this.id
}

output "nic_id" {
  description = "ID de la NIC"
  value       = azurerm_network_interface.this.id
}

output "private_ip" {
  description = "IP privada de la VM"
  value       = azurerm_network_interface.this.private_ip_address
}
