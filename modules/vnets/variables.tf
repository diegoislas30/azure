variable "vnet_name" {
  description = "Nombre de la Virtual Network."
  type        = string
}

variable "location" {
  description = "Región de Azure."
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group."
  type        = string
}

variable "address_space" {
  description = "Espacio de direcciones de la VNet."
  type        = list(string)
}

variable "subnets" {
  description = "Lista de subnets con configuraciones opcionales (NSG, route table, delegations)."
  type = list(object({
    name            = string
    address_prefix  = string
    nsg_id          = optional(string)
    route_table_id  = optional(string)
    delegations     = optional(list(object({
      name         = string
      service_name = string
      actions      = list(string)
    })))
  }))
  default = []
}

variable "peerings" {
  description = "Configuración de peerings con otras VNets."
  type = list(object({
    name                  = string
    remote_vnet_id        = string
    allow_vnet_access     = optional(bool, true)
    allow_forwarded_traffic = optional(bool, false)
    allow_gateway_transit   = optional(bool, false)
    use_remote_gateways     = optional(bool, false)
  }))
  default = []
}

variable "tags" {
  description = "Etiquetas aplicadas a los recursos."
  type        = map(string)
  default     = {}
}
