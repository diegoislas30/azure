variable "subnets" {
  description = "Lista de subnets"
  type = list(object({
    name                      = string
    address_prefix            = string
    network_security_group_id = optional(string)
  }))
}

variable "vnet_name" {
  description = "Nombre de la Virtual Network"
  type        = string
}

variable "address_space" {
  description = "Espacio de direcciones de la VNet"
  type        = list(string)
}

variable "resource_group_name" {
  description = "Nombre del Resource Group donde se creará la VNet"
  type        = string
}

variable "location" {
  description = "Región donde se creará la VNet"
  type        = string
}

variable "tags" {
  description = "Etiquetas para los recursos"
  type        = map(string)
  default     = {}
}

