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

# 7) Tags (OBLIGATORIAS con claves fijas)
variable "tags" {
  description = "Etiquetas obligatorias para la VNET."
  type = object({
    UDN      = string
    OWNER    = string
    xpeowner = string   # <- usa SIEMPRE el mismo nombre en root y en el módulo
    proyecto = string
    ambiente = string
  })
  # sin default => OBLIGATORIA

  # No permitir valores vacíos
  validation {
    condition = alltrue([
      length(trimspace(var.tags.UDN))      > 0,
      length(trimspace(var.tags.OWNER))    > 0,
      length(trimspace(var.tags.xpeowner)) > 0,
      length(trimspace(var.tags.proyecto)) > 0,
      length(trimspace(var.tags.ambiente)) > 0
    ])
    error_message = "Todas las tags (UDN, OWNER, xpeowner, proyecto, ambiente) deben tener valor."
  }

  # Ambiente permitido
  validation {
    condition     = contains(["dev","qa","prod","poc"], lower(trimspace(var.tags.ambiente)))
    error_message = "tags.ambiente debe ser dev, qa, prod o poc."
  }
}


# 8-12) Subnets (múltiples)
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
    allow_gateway_transit           = optional(bool, false)
    use_remote_gateways             = optional(bool, false)
  }))
  default = []
}
