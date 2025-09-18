variable "rt_name" {
  type        = string
  description = "Nombre de la Route Table"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group donde se crea la RT"
}

variable "location" {
  type        = string
  description = "Región donde se crea la RT"
}

variable "routes" {
  description = "Lista de rutas para la tabla de ruteo"
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
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