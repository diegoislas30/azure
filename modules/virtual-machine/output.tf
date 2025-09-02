output "vm_id" {
  value       = azurerm_windows_virtual_machine.this.id
  description = "ID de la VM"
}

output "nic_id" {
  value       = azurerm_network_interface.this.id
  description = "ID de la NIC"
}

output "private_ip" {
  value       = azurerm_network_interface.this.private_ip_address
  description = "IP privada de la VM"
}
