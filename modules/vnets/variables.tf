variable "vnet_name" {
  description = "Nombre de la Virtual Network"
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del Resource Group donde se crea la VNET"
  type        = string
}

variable "location" {
  description = "Ubicación/Región de Azure donde se desplegará la VNET"
  type        = string
}

variable "address_space" {
  description = "Espacio(s) de direcciones de la VNET"
  type        = list(string)
}

variable "dns_servers" {
  description = "Lista de DNS servers opcionales para la VNET"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Etiquetas aplicadas a la VNET"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "Mapa de subnets a crear dentro de la VNET"
  type = map(object({
    address_prefix    = string
    service_endpoints = optional(list(string))
  }))
  default = {}
}
