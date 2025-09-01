variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the virtual network will be created"
  type        = string
}

variable "location" {
  description = "The location where the virtual network will be created"
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the virtual network"
  type        = list(string)
}

variable "dns" {
  description = "A list of DNS servers IP addresses"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the virtual network"
  type        = map(string)
  default     = {}
}

## variables para subnets

variable "subnets" {
  description = "Mapa de subnets: nombre => config"
  type = map(object({
    address_prefix    = string
    service_endpoints = optional(list(string))
    nsg_id            = optional(string)
    route_table_id    = optional(string)
    private_endpoint_network_policies    = optional(bool, true)
    private_link_service_network_policies = optional(bool, true)
  }))
  default = {}
}

