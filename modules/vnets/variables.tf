variable "vnet_name" {
  type        = string
  description = "Nombre de la VNet"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group donde se creará la VNet"
}

variable "location" {
  type        = string
  description = "Ubicación de la VNet"
}

variable "address_space" {
  type        = list(string)
  description = "Espacios de direcciones de la VNet"
}

# Objeto de subred simplificado. Ya no contiene nsg_id.
variable "subnets" {
  type = list(object({
    name           = string
    address_prefix = string
  }))
  description = "Lista de subnets a crear dentro de la VNet"
}

# NUEVA VARIABLE: Un mapa para definir las asociaciones.
# La clave es el nombre de la subnet y el valor es el ID del NSG.
variable "subnet_nsg_associations" {
  type        = map(string)
  description = "Mapa de asociaciones entre el nombre de una subnet y el ID de un NSG."
  default     = {}
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags a aplicar a los recursos"
}