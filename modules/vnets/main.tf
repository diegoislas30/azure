resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  for_each = { for s in var.subnets : s.name => s }

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

# Peering: local + remoto
resource "azurerm_virtual_network_peering" "local" {
  for_each = { for p in var.peerings : p.name_local => p }

  name                      = each.value.name_local
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.this.name
  remote_virtual_network_id = each.value.remote_vnet_id

  allow_virtual_network_access = each.value.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.allow_forwarded_traffic
  allow_gateway_transit        = each.value.allow_gateway_transit
  use_remote_gateways          = each.value.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "remote" {
  for_each = { for p in var.peerings : p.name_remote => p }

  name                      = each.value.name_remote
  resource_group_name       = each.value.remote_resource_group
  virtual_network_name      = each.value.remote_vnet_name
  remote_virtual_network_id = azurerm_virtual_network.this.id

  allow_virtual_network_access = each.value.remote_allow_virtual_network_access
  allow_forwarded_traffic      = each.value.remote_allow_forwarded_traffic
  allow_gateway_transit        = each.value.remote_allow_gateway_transit
  use_remote_gateways          = each.value.remote_use_remote_gateways
}
