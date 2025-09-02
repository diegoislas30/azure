variable "name"                { type = string }
variable "resource_group_name" { type = string }
variable "location"            { type = string }

# Tags obligatorias (mismo esquema que ya usas)
variable "tags" {
  type = object({
    UDN      = string
    OWNER    = string
    xpeowner = string
    proyecto = string
    ambiente = string
  })
  validation {
    condition = alltrue([
      length(trimspace(var.tags.UDN))      > 0,
      length(trimspace(var.tags.OWNER))    > 0,
      length(trimspace(var.tags.xpeowner)) > 0,
      length(trimspace(var.tags.proyecto)) > 0,
      length(trimspace(var.tags.ambiente)) > 0
    ])
    error_message = "Todas las tags deben tener valor."
  }
}

# Reglas opcionales
variable "rules" {
  description = "Reglas del NSG (opcional)."
  type = list(object({
    name                        = string
    priority                    = number
    direction                   = string   # Inbound | Outbound
    access                      = string   # Allow | Deny
    protocol                    = string   # Tcp | Udp | *
    source_port_range           = optional(string, "*")
    destination_port_range      = optional(string)
    destination_port_ranges     = optional(list(string))
    source_address_prefix       = optional(string, "*")
    source_address_prefixes     = optional(list(string))
    destination_address_prefix  = optional(string, "*")
    destination_address_prefixes= optional(list(string))
    description                 = optional(string)
  }))
  default = []
}

# Asociaciones opcionales
variable "associate_subnet_ids" {
  type        = list(string)
  default     = []
  description = "IDs de subnets a asociar (opcional)."
}
variable "associate_nic_ids" {
  type        = list(string)
  default     = []
  description = "IDs de NICs a asociar (opcional)."
}
