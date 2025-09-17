variable "vnet_name" {
  description = "Nombre de la Virtual Network."
  type        = string
}

variable "location" {
  description = "Región de Azure donde se desplegará la VNet."
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group donde se desplegará la VNet."
  type        = string
}

variable "address_space" {
  description = "Espacio(s) de direcciones de la VNet."
  type        = list(string)
}

variable "subnets" {
  description = <<EOT
Lista de subnets a crear con configuraciones opcionales:
- name: nombre de la subnet
- address_prefix: prefijo CIDR de la subnet
- nsg_id (opcional): ID de un NSG a asociar
- route_table_id (opcional): ID de una Route Table a asociar
- delegations (opcional): lista de delegaciones de servicio
EOT

  type = list(object({
    name           = string
    address_prefix = string
    nsg_id         = optional(string)
    route_table_id = optional(string)
    delegations    = optional(list(object({
      name         = string
      service_name = string
      actions      = list(string)
    })), [])
  }))

  default = []
}

variable "peerings" {
  description = <<EOT
Lista de peerings opcionales hacia otras VNets:
- name: nombre del peering
- remote_vnet_id: ID de la VNet remota
- allow_vnet_access (bool, default = true)
- allow_forwarded_traffic (bool, default = false)
- allow_gateway_transit (bool, default = false)
- use_remote_gateways (bool, default = false)
EOT

  type = list(object({
    name                   = string
    remote_vnet_id         = string
    allow_vnet_access      = optional(bool, true)
    allow_forwarded_traffic = optional(bool, false)
    allow_gateway_transit   = optional(bool, false)
    use_remote_gateways     = optional(bool, false)
  }))

  default = []
}

variable "tags" {
  description = "Mapa de etiquetas aplicadas a todos los recursos."
  type        = map(string)
  default     = {}
}
