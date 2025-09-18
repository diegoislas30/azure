output "id" {
  value       = azurerm_network_security_group.this.id
  description = "ID del NSG"
}

output "name" {
  value       = azurerm_network_security_group.this.name
  description = "Nombre del NSG"
}
