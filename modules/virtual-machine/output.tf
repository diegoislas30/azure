output "vm_id" {
  description = "ID de la VM Linux creada"
  value       = azurerm_linux_virtual_machine.this.id
}

output "private_ip" {
  description = "Dirección IP privada de la VM"
  value       = azurerm_network_interface.this.ip_configuration[0].private_ip_address
}
