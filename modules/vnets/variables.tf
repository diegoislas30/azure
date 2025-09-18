variable "vnet_name" {
  description = "Nombre de la VNet"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group de la VNet"
  type        = string
}

variable "location" {
  description = "Ubicación de la VNet"
  type        = string
}

variable "address_space" {
  description = "Espacio de direcciones de la VNet"
  type        = list(string)
}

variable "subnets" {
  description = "Lista de subnets con configuración opcional de delegación"
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
  description = "Lista de peerings (local + remote)"
  type = list(object({
    name               = string
    remote_vnet_id     = string
    remote_vnet_name   = string
    remote_rg_name     = string

    local = object({
      allow_virtual_network_access = bool
      allow_forwarded_traffic      = bool
      allow_gateway_transit        = bool
      use_remote_gateways          = bool
    })

    remote = object({
      allow_virtual_network_access = bool
      allow_forwarded_traffic      = bool
      allow_gateway_transit        = bool
      use_remote_gateways          = bool
    })
  }))
  default = []
}

variable "tags" {
  description = "Etiquetas a aplicar"
  type = object({
    UDN      = string
    OWNER    = string
    xpeowner = string
    proyecto = string
    ambiente = string
  })
}
