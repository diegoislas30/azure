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
  description = "A mapping of tags to assign to the resources"
  type        = object({
    UDN       = string
    OWNER     = string
    xpeowner  = string
    proyecto  = string
    ambiente  = string
  })
  
}
