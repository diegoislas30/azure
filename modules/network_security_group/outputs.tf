output "id" {
  description = "ID del Network Security Group."
  value       = azurerm_network_security_group.this.id
}

output "name" {
  description = "Nombre del Network Security Group."
  value       = azurerm_network_security_group.this.name
}

output "rules" {
  description = "Reglas de seguridad del NSG"
  value       = { for r in azurerm_network_security_rule.this : r.name => r.id }
}

