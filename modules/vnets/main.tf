#############################################
# MÓDULO VNET - main.tf
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
  name                = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = tomap(var.tags)   # <- tags obligatorias (object -> map(string))
}

#############################################
# 8-12) SUBNETS (múltiples) + asociaciones opcionales
#############################################
resource "azurerm_subnet" "this" {
  for_each             = local.subnets
  name                 = each.key
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = lookup(each.value, "service_endpoints", [])
}

# NSG opcional por subnet
resource "azurerm_subnet_network_security_group_association" "nsg" {
  for_each = local.nsg_assoc

  subnet_id                 = azurerm_subnet.this[each.key].id
  network_security_group_id = each.value.nsg_id
}

# Route Table opcional por subnet
resource "azurerm_subnet_route_table_association" "rt" {
  for_each = local.rt_assoc

  subnet_id      = azurerm_subnet.this[each.key].id
  route_table_id = each.value.route_table_id
}

#############################################
# 5) PEERING (opcional) hacia otras VNETs
#############################################
resource "azurerm_virtual_network_peering" "this" {
  for_each = local.peerings_map

  name                      = each.key
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value.remote_virtual_network_id

  allow_virtual_network_access = lookup(each.value, "allow_virtual_network_access", true)
  allow_forwarded_traffic      = lookup(each.value, "allow_forwarded_traffic", true)
  allow_gateway_transit        = lookup(each.value, "allow_gateway_transit", false)
  use_remote_gateways          = lookup(each.value, "use_remote_gateways", false)
}
