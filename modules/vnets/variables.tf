variable "vnet_name" {
  description = "Nombre de la VNet"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group donde se creará la VNet"
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
  description = "Lista de subnets con nombre, prefijo y opcionalmente nsg_id y route_table_id"
  type = list(object({
    name           = string
    address_prefix = string
    nsg_id         = optional(string)
    route_table_id = optional(string)
  }))
}

variable "tags" {
  description = "Etiquetas a aplicar"
  type        = map(string)
  default     = {}
}
