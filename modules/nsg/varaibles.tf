variable "nsg_name" {
  type        = string
  description = "Nombre del NSG"
}

variable "resource_group_name" {
  type        = string
  description = "RG destino"
}

variable "location" {
  type        = string
  description = "Región"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

# Reglas dinámicas: nombre_regla => definición
variable "security_rules" {
  description = "Mapa de reglas del NSG"
  type = map(object({
    priority                   = number                 # 100–4096
    direction                  = string                 # Inbound | Outbound
    access                     = string                 # Allow | Deny
    protocol                   = string                 # Tcp | Udp | *
    source_port_range          = string                 # "*" o puerto/rango
    destination_port_range     = string                 # "*" o puerto/rango
    source_address_prefix      = string                 # "*" | CIDR | VirtualNetwork | Internet...
    destination_address_prefix = string                 # "*" | CIDR | VirtualNetwork | Internet...
  }))
  default = {}
}
