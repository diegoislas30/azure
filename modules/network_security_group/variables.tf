variable "nsg_name" {
  description = "Nombre del Network Security Group."
  type        = string
}

variable "location" {
  description = "Región de Azure donde se creará el NSG."
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group donde se creará el NSG."
  type        = string
}

variable "security_rules" {
  description = "Lista de reglas de seguridad para el NSG."
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string   # Inbound / Outbound
    access                     = string   # Allow / Deny
    protocol                   = string   # Tcp / Udp / * 
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "tags" {
  description = "Etiquetas aplicadas al recurso."
  type        = map(string)
  default     = {}
}
