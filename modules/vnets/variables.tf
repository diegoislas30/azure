variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which to create the Virtual Network."
  type        = string
}

variable "location" {
  description = "The Azure region where the Virtual Network will be created."
  type        = string
}

variable "address_space" {
  description = "The address space that is used by the Virtual Network."
  type        = list(string)
}

variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
  default     = "default"
}

variable "subnet_prefix" {
  description = "The address prefix to use for the subnet."
  type        = string
  default     = "default"
}

variable "nsg_id" {
  description = "The ID of the Network Security Group to associate with the subnet."
  type        = string
  default     = null
}

variable "route_table_id" {
  description = "The ID of the Route Table to associate with the subnet."
  type        = string
  default     = null
}

variable "peerings" {
  description = "A list of virtual network peerings to create."
  type = list(object({
    name                      = string
    remote_virtual_network_id = string
    allow_virtual_network_access = bool
    allow_forwarded_traffic      = bool
    allow_gateway_transit        = bool
    use_remote_gateways         = bool
    }))
    default = []
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

variable "delegations" {
  description = "A list of delegations for the subnet."
  type = list(object({
    name = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  }))
  default = []
}
