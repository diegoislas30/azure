variable "vnet_name" {
  type        = string
  description = "Nombre de la VNet"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group donde se creará la VNet"
}

variable "location" {
  type        = string
  description = "Ubicación de la VNet"
}

variable "address_space" {
  type        = list(string)
  description = "Espacios de direcciones de la VNet"
}

variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
    nsg_id         = optional(string, null)
  }))
  description = "Lista de subnets a crear, con NSG opcional"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags a aplicar"
}
