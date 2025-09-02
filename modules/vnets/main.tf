#############################################
# MÓDULO VNET - main.tf
# Cubre:
# 1) nombre vnet         -> var.vnet_name
# 2) resource group      -> var.resource_group_name
# 3) localización        -> var.location
# 4) prefijo de red      -> var.address_space (list)
# 5) peering (opcional)  -> var.peerings (list)
# 6) DNS (opcional)      -> var.dns_servers (list)
# 7) tags                -> var.tags (map)
# 8) subnet(s)           -> var.subnets (map)
# 9) nombre de subnet    -> clave del map var.subnets
# 10) prefijo de subnet  -> subnets[].address_prefix
# 11) NSG (opcional)     -> subnets[].nsg_id
# 12) tabla de ruteo     -> subnets[].route_table_id
#############################################

#############################################
# 0) Derivados legibles (para asociaciones y peering)
#############################################
locals {
  # Subnets que vienen por variable (mapa nombre -> config)
  subnets = var.subnets

  # Solo las subnets con NSG definido (no nulo)
  nsg_assoc = {
    for name, cfg in local.subnets :
    name => cfg
    if try(cfg.nsg_id, null) != null
  }

  # Solo las subnets con Route Table definida (no nula)
  rt_assoc = {
    for name, cfg in local.subnets :
    name => cfg
    if try(cfg.route_table_id, null) != null
  }

  # Peering: convertimos la lista a mapa por nombre para for_each
  peerings_map = {
    for p in var.peerings :
    p.name => p
  }
}

#############################################
# 1-7) VNET (nombre, RG, location, address space, DNS, tags)
#############################################
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name                     # (1)
  resource_group_name = var.resource_group_name           # (2)
  location            = var.location                      # (3)
  address_space       = var.address_space                 # (4) ej: ["20.0.0.0/16"]
  dns_servers         = var.dns_servers                   # (6) opcional
  tags                = var.tags                          # (7)
}

#############################################
# 8-12) SUBNETS (múltiples) + asociaciones opcionales
#############################################
# 8/9/10: crear subnets a partir del mapa var.subnets
resource "azurerm_subnet" "this" {
  for_each             = local.subnets
  name                 = each.key                         # (9) nombre = clave del mapa
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]      # (10) prefijo subnet
  service_endpoints    = lookup(each.value, "service_endpoints", [])
}

# 11: asociar NSG si la subnet lo trae
resource "azurerm_subnet_network_security_group_association" "nsg" {
  for_each = local.nsg_assoc

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.nsg_id           # (11)
}

# 12: asociar Route Table si la subnet lo trae
resource "azurerm_subnet_route_table_association" "rt" {
  for_each = local.rt_assoc

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value.route_table_id              # (12)
}

#############################################
# 5) PEERING (opcional) hacia otras VNETs
#############################################
resource "azurerm_virtual_network_peering" "this" {
  for_each = local.peerings_map

  name                      = each.key                    # nombre del peering
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value.remote_virtual_network_id

  # Defaults seguros y entendibles
  allow_virtual_network_access = lookup(each.value, "allow_virtual_network_access", true)
  allow_forwarded_traffic      = lookup(each.value, "allow_forwarded_traffic", true)
  allow_gateway_transit        = lookup(each.value, "allow_gateway_transit", false)
  use_remote_gateways          = lookup(each.value, "use_remote_gateways", false)
}

#############################################
# NOTAS DE USO (variables esperadas)
#
# variables mínimas:
# - vnet_name            (string)
# - resource_group_name  (string)
# - location             (string)
# - address_space        (list(string))   ej: ["20.0.0.0/16"]
# - dns_servers          (list(string))   opcional, default []
# - tags                 (map(string))    opcional, default {}
#
# - subnets (map) donde la CLAVE es el nombre de la subnet (9) y el valor:
#   {
#     address_prefix    = string          # (10)
#     service_endpoints = optional(list(string))
#     nsg_id            = optional(string)        # (11)
#     route_table_id    = optional(string)        # (12)
#   }
#
# - peerings (list) opcional:
#   [
#     {
#       name                          = string
#       remote_virtual_network_id     = string
#       allow_virtual_network_access  = optional(bool, true)
#       allow_forwarded_traffic       = optional(bool, true)
#       allow_gateway_transit         = optional(bool, false)
#       use_remote_gateways           = optional(bool, false)
#     }
#   ]
#############################################
