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

variable tags {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {
    UDN      = string
    OWNER    = string
    xpeowner = string
    proyecto = string
    ambiente = string

  }
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