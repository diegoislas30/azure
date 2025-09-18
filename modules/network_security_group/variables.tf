variable "vnet_name" {
  description = "Nombre de la Virtual Network"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group donde se crea la VNet"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "address_space" {
  description = "Espacio de direcciones de la VNet"
  type        = list(string)
}

variable "subnets" {
  description = "Lista de subnets a crear"
  type = list(object({
    name           = string
    address_prefix = string
  }))
}

variable "tags" {
  description = "Etiquetas comunes"
  type        = map(string)
  default     = {}
}

variable "security_rules" {
  description = "Lista de reglas de seguridad para el NSG"
  type = list(object({
    name                        = string
    priority                    = number
    direction                   = string
    access                      = string
    protocol                    = string
    source_port_range           = string
    destination_port_range      = string
    source_address_prefix       = string
    destination_address_prefix  = string
  }))
  default = []
}

variable "nsg_name" {
  description = "Nombre del Network Security Group"
  type        = string
}
