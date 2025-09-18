variable "nsg_name" {
  description = "Nombre del NSG"
  type        = string
}

variable "location" {
  description = "Ubicación de Azure"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group donde se crea el NSG"
  type        = string
}

variable "security_rules" {
  description = "Lista de reglas de seguridad"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "tags" {
  description = "Etiquetas para el recurso"
  type        = map(string)
  default     = {}
}
