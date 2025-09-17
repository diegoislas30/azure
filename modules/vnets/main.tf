resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "this" {
  for_each             = { for s in var.subnets : s.name => s }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value.address_prefix]

  dynamic "delegation" {
    for_each = var.delegations
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

# NSG opcional (solo aplica a la primera subnet de ejemplo)
resource "azurerm_subnet_network_security_group_association" "this" {
  count                     = var.nsg_id != null && length(var.subnets) > 0 ? 1 : 0
  subnet_id                 = values(azurerm_subnet.this)[0].id
  network_security_group_id = var.nsg_id
}

# Tabla de ruteo opcional (solo aplica a la primera subnet de ejemplo)
resource "azurerm_subnet_route_table_association" "this" {
  count          = var.route_table_id != null && length(var.subnets) > 0 ? 1 : 0
  subnet_id      = values(azurerm_subnet.this)[0].id
  route_table_id = var.route_table_id
}

# Peerings opcionales
resource "azurerm_virtual_network_peering" "this" {
  for_each                      = { for p in var.peerings : p.name => p }
  name                          = each.value.name
  resource_group_name           = var.resource_group_name
  virtual_network_name          = azurerm_virtual_network.this.name
  remote_virtual_network_id     = each.value.remote_virtual_network_id
  allow_virtual_network_access  = each.value.allow_virtual_network_access
  allow_forwarded_traffic       = each.value.allow_forwarded_traffic
  allow_gateway_transit         = each.value.allow_gateway_transit
  use_remote_gateways           = each.value.use_remote_gateways
}
