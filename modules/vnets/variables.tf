variable "vnet_name" {
  description = "Nombre de la VNET"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group donde se creará la VNET"
  type        = string
}

variable "location" {
  description = "Región de Azure"
  type        = string
}

variable "address_space" {
  description = "Espacio de direcciones de la VNET"
  type        = list(string)
}

variable "subnets" {
  description = "Lista de subnets a crear dentro de la VNET"
  type = list(object({
    name                      = string
    address_prefix            = string
    network_security_group_id = optional(string)
  }))
}

variable "tags" {
  description = "Tags aplicados a los recursos"
  type        = map(string)
  default     = {}
}
