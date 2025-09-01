variable "vnet_name"           { type = string }
variable "resource_group_name" { type = string }
variable "location"            { type = string }
variable "address_space"       { type = list(string) }
variable "dns_servers"         { type = list(string)  default = [] }
variable "tags"                { type = map(string)   default = {} }
variable "subnets" {
  type = map(object({
    address_prefix    = string
    service_endpoints = optional(list(string))
    nsg_id            = optional(string)
    route_table_id    = optional(string)
  }))
  default = {}
}
