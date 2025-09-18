variable "vnet_name" {
  description = "Nombre de la VNet"
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
  description = "Espacios de direcciones para la VNet"
  type        = list(string)
}

variable "subnets" {
  description = "Lista de subnets a crear dentro de la VNet"
  type = list(object({
    name           = string
    address_prefix = string
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  }))
  default = []
}

variable "peerings" {
  description = "Lista de peerings opcionales para la VNet"
  type = list(object({
    name                         = string
    remote_virtual_network_id    = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, false)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  default = []
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
