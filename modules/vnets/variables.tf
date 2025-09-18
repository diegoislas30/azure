variable "vnet_name" {
  description = "Nombre de la Virtual Network"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group"
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
  description = "Lista de subnets a crear (con NSG opcional)"
  type = list(object({
    name           = string
    address_prefix = string
    nsg_id         = optional(string)
  }))
}

variable "tags" {
  description = "Tags para aplicar a los recursos"
  type        = map(string)
  default     = {}
}
