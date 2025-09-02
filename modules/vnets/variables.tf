#############################################
# VARIABLES DEL MÓDULO VNET
#############################################

# 1) Nombre de la VNET
variable "vnet_name" {
  type        = string
  description = "Nombre de la Virtual Network."
}

# 2) Resource Group
variable "resource_group_name" {
  type        = string
  description = "Nombre del Resource Group destino."
}

# 3) Localización
variable "location" {
  type        = string
  description = "Región de Azure (ej: eastus)."
}

# 4) Prefijo(s) de red de la VNET
variable "address_space" {
  type        = list(string)
  description = "Espacios de direcciones de la VNET (ej: [\"20.0.0.0/16\"])."
}

# 6) DNS (opcional)
variable "dns_servers" {
  type        = list(string)
  description = "Servidores DNS personalizados para la VNET."
  default     = []
}

# 7) Tags
variable "tags" {
  type        = map(string)
  description = "Etiquetas a aplicar."
  default     = {}
}

# 8-12) Subnets (múltiples)
# La CLAVE del mapa es el nombre de la subnet (9)
# El valor incluye el prefijo (10) y asociaciones opcionales (11,12)
variable "subnets" {
  description = <<EOT
Mapa de subnets: nombre => configuración. Ejemplo:
subnets = {
  frontend = {
    address_prefix    = "20.0.10.0/24"
    service_endpoints = ["Microsoft.Storage"]
    nsg_id            = null
    route_table_id    = null
  }
}
EOT

  type = map(object({
    address_prefix     = string
    service_endpoints  = optional(list(string))
    nsg_id             = optional(string)
    route_table_id     = optional(string)
    private_endpoint_network_policies     = optional(bool, true)
    private_link_service_network_policies = optional(bool, true)
  }))

  default = {}
}

# 5) Peerings (opcional)
# Lista de peerings hacia VNETs remotas.
variable "peerings" {
  description = <<EOT
Lista de peerings VNET-VNET. Ejemplo:
peerings = [
  {
    name                        = "peer-to-hub"
    remote_virtual_network_id   = "/subscriptions/.../resourceGroups/rg-hub/providers/Microsoft.Network/virtualNetworks/vnet-hub"
    allow_virtual_network_access = true
    allow_forwarded_traffic      = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
]
EOT

  type = list(object({
    name                            = string
    remote_virtual_network_id       = string
    allow_virtual_network_access    = optional(bool, true)
    allow_forwarded_traffic         = optional(bool, true)
    allow_gateway_transit          = optional(bool, false)
    use_remote_gateways             = optional(bool, false)
  }))
  default = []
}
