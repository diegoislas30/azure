variable "rt_name" {
  description = "Nombre de la tabla de ruteo"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group donde se crea la RT"
  type        = string
}

variable "location" {
  description = "Ubicación de la RT"
  type        = string
}

variable "routes" {
  description = "Lista de rutas a crear en la tabla de ruteo"
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = optional(string)
  }))
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