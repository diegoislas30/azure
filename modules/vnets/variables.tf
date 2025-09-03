variable vnet_name {
  description = "The name of the virtual network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  type        = string
}

variable "location" {
  description = "The Azure region where the virtual network will be created."
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network."
  type        = list(string)
}

variable "dns_servers" {
  description = "A list of DNS servers IP addresses."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the resource group"
  type        = object({
    UDN       = string
    OWNER     = string
    xpeowner  = string
    proyecto  = string
    ambiente  = string
  })
  
}

# Mapa de subnets a crear: cada clave es el nombre de la subnet
variable "subnets" {
  description = "Mapa de subnets: nombre => configuración"
  type = map(object({
    address_prefix     = string                # CIDR de la subnet (dentro del address_space)
    service_endpoints  = optional(list(string))# Ej: ["Microsoft.Storage","Microsoft.Sql"]
    nsg_id             = optional(string)      # ID de un NSG a asociar (opcional)
    route_table_id     = optional(string)      # ID de Route Table a asociar (opcional)
    private_endpoint_network_policies     = optional(bool, true)
    private_link_service_network_policies = optional(bool, true)
  }))
  default = {}
}

# NUEVO: definición opcional de peerings DESDE ESTA VNET hacia otras+

variable "peerings" {
  description = <<EOT
Lista de peerings que se crearán DESDE esta VNET hacia otras.
Ojo: el peering en Azure es bidireccional — necesitas crear el par en la VNET remota también (o desde este módulo, apuntando a ambas).
Campos:
- name: nombre del peering (único en esta VNET)
- remote_virtual_network_id: ID de la VNET remota (de otro módulo o existente)
- allow_virtual_network_access: (default true) permite tráfico VNet<->VNet
- allow_forwarded_traffic: (default true) permite tráfico reenviado (NVA)
- allow_gateway_transit: (default false) habilita tránsito de gateway (en el HUB)
- use_remote_gateways: (default false) usa el gateway remoto (en el SPOKE)
EOT
  type = list(object({
    name                         = string
    remote_virtual_network_id    = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, true)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  default = []
}

