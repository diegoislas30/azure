resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

# Subnets
resource "azurerm_subnet" "this" {
  for_each             = { for s in var.subnets : s.name => s }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", null) != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

# Local peering (esta VNet → remota)
resource "azurerm_virtual_network_peering" "local" {
  for_each                  = { for p in var.peerings : p.name => p }
  name                      = "${each.key}-local"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value.remote_vnet_id

  allow_virtual_network_access = each.value.local.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.local.allow_forwarded_traffic
  allow_gateway_transit        = each.value.local.allow_gateway_transit
  use_remote_gateways          = each.value.local.use_remote_gateways
}

# Remote peering (remota → esta VNet)
resource "azurerm_virtual_network_peering" "remote" {
  for_each                  = { for p in var.peerings : p.name => p }
  name                      = "${each.key}-remote"
  resource_group_name       = each.value.remote_rg_name
  virtual_network_name      = each.value.remote_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.this.id

  allow_virtual_network_access = each.value.remote.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.remote.allow_forwarded_traffic
  allow_gateway_transit        = each.value.remote.allow_gateway_transit
  use_remote_gateways          = each.value.remote.use_remote_gateways
}
